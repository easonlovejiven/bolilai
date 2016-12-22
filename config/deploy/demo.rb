set :stage, :demo

server "weiyatech.com", user: "ubuntu", roles: %w{web app db}
# server "server2.example.com", user: "deploy_user", roles: %w{web app}

set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "v1"
set :database_path, "deploy/"
