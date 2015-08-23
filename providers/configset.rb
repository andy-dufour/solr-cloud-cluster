def whyrun_supported?
  true
end

use_inline_resources

action :upconfig do
  #converge_by "Uploading configset #{new_resource.name} from #{new_resource.confdir}"
    execute "configset_upconfig_#{new_resource.name}" do
      command <<-EOM
        /opt/solr/server/scripts/cloud-scripts/zkcli.sh -cmd upconfig -zkhost #{new_resource.zk_hostname}:#{new_resource.zk_port} -confname #{new_resource.name} -solrhome #{new_resource.solrhome} -confdir #{new_resource.confdir}
      EOM
    end
end
