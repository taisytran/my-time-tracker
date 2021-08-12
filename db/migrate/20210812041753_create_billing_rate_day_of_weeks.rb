class CreateBillingRateDayOfWeeks < ActiveRecord::Migration[6.0]
  def change
    create_table :billing_rate_day_of_weeks do |t|
      t.string :day_of_week
      t.time :start_working_time
      t.time :finish_working_time
      t.decimal :inside_rate_per_hour, precision: 8, scale: 2, default: 0.0
      t.decimal :outside_rate_per_hour, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
