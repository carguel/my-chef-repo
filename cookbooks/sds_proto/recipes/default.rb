#
# Cookbook Name:: sds_proto
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


sds_user = node["sds_proto"]["user"]
sds_user_home = "/home/#{sds_user}"
sds_rabbitmq_proto_path = "#{sds_user_home}/rabbitmq-proto"
sds_activemq_proto_path = "#{sds_user_home}/activemq-proto"

user(sds_user) do
  comment "SDS User"
  shell "/bin/bash"
  home  sds_user_home
  supports :manage_home => true
end

package "maven2"

git "#{sds_rabbitmq_proto_path}" do
  user sds_user
  repository "git://github.com/carguel/rabbitmq-proto.git"
  reference "master"
  action :sync
end


execute "mvn" do
  command "mvn install"
  action :run
  user sds_user
  cwd sds_rabbitmq_proto_path
end


git "#{sds_activemq_proto_path}" do
  user sds_user
  repository "git://github.com/carguel/activemq-proto.git"
  reference "master"
  action :sync
end
