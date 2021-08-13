FactoryBot.define do
  factory :billing_rate_weekend do
    day { "sunday" }
    rate_per_hour { 47 }
  end

  after(:create) do |billing_rate_weekday|
    BillingRateByDay.create(billable: billing_rate_weekday)
  end
end
