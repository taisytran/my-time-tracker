class RateOfWeekendService
  attr_accessor :billing_rate_day_of_weekend, :entry_start_time, :entry_finish_time

  def initialize(entry_start_time:, entry_finish_time:)
    @billing_rate_day_of_weekend = BillingRateDayOfWeekend.first
    @entry_start_time = entry_start_time
    @entry_finish_time = entry_finish_time
  end

  def execute
    total_hours = (@entry_finish_time - @entry_start_time) / 3600
    total_rate = total_hours * billing_rate_day_of_weekend.rate_per_hour

    [total_rate, true]
  rescue StandardError => e
    [e.message, false]
  end
end
