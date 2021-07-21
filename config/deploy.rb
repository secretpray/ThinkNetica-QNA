# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

# set :application, "qna-2021"
set :application, "qna"
set :repo_url, "git@github.com:secretpray/ThinkNetica-QNA.git"

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/home/deployer/qna-2021"
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
 append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'

# SSHKit.config.command_map[:sidekiq] = "bundle exec sidekiq"
# SSHKit.config.command_map[:sidekiqctl] = "bundle exec sidekiqctl"

set :pty,  false
# set :init_system, :systemd
# set :service_unit_name, "sidekiq.service"
