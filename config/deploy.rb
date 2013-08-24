require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano-unicorn'

set :application, "donationparty"

#set :repository,  "git@github.com:orangejulius/donationparty.git"
set :repository, "https://github.com/orangejulius/donationparty.git"

role :web, "donationparty.com"                          # Your HTTP server, Apache/etc
role :app, "donationparty.com"                          # This may be the same as your `Web` server
role :db,  "donationparty.com", :primary => true # This is where Rails migrations will run

set(:user) { 'rails' }
set(:deploy_to) { "/home/#{user}"}
set :use_sudo, false

after 'deploy:restart', 'unicorn:restart'
after  'deploy:finalize_update', 'config:symlink'

namespace :config do
  desc "Symlink the configuration files for the app"
  task :symlink do
    run <<-CMD
      for i in `ls -A #{shared_path}/config`; do
        if test -f "#{shared_path}/config/$i"; then
          ln -nfs "#{shared_path}/config/$i" "#{release_path}/config/$i";
        fi;
      done;
    CMD
  end
end
