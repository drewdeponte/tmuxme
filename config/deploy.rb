set :application, 'tmuxme'
set :repo_url, 'git@github.com:reachlocal/tmuxme.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :rbenv_type, :user
set :rbenv_ruby, '2.0.0-p353'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :deploy_to, '/u/apps/tmuxme'
set :scm, :git

set :format, :pretty
# set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml config/email.yml config/authorized_keys.yml config/secret_token.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :ssh_options, { :forward_agent => true}

namespace :deploy do
  task :drewtest do
    on roles(:web) do
      execute "whoami"
    end
  end

  desc "Chown directories for tunnel runner"
  task :chown_for_tunnel_runner do
    execute :sudo, "chown -R tunnel #{release_path}/tmp/"
    execute :sudo, "chown -R tunnel #{shared_path}/log"
  end

  desc "Symlink configs"
  task :symlink_configs do
    run "ln -fs /u/apps/tmuxme/puppet/config/database.yml #{release_path}/config/database.yml"
    run "ln -fs /u/apps/tmuxme/puppet/config/email.yml #{release_path}/config/email.yml"
    run "ln -fs /u/apps/tmuxme/puppet/config/authorized_keys.yml #{release_path}/config/authorized_keys.yml"
    run "ln -fs /u/apps/tmuxme/puppet/config/secret_token.yml #{release_path}/config/secret_token.yml"
  end

  desc "Start unicorn"
  task :start do
    on roles(:web) do
      execute :sudo, "service unicorn start"
    end
  end

  desc "Stop unicorn"
  task :stop do
    on roles(:web) do
      execute :sudo, "service unicorn stop"
    end
  end

  desc "Reload unicorn"
  task :reload do
    on roles(:web) do
      execute :sudo, "service unicorn reload"
    end
  end

  desc "Rotate unicorn"
  task :rotate do
    on roles(:web) do
      execute :sudo, "service unicorn rotate"
    end
  end

  desc "Upgrade unicorn"
  task :upgrade do
    on roles(:web) do
      execute :sudo, "service unicorn upgrade"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, "service unicorn restart"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
