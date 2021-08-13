require 'rails_helper'

RSpec.describe RateOfWeekendService, type: :service do
  describe "#execute" do
    context "Time sheet entry is on the weekend" do
      it "returns data correctly" do
        billing_rate_weekend = create(
          :billing_rate_weekend,
          day: "sunday",
          rate_per_hour: 47
        )
        BillingRateByDay.create(billable: billing_rate_weekend)

        ts_entry = create(
          :time_sheet_entry,
          date_of_entry: "2021-08-01",
          start_time: "9:00am",
          finish_time: "18:00pm"
        )

        total_rate, ok = described_class.new(
          entry_day: "sunday",
          entry_start_time: ts_entry.start_time,
          entry_finish_time: ts_entry.finish_time
        ).execute

        expect(ok).to be_truthy
        expect(total_rate).to eq 423 # (18-9) * 47
      end
    end
  end
end
