# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "devopscube"
client_key               "#{current_dir}/devopscube.pem"
validation_client_name   "dcube-validator"
validation_key           "#{current_dir}/dcube-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/dcube"
cookbook_path            ["#{current_dir}/../cookbooks"]
