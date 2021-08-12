# == Schema Information
#
# Table name: billing_rate_day_of_weekends
#
#  id            :integer          not null, primary key
#  rate_per_hour :decimal(8, 2)    default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe BillingRateDayOfWeekend, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
