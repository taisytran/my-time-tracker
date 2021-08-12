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
        allow_any_instance_of(TimeSheetEntry).to receive(:calculate_hour_billed).and_return nil
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
        allow_any_instance_of(TimeSheetEntry).to receive(:calculate_hour_billed).and_return nil

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

  describe "#Examples" do
    before do
      %w(monday wednesday friday).each do |day|
        billing_rate_day_of_week = create(
          :billing_rate_day_of_week,
          day_of_week: day,
          start_working_time: "7am",
          finish_working_time: "7pm",
          inside_rate_per_hour: 22,
          outside_rate_per_hour: 34
        )
        BillingRateByDay.create(billable: billing_rate_day_of_week)
      end

      %w(tuesday thursday).each do |day|
        billing_rate_day_of_week = create(
          :billing_rate_day_of_week,
          day_of_week: day,
          start_working_time: "5am",
          finish_working_time: "5pm",
          inside_rate_per_hour: 25,
          outside_rate_per_hour: 35
        )
        BillingRateByDay.create(billable: billing_rate_day_of_week)
      end

      billing_rate_day_of_weekend = create(
        :billing_rate_day_of_weekend,
        rate_per_hour: 47
      )
      BillingRateByDay.create(billable: billing_rate_day_of_weekend)
    end

    context "15/04/2019 10:00 - 17:00" do
      it "total rate is $154" do
        time_sheet_entry = create(
          :time_sheet_entry,
          date_of_entry: "2019-04-15",
          start_time: "10:00",
          finish_time: "17:00"
        )
        expect(time_sheet_entry.hour_billed).to eq 154
      end
    end

    context "16/04/2019 12:00 - 20:15" do
      it "total rate is $238.75" do
        time_sheet_entry = create(
          :time_sheet_entry,
          date_of_entry: "2019-04-16",
          start_time: "12:00",
          finish_time: "20:15"
        )
        expect(time_sheet_entry.hour_billed).to eq 238.75
      end
    end

    context "17/04/2019 4:00 - 21:30" do
      it "total rate is $154" do
        time_sheet_entry = create(
          :time_sheet_entry,
          date_of_entry: "2019-04-17",
          start_time: "4:00",
          finish_time: "21:30"
        )
        expect(time_sheet_entry.hour_billed).to eq 451
      end
    end

    context "20/04/2019 15:30 - 20:00" do
      it "total rate is $211.5" do
        time_sheet_entry = create(
          :time_sheet_entry,
          date_of_entry: "2019-04-20",
          start_time: "15:30",
          finish_time: "20:00"
        )
        expect(time_sheet_entry.hour_billed).to eq 211.5
      end
    end

    context "17/04/2019 02:00 - 6:00" do
      it "total rate is $136" do
        time_sheet_entry = create(
          :time_sheet_entry,
          date_of_entry: "2019-04-17",
          start_time: "2:00",
          finish_time: "6:00"
        )
        expect(time_sheet_entry.hour_billed).to eq 136
      end
    end
  end
end
