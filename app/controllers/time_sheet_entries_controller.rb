class TimeSheetEntriesController < ApplicationController
  before_action :clear_flash, only: [:new]

  def index
    @time_sheet_entries = TimeSheetEntry.all.order(created_at: :desc)
  end

  def new
    @time_sheet_entry = TimeSheetEntry.new
  end

  def create
    @time_sheet_entry = TimeSheetEntry.new(time_sheet_entry_params)

    if @time_sheet_entry.save
      flash[:success] = "Timesheet Entry is created successfully"
      redirect_to time_sheet_entries_path
    else
      flash[:error] = @time_sheet_entry.errors.full_messages
      render :new, status: 400
    end
  end

  private

  def time_sheet_entry_params
    params.require(:time_sheet_entry).permit(:date_of_entry, :start_time, :finish_time)
  end

  def clear_flash
    flash.clear
  end
end
