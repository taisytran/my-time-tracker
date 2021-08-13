require 'rails_helper'

RSpec.describe TimeSheetEntriesController, type: :controller do
  describe "GET /index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    context "There are some time_sheet_entries" do
      it do
        create(:time_sheet_entry, :with_rate)

        get :index
        expect(response).to have_http_status(:success)
        expect(assigns(:time_sheet_entries).size).to eq 1
      end
    end
  end

  describe "GET /new" do
    it do
      get :new
      expect(response).to have_http_status(:success)
      expect(assigns(:time_sheet_entry).persisted?).to eq false
    end
  end

  describe "POST /" do
    context "Params are valid" do
      it do
        create(:billing_rate_weekday, day: "tuesday")
        params = { time_sheet_entry: { date_of_entry: "2019-04-16", start_time: "5:00 AM", finish_time: "10:00 AM" } }

        post :create, params: params
        expect(response).to have_http_status(302)
        expect(TimeSheetEntry.where(date_of_entry: "2019-04-16").count).to eq 1
      end
    end

    context "Params are not valid" do
      it do
        create(:billing_rate_weekday, day: "tuesday")
        params = { time_sheet_entry: { date_of_entry: "2019-04-16", start_time: "5:00 AM", finish_time: "" } }

        post :create, params: params
        expect(response).to have_http_status(400)
        expect(assigns(:time_sheet_entry).errors.full_messages.include?("Finish time can't be blank")).to be_truthy
        expect(TimeSheetEntry.where(date_of_entry: "2019-04-16").count).to eq 0
      end
    end
  end
end
