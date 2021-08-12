# == Schema Information
#
# Table name: time_sheet_entries
#
#  id            :integer          not null, primary key
#  date_of_entry :date             not null
#  start_time    :time             not null
#  finish_time   :time             not null
#  hour_billed   :decimal(8, 2)    default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe TimeSheetEntry, type: :model do
  describe "#validations" do
    it { should validate_presence_of(:date_of_entry) }
    it { should validate_presence_of(:finish_time) }
    it { should validate_presence_of(:start_time) }

    context "Current time sheet entry have overlapping with the existed one" do
      it "raises validation error" do
        create(
          :time_sheet_entry,
          date_of_entry: "2021-08-11",
          start_time: "8am",
          finish_time: "18pm"
        )
        current_ts_entry = build(
          :time_sheet_entry,
          date_of_entry: "2021-08-11",
          start_time: "10am",
          finish_time: "19pm"
        )
        current_ts_entry.save

        error_message = "Time sheet have overlapped"
        expect(current_ts_entry.errors.full_messages.include?(error_message)).to be_truthy
      end
    end

    context "Date of entry is in future" do
      it "raises validation error" do
        travel_to Date.new(2020, 12, 12) do
          current_ts_entry = build(
            :time_sheet_entry,
            date_of_entry: "2020-12-15",
            start_time: "10am",
            finish_time: "19pm"
          )
          current_ts_entry.save

          error_message = "Date of entry can not be in future"
          expect(current_ts_entry.errors.full_messages.include?(error_message)).to be_truthy
        end
      end
    end
  end
end
