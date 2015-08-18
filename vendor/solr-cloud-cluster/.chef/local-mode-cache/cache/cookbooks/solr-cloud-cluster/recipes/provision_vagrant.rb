
include_recipe 'chef-provisioning-vagrant-helper'


    machine 'zookeeper.example.com' do
      recipe 'solr-cloud-cluster::zookeeper'
      machine_options vagrant_options('zookeeper')
    end


machine_batch 'solr-servers' do
  action [:converge]

  node['solr-cloud-cluster']['cluster_nodes'].each do |vmname|
    machine vmname do
      recipe 'solr-cloud-cluster'
      machine_options vagrant_options(vmname)
    end
  end
end
