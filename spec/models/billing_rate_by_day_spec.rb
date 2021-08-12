# == Schema Information
#
# Table name: billing_rate_by_days
#
#  id            :integer          not null, primary key
#  billable_id   :integer
#  billable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe BillingRateByDay, type: :model do
end
