# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "my_time_tracker"
set :repo_url, "https://github.com/taisytran/my-time-tracker.git"

append :linked_files, "config/database.yml", "config/puma.rb", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", ".bundle", "public/system", "public/uploads"

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :nvm_type, :user
set :nvm_node, "v14.17.3"
set :nvm_map_bins, %w{node npm yarn}

set :keep_releases, 1

set :pty, true

set :puma_nginx_config

set :puma_rackup, -> {File.join(current_path, "config.ru")}
set :puma_state, -> {"#{shared_path}/tmp/pids/puma.state"}
set :puma_pid, -> {"#{shared_path}/tmp/pids/puma.pid"}
set :puma_bind, -> {"unix://#{shared_path}/tmp/sockets/puma.sock"}
set :puma_conf, -> {"#{shared_path}/config/puma.rb"}
set :puma_access_log, -> {"#{release_path}/log/puma_access.log"}
set :puma_error_log, -> {"#{release_path}/log/puma_error.log"}
set :puma_role, :app
# set :puma_env, fetch(:rack_env, fetch(:rails_env, "staging"))
set :puma_threads, [4, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  after  :finishing,    :cleanup
end
