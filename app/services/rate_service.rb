class RateService
  attr_accessor :time_sheet_entry

  def initialize(time_sheet_entry)
    @time_sheet_entry = time_sheet_entry
  end

  def execute
    rate_or_err_message, ok = nil
    params = {
      entry_day: entry_day,
      entry_start_time: time_sheet_entry.start_time,
      entry_finish_time: time_sheet_entry.finish_time
    }

    if weekday?
      rate_or_err_message, ok = RateOfWeekdayService.new(params).execute
    elsif weekend?
      rate_or_err_message, ok = RateOfWeekendService.new(params).execute
    end
    raise rate_or_err_message unless ok

    [rate_or_err_message, true]
  rescue StandardError => e
    [e.message, false]
  end

  private

  def entry_day
    @_entry_day ||= time_sheet_entry.date_of_entry.strftime("%A").downcase
  end

  def weekday?
    BillingRateWeekday::DAYS.include?(entry_day)
  end

  def weekend?
    BillingRateWeekend::DAYS.include?(entry_day)
  end
end
