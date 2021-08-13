BillingRateByDay.destroy_all

puts "Generating default Billing rate by day..."

%w(monday wednesday friday).each do |day|
  billind_rate_weekday = BillingRateWeekday.create(
    day: day,
    start_working_time: "7am",
    finish_working_time: "7pm",
    inside_rate_per_hour: 22,
    outside_rate_per_hour: 34
  )
  BillingRateByDay.create(billable: billind_rate_weekday)
end

%w(tuesday thursday).each do |day|
  billing_rate_weekday  = BillingRateWeekday.create(
    day: day,
    start_working_time: "5am",
    finish_working_time: "5pm",
    inside_rate_per_hour: 25,
    outside_rate_per_hour: 35
  )
  BillingRateByDay.create(billable: billing_rate_weekday)
end

%w(saturday sunday).each do |day|
  billing_rate_weekend = BillingRateWeekend.create(
    day: day,
    rate_per_hour: 47
  )
  BillingRateByDay.create(billable: billing_rate_weekend)
end

puts "Done!!!"
