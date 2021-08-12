# == Schema Information
#
# Table name: billing_rate_day_of_weekends
#
#  id            :integer          not null, primary key
#  rate_per_hour :decimal(8, 2)    default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class BillingRateDayOfWeekend < ApplicationRecord
  has_one :billing_rate_by_day,  as: :billable

  FIXED_RATE = 47
  DAY_OF_WEEKEND = %w(saturday sunday)
end
