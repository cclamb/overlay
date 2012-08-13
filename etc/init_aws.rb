require 'yaml'
require 'aws-sdk'

creds_file_name = 'creds.yaml'

creds = YAML::load File::open(creds_file_name)

access_key = creds['amazon']['access_key']
secret_key = creds['amazon']['secret_key']

AWS.config \
  :access_key_id => access_key, \
  :secret_access_key => secret_key
