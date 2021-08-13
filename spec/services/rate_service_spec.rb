require 'rails_helper'

RSpec.describe RateService, type: :service do
  describe "#execute" do
    context "Time sheet entry is a day of week" do
      it "returns output correctly" do
        allow(BillingRateByDay).to receive(:any?).and_return true
        time_sheet_entry = build(:time_sheet_entry, date_of_entry: "2021-08-11")

        allow_any_instance_of(RateOfWeekdayService).to receive(:execute).and_return [100, true]
        service = described_class.new(time_sheet_entry)

        expect_any_instance_of(RateOfWeekdayService).to receive(:execute).once
        data, ok = service.execute

        expect(data).to eq 100
        expect(ok).to be_truthy
      end
    end

    context "Time sheet entry is a day of weekend" do
      it "returns output correctly" do
        allow(BillingRateByDay).to receive(:any?).and_return true
        time_sheet_entry = build(:time_sheet_entry, date_of_entry: "2021-08-01")

        allow_any_instance_of(RateOfWeekendService).to receive(:execute).and_return [100, true]
        service = described_class.new(time_sheet_entry)

        expect_any_instance_of(RateOfWeekendService).to receive(:execute).once
        data, ok = service.execute

        expect(data).to eq 100
        expect(ok).to be_truthy
      end
    end
  end
end
