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
class TimeSheetEntry < ApplicationRecord
  validates :date_of_entry, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true

  validate :validate_overlapping
  validate :validate_finish_time_gt_start_time
  validate :validate_entry_date_in_future

  # TODO: store billing_rate_by_day_id

  private

  def overlaps?(time_sheet_entry)
    start_time <= time_sheet_entry.finish_time && time_sheet_entry.start_time <= finish_time
  end

  def validate_finish_time_gt_start_time
    return if finish_time.blank? || start_time.blank?
    return if finish_time > start_time

    errors.add(:base, "Finish time can not greater than start time")
  end

  def validate_overlapping
    is_overlaped = self.class.where(date_of_entry: date_of_entry).any? do |existed_entry|
      overlaps?(existed_entry)
    end

    errors.add(:base, "Time sheet have overlapped") if is_overlaped
  end

  def validate_entry_date_in_future
    return if date_of_entry.blank?
    return if date_of_entry < Time.current.to_date

    errors.add(:base, "Date of entry can not be in future")
  end
end
