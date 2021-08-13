# == Schema Information
#
# Table name: billing_rate_day_of_weeks
#
#  id                    :integer          not null, primary key
#  day_of_week           :string
#  start_working_time    :time
#  finish_working_time   :time
#  inside_rate_per_hour  :decimal(8, 2)    default(0.0)
#  outside_rate_per_hour :decimal(8, 2)    default(0.0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class BillingRateWeekday < ApplicationRecord
  DAYS = %w(monday tuesday wednesday thurday friday)

  has_one :billing_rate_by_day,  as: :billable

  # TODO: handle soft delete for the old ones

  class << self
    DAYS.each do |day|
      define_method day do
        find_by_day(day)
      end
    end
  end
end
