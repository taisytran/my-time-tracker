class RateOfWeekendService
  attr_accessor :billing_rate_weekend, :entry_start_time, :entry_finish_time

  class RateNotFoundForWeekend < StandardError; end
  class EntryTimeNotPresence < StandardError; end

  REGULAR_RATE = 1.5

  def initialize(entry_day:, entry_start_time:, entry_finish_time:)
    @billing_rate_weekend = BillingRateWeekend.send(entry_day)
    @entry_start_time = entry_start_time
    @entry_finish_time = entry_finish_time
  end

  def execute
    raise RateNotFoundForWeekend, "Missing rate for weekend" if missing_rate?
    raise EntryTimeNotPresence, "Start Time or Finish time are empty" if missing_entry_time?

    total_hours = (entry_finish_time - entry_start_time) / 3600
    total_rate = total_hours * billing_rate_weekend.rate_per_hour

    if overtime?
      total_rate = ((total_rate - total_rate_for_first_four_hours) * REGULAR_RATE) + total_rate_for_first_four_hours
    end

    [total_rate, true]
  rescue StandardError => e
    [e.message, false]
  end

  private

  def missing_rate?
    billing_rate_weekend.blank?
  end

  def missing_entry_time?
    entry_start_time.blank? || entry_finish_time.blank?
  end

  def total_rate_for_first_four_hours
    4 * billing_rate_weekend.rate_per_hour
  end

  def overtime?
    ENV["OVERTIME_EXPERIMENT_ENABLED"] == "true" && entry_finish_time - entry_start_time > 4
  end
end
