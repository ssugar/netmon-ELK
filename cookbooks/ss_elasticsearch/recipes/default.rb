#
# Cookbook Name:: ss_elasticsearch
# Recipe:: default
#
package "openjdk-7-jdk" do
  action :install
end

execute "get_elasticsearch" do
  command "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb"
end

execute "install_elasticsearch" do
  command "dpkg -i elasticsearch-1.4.2.deb"
end

execute "atboot_elasticsearch" do
  command "update-rc.d elasticsearch defaults 95 10"
end

execute "start_elasticsearch" do
  command "service elasticsearch start"
end

#execute "install_elasticsearch_head" do
#  command "/usr/share/elasticsearch/bin/plugin --install mobz/elasticsearch-head"
#end

#execute "install_elasticsearch_head" do
#  command "/usr/share/elasticsearch/bin/plugin --install lukas-vlcek/bigdesk"
#end
