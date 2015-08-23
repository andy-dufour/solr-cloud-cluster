require "net/http"

def extract_cluster_ip(node_results)
  use_interface = 'eth1'
  node_results['network_interfaces'][use_interface]['addresses']
    .select { |k,v| v['family'] == 'inet' }.keys
end

def extract_host_ip(node)
  use_interface = 'eth1'
  node['network']['interfaces'][use_interface]['addresses']
    .select { |k,v| v['family'] == 'inet' }.keys
end

def collection_exists?(collection_name)
  url = URI.parse("http://localhost:8080/solr/#{collection_name}/select?q=test:test")
  req = Net::HTTP.new(url.host, url.port)
  res = req.request_head(url.path)

  if res.code == 200 then
    true
  else
    false
  end
end
