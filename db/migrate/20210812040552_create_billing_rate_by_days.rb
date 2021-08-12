class CreateBillingRateByDays < ActiveRecord::Migration[6.0]
  def change
    create_table :billing_rate_by_days do |t|
      t.references :billable, polymorphic: true

      t.timestamps
    end
  end
end
