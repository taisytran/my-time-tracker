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
require 'rails_helper'

RSpec.describe BillingRateDayOfWeek, type: :model do
end
