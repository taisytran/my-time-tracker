Rails.application.routes.draw do
  # root 'welcome#index'
  root 'time_sheet_entries#new'

  resources :time_sheet_entries, only: [:index, :new, :create]
end
