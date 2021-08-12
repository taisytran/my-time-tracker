class CreateTimeSheetEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :time_sheet_entries do |t|
      t.date :date_of_entry, null: false, index: true
      t.time :start_time, null: false
      t.time :finish_time, null: false
      t.decimal :hour_billed, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
