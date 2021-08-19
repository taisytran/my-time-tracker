RSpec.configure do |config|
  config.before(:each, :overtime_enabled) do
    ENV["OVERTIME_EXPERIMENT_ENABLED"] = "true"
  end

  config.after(:each, :overtime_enabled) do
    ENV["OVERTIME_EXPERIMENT_ENABLED"] = "false"
  end
end
