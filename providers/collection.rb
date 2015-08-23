def whyrun_supported?
  true
end

use_inline_resources

action :create do
  #converge_by "Create new collection #{new_resource.name} from configset #{new_resource.configset_name}"
    uri = URI("http://localhost:8080/solr/admin/collections?action=CREATE&name=#{new_resource.name}&numShards=#{new_resource.num_shards}&replicationFactor=#{new_resource.replication_factor}&collection.configName=#{new_resource.configset_name}")
    Net::HTTP.get(uri)
end
