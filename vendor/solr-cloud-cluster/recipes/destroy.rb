#
# Cookbook Name:: solr-cloud-cluster
# Recipe:: destroy
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "solr-cloud-cluster::destroy_#{node['solr-cloud-cluster']['provisioning']['driver']}"
