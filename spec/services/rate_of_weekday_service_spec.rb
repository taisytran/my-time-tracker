require 'rails_helper'

RSpec.describe RateOfWeekdayService, type: :service do
  describe "#execute" do
    context "Time sheet entry is in period of working hours" do
      it "returns data correctly" do
        billing_rate_weekday = create(
          :billing_rate_weekday,
          day: "monday",
          start_working_time: "8:00am",
          finish_working_time: "18:00pm",
          inside_rate_per_hour: 10,
          outside_rate_per_hour: 20
        )
        BillingRateByDay.create(billable: billing_rate_weekday)

        ts_entry = build(
          :time_sheet_entry,
          date_of_entry: "2021-08-09",
          start_time: "9:00am",
          finish_time: "18:00pm"
        )

        total_rate, ok = described_class.new(
          entry_day: "monday",
          entry_start_time: ts_entry.start_time,
          entry_finish_time: ts_entry.finish_time
        ).execute

        expect(ok).to be_truthy
        expect(total_rate).to eq 90 # (18 - 9) * 10
      end
    end

    context "Time sheet entry started before begin of working hours and end sooner" do
      it "returns data correctly" do
        billing_rate_weekday = create(
          :billing_rate_weekday,
          day: "monday",
          start_working_time: "8:00am",
          finish_working_time: "18:00pm",
          inside_rate_per_hour: 10,
          outside_rate_per_hour: 20
        )
        BillingRateByDay.create(billable: billing_rate_weekday)

        ts_entry = build(
          :time_sheet_entry,
          date_of_entry: "2021-08-09",
          start_time: "7:00am",
          finish_time: "17:00pm"
        )

        total_rate, ok = described_class.new(
          entry_day: "monday",
          entry_start_time: ts_entry.start_time,
          entry_finish_time: ts_entry.finish_time
        ).execute

        expect(ok).to be_truthy
        expect(total_rate).to eq 110 # ((17-8) * 10) + ((8-7) * 20)
      end
    end

    context "Time sheet entry started after begin of working hours and end later" do
      it "returns data correctly" do
        billing_rate_weekday = create(
          :billing_rate_weekday,
          day: "monday",
          start_working_time: "8:00am",
          finish_working_time: "18:00pm",
          inside_rate_per_hour: 10,
          outside_rate_per_hour: 20
        )
        BillingRateByDay.create(billable: billing_rate_weekday)

        ts_entry = build(
          :time_sheet_entry,
          date_of_entry: "2021-08-09",
          start_time: "9:00am",
          finish_time: "20:00pm"
        )

        total_rate, ok = described_class.new(
          entry_day: "monday",
          entry_start_time: ts_entry.start_time,
          entry_finish_time: ts_entry.finish_time
        ).execute

        expect(ok).to be_truthy
        expect(total_rate).to eq 130 # ((18-9) * 10) + ((20-18) * 20)
      end
    end

    context "Time sheet entry of finish time less than begin of working hour" do
      it "returns data correctly" do
        billing_rate_weekday = create(
          :billing_rate_weekday,
          day: "monday",
          start_working_time: "8:00am",
          finish_working_time: "18:00pm",
          inside_rate_per_hour: 10,
          outside_rate_per_hour: 20
        )
        BillingRateByDay.create(billable: billing_rate_weekday)

        ts_entry = build(
          :time_sheet_entry,
          date_of_entry: "2021-08-09",
          start_time: "5:00am",
          finish_time: "7:00am"
        )

        total_rate, ok = described_class.new(
          entry_day: "monday",
          entry_start_time: ts_entry.start_time,
          entry_finish_time: ts_entry.finish_time
        ).execute

        expect(ok).to be_truthy
        expect(total_rate).to eq 40 # (7-5) * 20
      end
    end

    context "Time sheet entry of start time greater than end of working hour" do
      it "returns data correctly" do
        billing_rate_weekday = create(
          :billing_rate_weekday,
          day: "monday",
          start_working_time: "8:00am",
          finish_working_time: "18:00pm",
          inside_rate_per_hour: 10,
          outside_rate_per_hour: 20
        )
        BillingRateByDay.create(billable: billing_rate_weekday)

        ts_entry = build(
          :time_sheet_entry,
          date_of_entry: "2021-08-09",
          start_time: "20:00pm",
          finish_time: "23:00pm"
        )

        total_rate, ok = described_class.new(
          entry_day: "monday",
          entry_start_time: ts_entry.start_time,
          entry_finish_time: ts_entry.finish_time
        ).execute

        expect(ok).to be_truthy
        expect(total_rate).to eq 60 # (23-20) * 20
      end
    end
  end
end
