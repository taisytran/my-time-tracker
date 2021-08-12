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
class BillingRateByDay < ApplicationRecord
  belongs_to :billable, polymorphic: true, dependent: :destroy
end
