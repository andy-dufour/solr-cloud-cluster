#
# Cookbook Name:: solr-cloud-cluster
# Recipe:: destroy_vagrant
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'chef-provisioning-vagrant-helper::default'

machine_batch do
  action :destroy
  machines search(:node, '*:*').map { |n| n.name }
end
