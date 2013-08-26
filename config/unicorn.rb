worker_processes 2
timeout 15
preload_app true

# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

app_path = "/home/donationparty/current"

working_directory app_path

pid "#{app_path}/tmp/pids/unicorn.pid"
