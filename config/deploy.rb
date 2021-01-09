require 'time_difference'
# config valid for current version and patch releases of Capistrano
lock "~> 3.13.0"

set :application, "pideloencasa"
set :repo_url, "git@github.com:Smart-Drako/pideloencasa.git"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 5

append :linked_files,  "config/application.yml"

namespace :deploy do
  task :slack_start do
    slack_variables()
    sh "curl -X POST -H 'Content-type: application/json' --data '{\"attachments\": [{\"color\": \"warning\",\"fields\": [{\"title\": \"Project\",\"value\": \"Pidelo en Casa\",\"short\": true}, {\"title\": \"Environment\",\"value\": \"#{@enviroment}\",\"short\": true}, {\"title\": \"Branch\",\"value\": \"#{@branch}\",\"short\": true}, {\"title\": \"Deployer\",\"value\": \"#{@name}\",\"short\": true}],\"fallback\": \"fallback\"}],\"text\": \"Deploy on Process #{Time.now.strftime("%F %I:%M%p")}\"}' https://hooks.slack.com/services/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"
  end

  task :slack_end do
    elapsed_time = TimeDifference.between(@start_time, Time.now).humanize if @start_time
    sh "curl -X POST -H 'Content-type: application/json' --data '{\"attachments\": [{\"color\": \"good\",\"fields\": [{\"title\": \"Project\",\"value\": \"Pidelo en Casa\",\"short\": true}, {\"title\": \"Environment\",\"value\": \"#{@enviroment}\",\"short\": true}, {\"title\": \"Branch\",\"value\": \"#{@branch}\",\"short\": true}, {\"title\": \"Deployer\",\"value\": \"#{@name}\",\"short\": true}, {\"title\": \"Time\",\"value\": \"#{elapsed_time}\",\"short\": true}],\"fallback\": \"fallback\"}],\"text\": \"Application Deployed #{Time.now.strftime("%F %I:%M%p")}\"}' https://hooks.slack.com/services/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"
  end

  task :failed do
    elapsed_time = TimeDifference.between(@start_time, Time.now).humanize if @start_time
    sh "curl -X POST -H 'Content-type: application/json' --data '{\"attachments\": [{\"color\": \"danger\",\"fields\": [{\"title\": \"Project\",\"value\": \"Pidelo en Casa\",\"short\": true}, {\"title\": \"Environment\",\"value\": \"#{@enviroment}\",\"short\": true}, {\"title\": \"Branch\",\"value\": \"#{@branch}\",\"short\": true}, {\"title\": \"Deployer\",\"value\": \"#{@name}\",\"short\": true}, {\"title\": \"Time\",\"value\": \"#{elapsed_time}\",\"short\": true}],\"fallback\": \"fallback\"}],\"text\": \"Deploy Failed #{Time.now.strftime("%F %I:%M%p")}\"}' https://hooks.slack.com/services/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"
  end 
end

before :deploy, "deploy:slack_start"
after :deploy, "deploy:slack_end"

def slack_variables
  @enviroment = fetch(:stage) == :production ? "PRODUCTION" : fetch(:stage) == :staging ? "STAGING" : "STAGING" 
  @start_time = Time.now
  @name = `git config user.name`.strip
  @name = nil if @name.empty?
  @branch = "#{fetch(:branch)}"
end


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
