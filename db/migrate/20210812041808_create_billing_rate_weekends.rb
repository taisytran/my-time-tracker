class CreateBillingRateWeekends < ActiveRecord::Migration[6.0]
  def change
    create_table :billing_rate_weekends do |t|
      t.string :day
      t.decimal :rate_per_hour, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
