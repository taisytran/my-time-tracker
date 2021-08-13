class RateOfWeekendService
  attr_accessor :billing_rate_weekend, :entry_start_time, :entry_finish_time

  def initialize(entry_day:, entry_start_time:, entry_finish_time:)
    @billing_rate_weekend = BillingRateWeekend.send(entry_day)
    @entry_start_time = entry_start_time
    @entry_finish_time = entry_finish_time
  end

  def execute
    total_hours = (entry_finish_time - entry_start_time) / 3600
    total_rate = total_hours * billing_rate_weekend.rate_per_hour

    [total_rate, true]
  rescue StandardError => e
    [e.message, false]
  end
end
