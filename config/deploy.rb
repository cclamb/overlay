
require 'bundler/capistrano'
require 'rvm/capistrano'

require 'yaml'
require 'aws-sdk'

set :rvm_ruby_string, '1.9.3'

ssh_options[:keys] = ['etc/pod.pem']

set :application, 'ruby-scratch'
set :repository,  'https://github.com/cclamb/overlay.git'

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


# Prime simulation configuration
config_file_name = 'etc/config.yaml'

access_key = creds['amazon']['access_key']
secret_key = creds['amazon']['secret_key']

AWS.config \
  :access_key_id => access_key, \
  :secret_access_key => secret_key

# Push to S3
config_bucket = AWS::S3.new.buckets[:chrislambistan_configuration]
config_bucket.clear!
obj = config_bucket.objects[:current]
obj.write :file => config_file_name
url = obj.url_for :read

cnt = 0

puts "URL : #{url}"

namespace :nodes do

	task :start, :roles => :nodes do
		run "cd current ; bundle exec bin/spinner \"#{url}\" #{access_key} #{secret_key}"
	end

end