#
# Cookbook Name:: solr-cloud-cluster
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

execute 'apt-get update' do
  command 'apt-get update'
end

include_recipe 'java'

remote_file '/tmp/solr-5.2.1.tgz' do
  source 'http://apache.mirror.gtcomm.net/lucene/solr/5.2.1/solr-5.2.1.tgz'
end

execute 'extract installer' do
  command 'tar xzf solr-5.2.1.tgz solr-5.2.1/bin/install_solr_service.sh --strip-components=2'
  cwd '/tmp/'
end

execute 'install solr' do
  command 'bash ./install_solr_service.sh solr-5.2.1.tgz -i /opt -d /var/solr -u solr -s solr -p 8080'
  cwd '/tmp/'
end

# TODO: If I'm in the first one, then create the schema and upload to ZK.


# TODO: Wait until we have quorom then create the collection
