FactoryBot.define do
  factory :billing_rate_weekday do
    day { "tuesday" }
    start_working_time { "5:00:00 AM" }
    finish_working_time { "5:00:00 PM" }
    inside_rate_per_hour { 25 }
    outside_rate_per_hour { 35 }
  end

  after(:create) do |billing_rate_weekday|
    BillingRateByDay.create(billable: billing_rate_weekday)
  end
end
