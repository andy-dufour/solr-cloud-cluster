directory "/tmp/chef-config/" do
  action :create
end

template "/tmp/chef-config/schema.xml" do
  source "schema.xml.erb"
end

template "/tmp/chef-config/solrconfig.xml" do
  source "solrconfig.xml.erb"
end

solr_cloud_cluster_configset "chefconfig" do
  zk_hostname 'zookeeper'
  zk_port 2181
  solrhome '/opt/solr'
  confdir '/tmp/chef-config'
end
