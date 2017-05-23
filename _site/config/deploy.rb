server "72.14.187.117", :web, primary: true

# replace this with your site's name
set :application, "robyns-floral"
set :repository, '_site'
set :scm, :none
set :deploy_via, :copy
set :copy_compression, :gzip
set :use_sudo, false
set :port, 22000

# the name of the user that should be used for deployments on your VPS
set :user, "nwatson"

# the path to deploy to on your VPS
set :deploy_to, "/home/#{user}/apps/#{application}"

# Enable SSH Forwarding
set :ssh_options, { :forward_agent => true }

default_run_options[:pty] = true

before 'deploy:update', 'deploy:update_jekyll'

namespace :deploy do
  [:start, :stop, :restart, :finalize_update].each do |t|
    desc "#{t} task is a no-op with jekyll"
    task t, :roles => :app do ; end
  end

  desc 'Run jekyll to update site before uploading'
  task :update_jekyll do
    # clear existing _site
    # build site using jekyll
    # remove Capistrano stuff from build
    %x(rm -rf _site/* && jekyll build && rm _site/Capfile && rm -rf _site/config && rm _site/Gemfile && rm _site/Gemfile.lock)
  end
end