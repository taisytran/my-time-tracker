class RateOfWeekdayService
  attr_accessor :billing_rate_day_of_week, :entry_start_time, :entry_finish_time

  def initialize(weekday_name:, entry_start_time:, entry_finish_time:)
    @billing_rate_day_of_week = BillingRateDayOfWeek.send(:"#{weekday_name}")
    @entry_start_time = entry_start_time
    @entry_finish_time = entry_finish_time
  end

  def execute
    total_inside_hours_rate = total_inside_working_hours * billing_rate_day_of_week.inside_rate_per_hour
    total_outside_hours_rate = total_outside_working_hours * billing_rate_day_of_week.outside_rate_per_hour
    total_rate = total_inside_hours_rate + total_outside_hours_rate

    [total_rate, true]
  rescue StandardError => e
    [e.message, false]
  end

  private

  def total_inside_working_hours
    return 0.0 if outside_working_hours?

    begin_time = [@entry_start_time, @billing_rate_day_of_week.start_working_time].max
    end_time = [@entry_finish_time, @billing_rate_day_of_week.finish_working_time].min

    (end_time - begin_time) / 3600
  end

  def total_outside_working_hours
    return (@entry_finish_time - @entry_start_time) / 3600 if outside_working_hours?

    begin_time = [@entry_start_time, @billing_rate_day_of_week.start_working_time].min
    end_time = [@entry_finish_time, @billing_rate_day_of_week.finish_working_time].max

    duration_at_end = (end_time - @billing_rate_day_of_week.finish_working_time).to_f
    duration_at_begin = (begin_time - @billing_rate_day_of_week.start_working_time).to_f

    (duration_at_end - duration_at_begin) / 3600
  end

  def outside_working_hours?
    @entry_finish_time < @billing_rate_day_of_week.start_working_time ||
      @entry_start_time > @billing_rate_day_of_week.finish_working_time
  end
end
