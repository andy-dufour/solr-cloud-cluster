# chef-zero attributes
default['chef-provisioning-vagrant']['chef_repo'] = "/Users/andrewdufour/Development/solr-cloud-cluster"
default['chef-provisioning-vagrant']['vagrants_dir'] = "/Users/andrewdufour/Development/solr-cloud-cluster/vagrants"
default['chef-provisioning-vagrant']['vendor_cookbooks_path'] = "/Users/andrewdufour/Development/solr-cloud-cluster/vendor"
default['chef-provisioning-vagrant']['use_local_chef_server'] = true

default['solr-cloud-cluster']['version']  = '4.10.4'
default['solr-cloud-cluster']['url']      = "https://archive.apache.org/dist/lucene/solr/#{node['solr-cloud-cluster']['version']}/#{node['solr-cloud-cluster']['version'].split('.')[0].to_i < 4 ? 'apache-' : ''}solr-#{node['solr-cloud-cluster']['version']}.tgz"
default['solr-cloud-cluster']['data_dir'] = '/etc/solr'
default['solr-cloud-cluster']['dir']      = '/opt/solr'
default['solr-cloud-cluster']['port']     = 8080
default['solr-cloud-cluster']['pid_file'] = '/var/run/solr.pid'
default['solr-cloud-cluster']['log_file'] = '/var/log/solr.log'
default['solr-cloud-cluster']['user']     = 'root'
default['solr-cloud-cluster']['group']    = 'root'
default['solr-cloud-cluster']['install_java'] = true
default['solr-cloud-cluster']['java_options'] = '-Xms128M -Xmx512M'


default['zookeeper']['service_style'] = 'upstart'
default['java']['jdk_version'] = '7'
default['solr-cloud-cluster']['provisioning']['driver'] = 'vagrant'

# Vagrant settings
default['chef-provisioning-vagrant']['vbox']['box'] = 'opscode-ubuntu-14.04'
default['chef-provisioning-vagrant']['vbox']['url'] = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
default['chef-provisioning-vagrant']['vbox']['ram'] = 512
default['chef-provisioning-vagrant']['vbox']['cpus'] = 1
default['chef-provisioning-vagrant']['vbox']['private_networks']['default'] = 'dhcp'

default['solr-cloud-cluster']['solr_cluster_nodes_count'] = 3
default['solr-cloud-cluster']['cluster_nodes'] = 1.upto(node['solr-cloud-cluster']['solr_cluster_nodes_count']).map { |i| "solrcloud-#{i}.example.com" }


zk_cluster_nodes_count = 1
default['solr-cloud-cluster']['zk_cluster_nodes'] = 1.upto(zk_cluster_nodes_count).map { |i| "zookeeper-#{i}.example.com" }

default['solr-cloud-cluster']['chef_client_name'] = 'testuser'
default['solr-cloud-cluster']['chef_client_key'] = '/Users/andrewdufour/.chef/client.pem'
default['solr-cloud-cluster']['chef_server'] = '192.168.33.110'
