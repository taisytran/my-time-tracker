class RateOfWeekdayService
  attr_accessor :billing_rate_weekday, :entry_start_time, :entry_finish_time

  class RateNotFoundForWeekday < StandardError; end
  class EntryTimeNotPresence < StandardError; end

  def initialize(entry_day:, entry_start_time:, entry_finish_time:)
    @billing_rate_weekday = BillingRateWeekday.send(entry_day)
    @entry_start_time = entry_start_time
    @entry_finish_time = entry_finish_time
  end

  def execute
    raise RateNotFoundForWeekday, "Missing rate for weekdays" if missing_rate?
    raise EntryTimeNotPresence, "Start Time or Finish time are empty" if missing_entry_time?

    total_inside_hours_rate = total_inside_working_hours * billing_rate_weekday.inside_rate_per_hour
    total_outside_hours_rate = total_outside_working_hours * billing_rate_weekday.outside_rate_per_hour
    total_rate = total_inside_hours_rate + total_outside_hours_rate

    [total_rate, true]
  rescue StandardError => e
    [e.message, false]
  end

  private

  def missing_rate?
    billing_rate_weekday.blank?
  end

  def missing_entry_time?
    entry_start_time.blank? || entry_finish_time.blank?
  end

  def total_inside_working_hours
    return 0.0 if outside_working_hours?

    begin_time = [entry_start_time, billing_rate_weekday.start_working_time].max
    end_time = [entry_finish_time, billing_rate_weekday.finish_working_time].min

    (end_time - begin_time) / 3600
  end

  def total_outside_working_hours
    return (entry_finish_time - entry_start_time) / 3600 if outside_working_hours?

    begin_time = [entry_start_time, billing_rate_weekday.start_working_time].min
    end_time = [entry_finish_time, billing_rate_weekday.finish_working_time].max

    duration_at_end = (end_time - billing_rate_weekday.finish_working_time).to_f
    duration_at_begin = (begin_time - billing_rate_weekday.start_working_time).to_f

    (duration_at_end - duration_at_begin) / 3600
  end

  def outside_working_hours?
    entry_finish_time < billing_rate_weekday.start_working_time ||
      entry_start_time > billing_rate_weekday.finish_working_time
  end
end
