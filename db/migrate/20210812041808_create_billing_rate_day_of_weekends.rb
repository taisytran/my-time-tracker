class CreateBillingRateDayOfWeekends < ActiveRecord::Migration[6.0]
  def change
    create_table :billing_rate_day_of_weekends do |t|
      t.decimal :rate_per_hour, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
