# == Schema Information
#
# Table name: billing_rate_day_of_weekends
#
#  id            :integer          not null, primary key
#  rate_per_hour :decimal(8, 2)    default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class BillingRateWeekend < ApplicationRecord
  has_one :billing_rate_by_day,  as: :billable

  FIXED_RATE = 47
  DAYS = %w(saturday sunday)

  class << self
    DAYS.each do |day|
      define_method day do
        find_by_day(day)
      end
    end
  end
end
