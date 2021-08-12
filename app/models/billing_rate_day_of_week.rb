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
class BillingRateDayOfWeek < ApplicationRecord
  has_one :billing_rate_by_day,  as: :billable

  DAY_OF_WEEK = %w(monday tuesday wednesday thurday friday)

  # TODO: add status active/inactive to make sure once we update the new rate, the old one is still here

  class << self
    DAY_OF_WEEK.each do |weekday|
      define_method :"#{weekday}" do
        find_by_day_of_week(weekday)
      end
    end
  end
end
