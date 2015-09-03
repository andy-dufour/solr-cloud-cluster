execute 'apt-get update' do
  command 'apt-get update'
  not_if { ::File.exist?('/etc/init.d/solr') }
end

package 'unzip'

package 'vim'

include_recipe 'java'

src_filename = ::File.basename(node['solr-cloud-cluster']['url'])
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{node['solr-cloud-cluster']['dir']}-#{node['solr-cloud-cluster']['version']}"
solr_path = "#{extract_path}/#{node['solr-cloud-cluster']['version'].split('.')[0].to_i < 5 ? 'example' : 'server'}"

remote_file src_filepath do
  source node['solr-cloud-cluster']['url']
  action :create_if_missing
end

bash 'unpack_solr' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filename} -C #{extract_path} --strip 1
    chown -R #{node['solr-cloud-cluster']['user']}:#{node['solr-cloud-cluster']['group']} #{extract_path}
  EOH
  not_if { ::File.exist?(extract_path) }
end

link '/opt/solr' do
  to extract_path
end

directory node['solr-cloud-cluster']['data_dir'] do
  owner node['solr-cloud-cluster']['user']
  group node['solr-cloud-cluster']['group']
  recursive true
  action :create
end

zks = search(:node, 'name:zookeeper*',
  :filter_result => { 'name' => [ 'name' ],
                      'fqdn' => [ 'fqdn' ],
                      'network_interfaces' => [ 'network', 'interfaces' ]
                    }
      ).reject { |nodedata| nodedata['network_interfaces'].nil? }
zks.each do |z|
  hostsfile_entry extract_cluster_ip(z) do
    hostname z['fqdn']
    aliases [ z['name'] ]
    unique true
    comment 'Chef solr-cloud-cluster cookbook'
  end
end

template '/var/lib/solr.start' do
  source 'solr.start.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    :solr_dir => solr_path,
    :solr_home => node['solr-cloud-cluster']['data_dir'],
    :port => node['solr-cloud-cluster']['port'],
    :pid_file => node['solr-cloud-cluster']['pid_file'],
    :log_file => node['solr-cloud-cluster']['log_file'],
    :java_options => node['solr-cloud-cluster']['java_options'],
    :zk_ip => extract_cluster_ip(zks.sample)
  )
  only_if { !platform_family?('debian') }
end

template '/etc/init.d/solr' do
  source platform_family?('debian') ? 'initd.debian.erb' : 'initd.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    :solr_dir => solr_path,
    :solr_home => node['solr-cloud-cluster']['data_dir'],
    :port => node['solr-cloud-cluster']['port'],
    :pid_file => node['solr-cloud-cluster']['pid_file'],
    :log_file => node['solr-cloud-cluster']['log_file'],
    :user => node['solr-cloud-cluster']['user'],
    :java_options => node['solr-cloud-cluster']['java_options'],
    :zk_ip => extract_cluster_ip(zks.sample)[0]
  )
end

directory '/etc/solr/collection1/conf/' do
  action :create
  recursive true
end

template '/etc/solr/solr.xml' do
  source 'solr.xml.erb'
  variables(
    :solr_ip => extract_host_ip(node)[0]
  )
end

cookbook_file '/etc/solr/collection1/schema.xml' do
  source 'schema.xml'
end

cookbook_file '/etc/solr/collection1/solrconfig.xml' do
  source 'solrconfig.xml'
end

solr_cloud_cluster_configset "collection1" do
  zk_hostname extract_cluster_ip(zks.sample)[0]
  zk_port 2181
  solrhome '/etc/solr'
  confdir '/etc/solr/collection1'
end

service 'solr' do
  supports :restart => true, :status => true
  action [:enable, :start]
end

found_nodes = search(:node, "name:solrcloud*",
  filter_result: {
    'name' => [ 'name' ],
    'fqdn' => [ 'fqdn' ],
    'network_interfaces' => [ 'network', 'interfaces' ]
  }
).reject { |nodedata| nodedata['network_interfaces'].nil? } #not if no interface data

if found_nodes.count == node['solr-cloud-cluster']['solr_cluster_nodes_count']
  execute 'create_collection' do
    command 'sleep 10;wget http://localhost:8080/solr/admin/collections?action=CREATE\&name=collection1\&numShards=3\&replicationFactor=1\&collection.configName=collection1 -O /dev/null'
  end
end
#
# solr_cloud_cluster_collection 'chef' do
#   configset_name 'collection1'
#   not_if { collection_exists?('collection1') }
# end
