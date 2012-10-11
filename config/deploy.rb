
require 'bundler/capistrano'
require 'rvm/capistrano'

require 'yaml'
require 'aws-sdk'

set :rvm_ruby_string, '1.9.3'

ssh_options[:keys] = ['etc/pod.pem']

set :application, 'ruby-scratch'
set :repository,  'https://github.com/cclamb/overlay.git'

set :branch, 'umm'

creds_file_name = 'etc/creds.yaml'

creds = YAML::load File::open(creds_file_name)

msg =<<EOF
Submitted credentials are:
  rackspace password: #{creds['rackspace']['password']}
  amazon access key: #{creds['amazon']['access_key']}
  amazon secret key: #{creds['amazon']['secret_key']}
EOF

puts msg

set :user, 'overlay'
set :password, creds['rackspace']['password']

set :scm, :git
set :use_sudo, false
set :deploy_to, '~'

role :nodes, '198.101.205.153', \
  '198.101.205.155', \
  '198.101.205.156', \
  '198.101.203.202', \
  '198.101.209.178', \
  '198.101.209.247', \
  '198.101.202.188', \
  '198.101.207.34', \
  '198.101.207.48', \
  '198.101.207.236', \
  'ec2-67-202-45-247.compute-1.amazonaws.com', \
  'ec2-23-20-43-173.compute-1.amazonaws.com', \
  'ec2-50-17-85-234.compute-1.amazonaws.com', \
  'ec2-23-22-68-94.compute-1.amazonaws.com', \
  'ec2-50-17-57-243.compute-1.amazonaws.com', \
  'ec2-50-16-141-176.compute-1.amazonaws.com', \
  'ec2-184-73-138-154.compute-1.amazonaws.com', \
  'ec2-107-20-47-98.compute-1.amazonaws.com', \
  'ec2-184-73-2-121.compute-1.amazonaws.com', \
  'ec2-23-22-144-216.compute-1.amazonaws.com'

#role :node, '198.101.205.156'
#role :node, 'ec2-23-22-144-216.compute-1.amazonaws.com'
role :node, 'ec2-67-202-45-247.compute-1.amazonaws.com'
role :router, '198.101.205.153'


# Prime simulation configuration
# config_file_name = 'etc/config.yaml'
# config_file_name = 'etc/simple_hierarchy_config.yaml'
# config_file_name = 'etc/all_hierarchy_config.yaml'
# config_file_name = 'etc/1_2_hierarchy_config.yaml'
config_file_name = 'etc/1_2_2_hierarchy_config.yaml'

access_key = creds['amazon']['access_key']
secret_key = creds['amazon']['secret_key']

AWS.config \
  :access_key_id => access_key, \
  :secret_access_key => secret_key

# Push configuration information to S3
s3 = AWS::S3.new
config_bucket = s3.buckets[:chrislambistan_configuration]
config_bucket.clear!
obj = config_bucket.objects[:current]
obj.write :file => config_file_name
url = obj.url_for :read

cnt = 0

# bucket_suffix = "#{Time.now \
#   .to_s.gsub!(':', '-') \
#   .gsub(' ', '.')}"
# bucket_name = "chrislambistan_log-#{bucket_suffix}"
# s3.buckets.create bucket_name

bucket_name = 'chrislambistan_log'

namespace :nodes do

	task :start, :roles => :nodes do
		run "cd current ; bundle exec bin/main \"#{url}\" #{access_key} #{secret_key} #{bucket_name}"
	end

  task :monitor, :roles => :nodes do
    stream 'tail -f ./current/system.log'
  end

  task :hostnames, :roles => :nodes do
    run 'hostname'
  end

  task :stop, :roles => :nodes do
    run "cd current ; bundle exec bin/stop_overlay_component"
  end

  task :ps, :roles => :nodes do
    run "ps -ef | grep overlay"
  end

  task :cat, :roles => :node do
    run "cat current/system.log"
  end

  task :tail, :roles => :node do
    run "tail -f current/system.log"
  end

end