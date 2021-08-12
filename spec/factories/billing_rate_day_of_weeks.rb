FactoryBot.define do
  factory :billing_rate_day_of_week do
    day_of_week { "tuesday" }
    start_working_time { "5:00:00 AM" }
    finish_working_time { "5:00:00 PM" }
    inside_rate_per_hour { 25 }
    outside_rate_per_hour { 35 }
  end
end
