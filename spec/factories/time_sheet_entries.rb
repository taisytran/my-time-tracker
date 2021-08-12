FactoryBot.define do
  factory :time_sheet_entry do
    date_of_entry { "2019-04-16" }
    start_time { "12:00pm" }
    finish_time { "20:15pm" }
  end
end
