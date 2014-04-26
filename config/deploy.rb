require 'bundler/capistrano'
require 'capistrano-unicorn'

set :application, "donationparty"

#set :repository,  "git@github.com:orangejulius/donationparty.git"
set :repository, "https://github.com/orangejulius/donationparty.git"
set :domain, "donationparty.com"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set(:user) { 'donationparty' }
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
