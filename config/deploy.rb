require 'capistrano/ext/multistage'

set :application, 'my5'
set :scm, :git

set :repository, 'git@github.com:smoothcorp/my5.git'
set :branch, 'master'

set :ssh_options, {:forward_agent => true}
set :default_run_options, {:pty => true}
set :stages, %w(staging production)
set :default_stage, 'staging'
set :use_sudo, false

# set :stages, ["vagrant"]
# set :default_stage, "vagrant"

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
end
