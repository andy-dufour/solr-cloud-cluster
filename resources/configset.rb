actions :upconfig
default_action :upconfig

attribute :name,              kind_of: String, required: true, name_attribute: true
attribute :solrhome,          kind_of: String, required: true, default: '/opt/solr'
attribute :confdir,           kind_of: String, required: true
attribute :zk_hostname,       kind_of: String, required: true
attribute :zk_port,           kind_of: Integer, required: true, default: 2181
