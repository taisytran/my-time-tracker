class RateService
  attr_accessor :time_sheet_entry

  def initialize(time_sheet_entry)
    @time_sheet_entry = time_sheet_entry
  end

  def execute
    rate_or_err_message, ok = nil

    if weekday?
      rate_or_err_message, ok = RateOfWeekdayService.new(
        weekday_name: weekday_name,
        entry_start_time: @time_sheet_entry.start_time,
        entry_finish_time: @time_sheet_entry.finish_time
      ).execute
    elsif weekend?
      rate_or_err_message, ok = RateOfWeekendService.new(
        entry_start_time: @time_sheet_entry.start_time,
        entry_finish_time: @time_sheet_entry.finish_time
      ).execute
    end
    raise rate_or_err_message unless ok

    [rate_or_err_message, true]
  rescue StandardError => e
    [e.message, false]
  end

  private

  def weekday_name
    @_weekday_name ||= @time_sheet_entry.date_of_entry.strftime("%A").downcase
  end

  def weekday?
    BillingRateDayOfWeek::DAY_OF_WEEK.include?(weekday_name)
  end

  def weekend?
    BillingRateDayOfWeekend::DAY_OF_WEEKEND.include?(weekday_name)
  end
end
