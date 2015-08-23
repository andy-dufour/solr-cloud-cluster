actions :create
default_action :create

attribute :name,                         kind_of: String, required: true, name_attribute: true
attribute :num_shards,                   kind_of: Integer, default: 1
attribute :replication_factor,           kind_of: Integer, default: 1
attribute :configset_name,               kind_of: String, required: true
