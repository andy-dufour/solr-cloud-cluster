#
# Cookbook Name:: solr-cloud-cluster
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


include_recipe "solr-cloud-cluster::solr"

#
# remote_file '/tmp/solr-5.2.1.tgz' do
#   source 'http://apache.mirror.gtcomm.net/lucene/solr/5.2.1/solr-5.2.1.tgz'
# end
#
# execute 'extract installer' do
#   command 'tar xzf solr-5.2.1.tgz solr-5.2.1/bin/install_solr_service.sh --strip-components=2'
#   cwd '/tmp/'
#   not_if { ::File.exist?('/etc/init.d/solr') }
# end
#
# execute 'install solr' do
#   command 'bash ./install_solr_service.sh solr-5.2.1.tgz -i /opt -d /var/solr -u solr -s solr -p 8080'
#   cwd '/tmp/'
#   not_if { ::File.exist?('/etc/init.d/solr') }
# end
#
# zks = search(:node, 'name:zookeeper*',
#   :filter_result => { 'name' => [ 'name' ],
#                       'fqdn' => [ 'fqdn' ],
#                       'network_interfaces' => [ 'network', 'interfaces' ]
#                     }
#       ).reject { |nodedata| nodedata['network_interfaces'].nil? }
#
# zks.each do |z|
#   hostsfile_entry extract_cluster_ip(z) do
#     hostname z['fqdn']
#     aliases [ z['name'] ]
#     unique true
#     comment 'Chef solr-cloud-cluster cookbook'
#   end
# end
#
# template '/var/solr/solr.in.sh' do
#   source 'solr.in.sh.erb'
#   owner 'solr'
#   variables ({
#       :zk_servers => zks.sample
#     })
# end
#
# execute 'restart solr' do
#   command 'service solr restart'
# end
#
# # TODO: If I'm in the first one, then create the schema and upload to ZK.
# solr_servers = search(:node, 'name:solr*', :filter_result => { 'name' => [ 'name' ],
#                     'fqdn' => [ 'fqdn' ],
#                     'network_interfaces' => [ 'network', 'interfaces' ]
#                       }
#                     )
#
# include_recipe "solr-cloud-cluster::create_zk_configset"
#
#   solr_cloud_cluster_collection 'chef' do
#     configset_name 'chefconfig'
#     not_if { collection_exists?('chef') }
#   end
