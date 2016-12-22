# Execute "bundle install" after deploy, but only when really needed
# require "bundler/capistrano"
# require 'capistrano/sidekiq'
# require 'whenever/capistrano'
# Dir.glob("deploy/config/deploy/*.rb").each { |r| import  r }
# RVM integration
set :rvm_ruby_version, '2.1.2'
set :rvm_type, :user
set :rvm_roles, [:app, :web, :db,:all]
# We use sudo (root) for system-wide RVM installation
#set :rvm_install_with_sudo, true
set :rvm_install_ruby_params, "--autolibs=packages"

#==================== deploy 配置项======================
# #App Domain
set :deploy_user, 'ubuntu'
# set :ssh_key, "id_rsa"
set :use_sudo, false
set :ssh_options, {keys: [File.join(ENV["HOME"], ".ssh", "id_rsa")], forward_agent: true}
# set :pty,true

set :application, "weimall"
# Application environment
set :rails_env, :production

#whenever
set :whenever_command, "cd  #{fetch(:deploy_to)} && bundle exec whenever"

# #
# set :default_environment,
#     self[:default_environment].merge('GIT_SSL_NO_VERIFY' => '1',
#                                      'NODE_ENV' => "production",
#                                      'PATH' => "$PATH:/home/ubuntu/.nvm/v0.10.31/bin")

set :repo_url, "git@git.oschina.net:myjacksun/weimall.git"
set :scm, "git"
set :scm_verbose, true
# Deploy via github
# set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{fetch(:application)}"
set :keep_releases, 2
# after "deploy:update", "deploy:cleanup"
# We have all components of the app on the same server
# SSHKit.config.command_map[:rake] = "bundle exec rake" #8
# SSHKit.config.command_map[:rails] = "bundle exec rails"

# files we want symlinking to specific entries in shared
set :linked_files, %w{config/database.yml config/host.yml config/oauth.yml config/secrets.yml config/sms.yml config/mailer.yml config/delivery.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system app/rgloader}
set :bundle_binstubs, nil
# Unicorn config
namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:all), in: :sequence, wait: 5 do
        execute "sudo /etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:all), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  task :fix_permissions do
    on roles :all do
      execute "sudo mkdir -p /var/www"
      execute "sudo chown -R #{fetch(:deploy_user)}:#{fetch(:deploy_user)} /var/www"
      execute "sudo mkdir -p /var/www/#{fetch(:application)}"
      execute "sudo chown -R #{fetch(:deploy_user)}:#{fetch(:deploy_user)} /var/www/#{fetch(:application)}"
      execute "sudo chmod -R  755 /var/www/#{fetch(:application)}"
    end
  end

  before "deploy:check", "deploy:fix_permissions"

  task :setup_config do
    on roles :all do
# add project configuration
      execute "mkdir -p #{fetch(:deploy_to)}/shared #{fetch(:deploy_to)}/shared/config #{fetch(:deploy_to)}/shared/pids #{fetch(:deploy_to)}/shared/log || echo exist"
      %w{database.yml host.yml oauth.yml mailer.yml secrets.yml sms.yml delivery.yml}.each do |file|
        sudo_upload "deploy/config/#{fetch(:stage)}/#{file}", "#{fetch(:deploy_to)}/shared/config/#{file}"
      end
      execute "sudo mkdir -p /etc/redis"
      sudo_upload 'deploy/redis/redis.conf', "/etc/redis/redis.conf"
# sudo_upload File.read('deploy/nodejs/config.json'), "#{fetch(:deploy_to)}/shared/config/nodejs_config.json"
#nodejs
# sudo_upload File.read("deploy/nodejs-server.sh"), "/etc/init.d/nodejs-server"
# sudo "chmod +x /etc/init.d/nodejs-server"
# sudo "update-rc.d nodejs-server defaults"
# sudo "touch /var/log/weimall-nodejs.log"
# sudo "touch /var/execute/weimall-nodejs.pid"
# sudo "chown ubuntu:ubuntu /var/log/weimall-nodejs.log"
# sudo "chown ubuntu:ubuntu /var/execute/weimall-nodejs.pid"
#sudo "mkdir -p /var/www/tanluke/shared/uploads"
#sudo "ln -s  /var/www/tanluke/shared/uploads  /var/www/#{application}/current/public/uploads"
#nginx
      execute "sudo rm -rf /etc/nginx/sites-enabled/default"
      sudo_upload "deploy/config/#{fetch(:stage)}/nginx_app.conf", "/etc/nginx/sites-enabled/#{fetch(:application)}.conf"
#unicorn
      sudo_upload "deploy/config/#{fetch(:stage)}/unicorn_init.sh", "/etc/init.d/unicorn_#{fetch(:application)}"
      sudo "chmod +x /etc/init.d/unicorn_#{fetch(:application)}"
#coreseek sphinx
# execute "sudo ln -sf /usr/local/coreseek/bin/searchd /usr/bin/searchd "
# execute "sudo ln -sf /usr/local/coreseek/bin/search /usr/bin/search "
# execute "sudo ln -sf /usr/local/coreseek/bin/indextool /usr/bin/indextool"
# execute "sudo ln -sf /usr/local/coreseek/bin/indexer /usr/bin/indexer "
# execute "sudo ln -sf /usr/local/coreseek/bin/spelldump /usr/bin/spelldump "
    end
  end
  before :check, :"deploy:setup_config"

  desc "create database on server"
  task :create_db do
    on roles :all do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:create'
        end
      end
      # execute "mysql -u weimall -pweimall123 -e \"CREATE DATABASE IF NOT EXISTS weimall default charset utf8 COLLATE utf8_general_ci; \""
    end
  end

  task :db_seed do
    on roles :all do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  # namespace :assets do
  task :symlink do
    execute ("rm -rf #{latest_release}/public/assets &&
            mkdir -p #{latest_release}/public &&
            mkdir -p #{shared_path}/assets &&
            ln -s #{shared_path}/assets #{latest_release}/public/assets &&
            mkdir -p #{shared_path}/uploads &&
            ln -sf #{shared_path}/uploads #{latest_release}/public/uploads
          ")
  end
  # before 'deploy:finalize_update', 'deploy:assets:symlink'

  #desc 'copy ckeditor nondigest assets'
  #task :copy_nondigest_assets do
  #  execute "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} ckeditor:copy_nondigest_assets"
  #end
  #after 'deploy:assets:precompile', 'deploy:assets:copy_nondigest_assets'

  desc "qiniu assets"
  task :qiniu_upload do
    #execute "cd #{latest_release} &&  #{rake}  RAILS_ENV=#{rails_env} assets_qiniu:upload"
    system("#{rake}  RAILS_ENV=#{rails_env} assets_qiniu:upload")
  end

  task :precompile do
    # from = source.next_revision(current_revision) #初始部署注释掉
    # if capture("cd #{shared_path}/cached-copy && git diff #{from}.. --stat | grep 'app/assets' | wc -l").to_i > 0
    run_locally("RAILS_ENV=#{rails_env}  rake assets:clobber && RAILS_ENV=#{rails_env}  rake assets:precompile")
    run_locally "cd public && tar -jcf assets.tar.bz2 assets"
    top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
    execute "cd #{shared_path} &&  rm -rf assets/*"
    execute "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
    run_locally "rm public/assets.tar.bz2"
    #execute "cd #{latest_release} && RAILS_ENV=#{rails_env}  rake assets:clean"
    # deploy.assets.qiniu_upload
    #run_locally("RAILS_ENV=#{rails_env}  rake assets:clobber")
    # else
    #   logger.info "Skipping asset precompilation because there were no asset changes"
    # end
  end

  task :precompile do
    # from = source.next_revision(current_revision) #初始部署注释掉
    # if capture("cd #{shared_path}/cached-copy && git diff #{from}.. --stat | grep 'app/assets' | wc -l").to_i > 0
    execute %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} assets:precompile}
    # else
    #   logger.info "Skipping asset precompilation because there were no asset changes"
    # end
  end
  # after 'deploy:update_code', 'deploy:assets:precompile'
  #after 'deploy:assets:precompile', 'deploy:assets:qiniu_upload'
  # end


  #=============== 配置机器环境 =======================

  task :symlink_config do
    execute "mkdir -p #{release_path}/tmp/sockets"
    execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # execute "ln -nfs #{shared_path}/config/nodejs_config.json #{release_path}/node/config.json"
  end

  after :symlink, "deploy:symlink_config"

  #desc "Make sure local git is in sync with remote."
  #task :check_revision, roles: :web do
  #  unless `git rev-parse HEAD` == `git rev-parse origin/master`
  #    puts "WARNING: HEAD is not the same as origin/master"
  #    puts "execute `git push` to sync changes."
  #    exit
  #  end
  #end
  #before "deploy", "deploy:check_revision"


  task :update_apt_get do
    #execute "#{sudo} rm /var/lib/apt/lists/* -vf"
    #execute "#{sudo} apt-get update && #{sudo} apt-get upgrade"
    execute "#{sudo}  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A42227CB8D0DC64F"
  end

  task :set_rvm_version do
    execute "source ~/.rvm/src/rvm/scripts/rvm && rvm use #{rvm_ruby_string} --default"
  end


  desc "Update crontab with whenever"
  task :update_cron do
    on roles(:all) do
      within current_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
      end
    end
  end

  after :finishing, 'deploy:update_cron'
end

namespace :env do
  task :setup do
    ruby.install
    nginx.install
    #mongodb.install
    nodejs.install
    imagemagick.install
  end
  #TODO sudo不应在rvmsudo中
  task :dependency do
    execute "sudo apt-get install curl git", :shell => "bash" do |ch, stream, data|
      ch.send_data("y\n")
    end
    execute "sudo apt-get update && sudo apt-get install python-software-properties", :shell => "bash" do |ch, stream, data|
      ch.send_data("y\n")
    end
  end
  # before 'env:setup', 'env:dependency'

end

namespace :ruby do
  task :install do
    rvm.install_rvm
    rvm.install_ruby
    deploy.set_rvm_version
  end
end


namespace :nginx do
  %w[start stop restart].each do |cmd|
    desc "#{cmd}s nginx"
    task cmd do
      on roles(:all) do
        execute "sudo /etc/init.d/nginx #{cmd}"
      end
    end
  end

  desc "nginx install"
  task :install do
    sudo "mkdir -p /tmp/nginx"
    sudo_upload File.read("deploy/nginx/nginx_install.sh"), "/tmp/nginx/nginx_install.sh"
    sudo_upload File.read("deploy/nginx/nginx_init.sh"), "/tmp/nginx/nginx_init.sh"
    sudo_upload File.read("deploy/nginx/nginx.conf"), "/tmp/nginx/nginx.conf"
    sudo_upload File.read("deploy/nginx/default"), "/tmp/nginx/default"
    execute "cd /tmp/nginx && #{sudo} bash nginx_install.sh"
    execute "sudo /etc/init.d/nginx restart"
  end
end

namespace :sphinx do
  task :install do
    sudo "mkdir -p /tmp/sphinx"
    sudo_upload File.read('deploy/sphinx/sphinx_install.sh'), "/tmp/sphinx/sphinx_install.sh"
    sudo_upload File.read('deploy/sphinx/sphinx_init.sh'), "/tmp/sphinx/sphinx_init.sh"
    execute " cd /tmp/sphinx && #{sudo} bash sphinx_install.sh "
  end

  %w[start stop restart].each do |cmd|
    desc "#{cmd}s sphinx server"
    task cmd do
      execute "#{sudo} nohup /etc/init.d/searchd #{cmd}"
    end
  end
end

namespace :coreseek do
  task :install do
    sudo "mkdir -p /tmp/sphinx"
    sudo_upload File.read('deploy/sphinx/coreseek.sh'), "/tmp/sphinx/coreseek_install.sh"
    execute " cd /tmp/sphinx && #{sudo} bash coreseek_install.sh "
  end
end

namespace :mongodb do
  desc "mongodb install"
  task :install do
    sudo "mkdir -p /tmp/mongodb"
    sudo_upload File.read('deploy/mongodb/mongodb_install.sh'), "/tmp/mongodb/mongodb_install.sh"
    execute "cd /tmp/mongodb && #{sudo} bash mongodb_install.sh "
  end
end

set :mysql_root_password, "123456"
namespace :mysql do
  %w[start stop restart].each do |cmd|
    desc "#{cmd}s mysql"
    task cmd do
      execute "sudo nohup /etc/init.d/mysql #{cmd}"
    end
  end

  desc "mysql install"
  task :install do
    on roles(:all) do
      sudo "mkdir -p /tmp/mysql"
      sudo_upload "deploy/mysql/mysql_install.sh", "/tmp/mysql/mysql_install.sh"
      sudo_upload "deploy/mysql/my.cnf", "/tmp/mysql/my.cnf"
      execute "cd /tmp/mysql && sudo bash mysql_install.sh"
    end
  end

  task :config do
    on roles(:all) do
      sudo_upload "deploy/mysql/mysql_init.sh", "/etc/init.d/mysql"
      execute "sudo chmod +x /etc/init.d/mysql"
      execute "sudo update-rc.d mysql defaults"
      sudo_upload "deploy/mysql/my.cnf", "/etc/mysql/my.cnf"
    end
  end

  # task :install do
  #   on roles(:all) do
  #     #capistrano task for installing mysql
  #     execute "sudo dpkg --configure -a"
  #     execute "sudo apt-get -y install mysql-server libmysqlclient-dev", interaction_handler: lambda do |data, channel|
  #       xxxx
  #       puts "###-------#{data}"
  #       # prompts for mysql root password (when blue screen appears)
  #       channel.send_data("#{fetch(:mysql_root_password)}\n\r") if data =~ /password/
  #     end
  #   end
  # end
  # task :install do
  #   on roles(:all) do
  #     #capistrano task for installing mysql
  #     execute "sudo dpkg --configure -a"
  #         execute "sudo apt-get -y install mysql-server", interaction_handler: {/New password for the MySQL /=>"#{fetch(:mysql_root_password)}\n\r"}
  #   end
  # end
end

namespace :nodejs do
  desc "Install nodejs"
  task :install do
    #execute "sudo apt-get install software-properties-common  python-software-properties" do |ch, stream, data|
    #  ch.send_data("yes\n")
    #end
    #execute "sudo add-apt-repository ppa:chris-lea/node.js", :pty => false
    #execute "sudo apt-get update"
    execute "sudo  apt-get install nodejs npm" do |ch, stream, data|
      ch.send_data("yes\n")
    end
  end

  %w[start stop restart].each do |cmd|
    desc "#{cmd}s nodejs-server"
    task cmd do
      execute "sudo /etc/init.d/nodejs-server #{cmd}"
    end
  end
end

namespace :redis do
  %w[start stop restart].each do |cmd|
    desc "#{cmd}s redis-server"
    task cmd do
      execute "#{sudo} nohup /etc/init.d/redis-server #{cmd}"
    end
  end
  desc "redis install"
  task :install do
    execute "sudo apt-get install build-essential -y"
    execute "cd /usr/local/src &&
     sudo wget http://download.redis.io/releases/redis-2.8.13.tar.gz&&
     sudo tar xvzf redis-2.8.13.tar.gz    &&
     cd  redis-2.8.13  &&
     sudo make        &&
     sudo make install    &&
     sudo  mkdir -p /usr/local/bin   &&
     cd src                  &&
     sudo  cp -p redis-benchmark /usr/local/bin   &&
     sudo cp -p redis-cli /usr/local/bin           &&
     sudo cp -p redis-check-dump /usr/local/bin      &&
     sudo cp -p redis-check-aof /usr/local/bin"

    execute "sudo mkdir -p /var/lib/redis /etc/redis /var/log/redis"
    sudo_upload File.read('deploy/redis/redis.conf'), "/etc/redis/redis.conf"
    sudo_upload File.read('deploy/redis/redis-server'), "/etc/init.d/redis-server"
    execute "sudo chmod +x /etc/init.d/redis-server"
    execute "sudo update-rc.d redis-server defaults"
    execute "sudo useradd redis"
    execute "sudo chown redis.redis /var/lib/redis /var/log/redis "
    execute "sudo  nohup /etc/init.d/redis-server restart"
  end
end

namespace :imagemagick do
  desc "Install the latest release of ImageMagick and the MagickWand Dev Library"
  task :install do
    execute "#{sudo} apt-get -y update"
    execute "#{sudo} apt-get -y install imagemagick libmagickwand-dev"
  end
  # after "deploy:install", "imagemagick:install"
end


desc "install dependency lib"
task :install_dependency do
  #nokogri依赖
  execute "sudo apt-get install -y build-essential libxslt-dev libxml2-dev"
end
# after "deploy:install", "install_dependency"

#sidekiq
set :sidekiq_cmd, "bundle exec sidekiq -C config/sidekiq.yml"
set :sidekiqctl_cmd, "bundle exec  sidekiqctl"
set :sidekiq_role, :app

#whenever
set :whenever_command, "bundle exec whenever"

namespace :god do
  %w[start stop restart].each do |cmd|
    desc "#{cmd}s god server"
    task cmd do
      execute "#{sudo}  /etc/init.d/god #{cmd}"
    end
  end

  task :install do
    execute "gem install god --no-ri --no-rdoc && god --version"
    sudo "mkdir -p /etc/god"
    execute "rvm wrapper #{rvm_ruby_string} bootup god"
    sudo_upload File.read('deploy/god/god_init.sh'), "/etc/init.d/god"
    sudo "chmod +x /etc/init.d/god"
    sudo "sudo update-rc.d god defaults"

  end

  task :config do
    # sudo_upload File.read('deploy/god/mysql.god'), "/etc/god/mysql.god"
    # sudo_upload File.read('deploy/god/redis.god'), "/etc/god/redis.god"
    # sudo_upload File.read('deploy/god/nginx.god'), "/etc/god/nginx.god"
    # sudo_upload File.read('deploy/god/unicorn.god'), "/etc/god/unicorn.god"
    # sudo_upload File.read('deploy/god/sidekiq.god'), "/etc/god/sidekiq.god"
    sudo_upload File.read('deploy/god/application.god'), "/etc/god/application.god"
  end

  task :status do
    execute "rvmsudo god status"
  end

  task :log do
    execute "tail -f /var/log/god.log"
  end
end

namespace :encoder do
  desc "task encoder"
  task :install_linux do
    on roles(:all) do
      puts "==================#{fetch(:branch)}"
      if fetch(:branch)=="encoder"
        execute "mkdir -p #{deploy_to}/shared/app/rgloader"
        execute "rm -rf #{deploy_to}/shared/app/rgloader/*"
        Dir.glob("deploy/encoder/rgloader_linux/**/*").each do |file|
          file_name=File.basename(file)
          puts "####{file}"
          sudo_upload file, "#{deploy_to}/shared/app/rgloader/#{file_name}"
        end
      end
    end
  end
end
before "deploy:check", "encoder:install_linux"

#task :copy_rsa do
#$ sudo su -
# chmod a+w /etc/sudoers
# vi /etc/sudoers
# chmod a-w /etc/sudoers
#echo 'ubuntu  ALL=(ALL:ALL) ALL' >> /etc/sudoers
#ubuntu ALL = NOPASSWD: ALL
#﻿cat ~/.ssh/id_rsa.pub | ssh USER@HOST "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
#﻿chmod 700 ~/.ssh
#chmod 600 ~/.ssh/authorized_keys
#end

#sudo apt-get autoremove --purge mysql-server-5.0
#sudo apt-get remove mysql-server
#sudo apt-get autoremove mysql-server
#sudo apt-get remove mysql-common

# A hacky way to sudo_upload files in Capistrano with sudoer permissions
def sudo_upload(file_path, to)
  filename = File.basename(to)
  to_directory = File.dirname(to)
  execute "mkdir -p /tmp/cap_upload"
  upload! file_path, "/tmp/cap_upload/#{filename}"
  execute "sudo mv /tmp/cap_upload/#{filename} -f #{to_directory}"
end

