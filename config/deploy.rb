load 'deploy/assets'
require 'rvm/capistrano'
require "rvm/capistrano/alias_and_wrapp"
require 'bundler/capistrano'

set :rvm_ruby_string, :local
set :rvm_autolibs_flag, "packages"

set :application, "tmuxme"
set :repository,  "git@github.com:realpractice/tmuxme.git"
set :user, "deploy"
set :ssh_options, { :forward_agent => true}


set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "tmux.me", :app, :web, :db, :primary => true

before 'deploy', 'rvm:create_alias'
before 'deploy', 'rvm:create_wrappers'
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'

before "deploy:assets:precompile", "deploy:chown_for_tunnel_runner"
before "deploy:assets:precompile", "deploy:symlink_configs"

namespace :deploy do
  desc "Chown directories for tunnel runner"
  task :chown_for_tunnel_runner do
    run "#{sudo} chown -R tunnel #{release_path}/tmp/"
    run "#{sudo} chown -R tunnel #{shared_path}/log"
  end

  desc "Symlink configs"
  task :symlink_configs do
    run "ln -fs /u/apps/tmuxme/puppet/config/database.yml #{release_path}/config/database.yml"
    run "ln -fs /u/apps/tmuxme/puppet/config/email.yml #{release_path}/config/email.yml"
    run "ln -fs /u/apps/tmuxme/puppet/config/authorized_keys.yml #{release_path}/config/authorized_keys.yml"
    run "ln -fs /u/apps/tmuxme/puppet/config/secret_token.yml #{release_path}/config/secret_token.yml"
  end

  desc "Restart unicorn"
  task :restart, :roles => :web do
    run "#{sudo} service unicorn restart"
  end
  
  desc "Start unicorn"
  task :start, :roles => :web do
    run "#{sudo} service unicorn start"
  end

  desc "Stop unicorn"
  task :stop, :roles => :web do
    run "#{sudo} service unicorn stop"
  end

  desc "Reload unicorn"
  task :reload, :roles => :web do
    run "#{sudo} service unicorn reload"
  end

  desc "Rotate unicorn"
  task :rotate, :roles => :web do
    run "#{sudo} service unicorn rotate"
  end

  desc "Upgrade unicorn"
  task :upgrade, :roles => :web do
    run "#{sudo} service unicorn upgrade"
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
