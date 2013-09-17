require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :application, 'my5'
set :scm, :git
set :user, 'root'
server '108.171.188.200', :app, :web, :db, :primary => true

set :repository, 'git@github.com:smoothcorp/my5.git'

set :ssh_options, {:forward_agent => true}
set :default_run_options, {:pty => true}
set :stages, %w(staging production)
set :default_stage, 'staging'
set :use_sudo, false
after 'deploy:restart', 'deploy:db_symlink'
after 'deploy:db_symlink', 'deploy:fix_permissions'

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :db,  "your slave db-server here"
# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  task :db_symlink, :roles => :app do
    run "ln -f #{deploy_to}/shared/database.yml #{File.join(current_path, 'config', 'database.yml')}"
  end

  task :fix_permissions, :roles => :app do
    %w(tmp log public).each { |dirc| run "chmod -R a+w #{File.join(current_path, dirc)}" }
    run "chmod -R a+r #{deploy_to}"
  end

  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

end
