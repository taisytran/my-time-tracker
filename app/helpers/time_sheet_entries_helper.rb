module TimeSheetEntriesHelper
  def format_time(start_time, finish_time)
    fmt_code = "%H:%M"
    "#{start_time.strftime(fmt_code)} - #{finish_time.strftime(fmt_code)}"
  end

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

  def format_amount(amount)
    number_to_currency(amount)
  end
end
