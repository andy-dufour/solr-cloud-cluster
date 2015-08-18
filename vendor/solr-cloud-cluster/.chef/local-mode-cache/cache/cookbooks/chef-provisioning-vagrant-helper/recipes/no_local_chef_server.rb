
require 'chef/provisioning/vagrant_driver'

vagrants_dir = node['chef-provisioning-vagrant']['vagrants_dir']

log "[chef-provisioning-vagrant] Your vagrantfiles will be located in: #{vagrants_dir}"

directory vagrants_dir
vagrant_cluster vagrants_dir
