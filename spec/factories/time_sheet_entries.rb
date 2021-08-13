FactoryBot.define do
  factory :time_sheet_entry do
    date_of_entry { "2019-04-16" }
    start_time { "12:00pm" }
    finish_time { "20:15pm" }
  end

  trait :with_rate do
    before(:create) do |time_sheet_entry, options|
      entry_day = time_sheet_entry.date_of_entry.strftime("%A").downcase
      is_weekday = BillingRateWeekday::DAYS.include?(entry_day)

      if is_weekday && BillingRateWeekday.send(entry_day).blank?
        billing_rate_weekday = create(
          :billing_rate_weekday,
          day: entry_day,
          start_working_time: "7am",
          finish_working_time: "7pm",
          inside_rate_per_hour: 22,
          outside_rate_per_hour: 34
        )
        BillingRateByDay.create(billable: billing_rate_weekday)
      else
        billing_rate_weekend = create(
          :billing_rate_weekend,
          day: entry_day,
          rate_per_hour: 22
        )
        BillingRateByDay.create(billable: billing_rate_weekend)
      end
    end
  end
end
