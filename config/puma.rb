#!/usr/bin/env puma
 
app_root = "/home/deployer/applications/quote_manager/"

threads 0, 4
workers 2
environment "production"
 
bind  "unix:///var/tmp/project.sock"
pidfile "#{app_root}/run/puma/project.pid"
stdout_redirect "#{app_root}/log/puma/project.log"
