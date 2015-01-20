#
# Cookbook Name:: ss_logstash
# Recipe:: default
#

execute "get_logstash" do
  command "wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb"
end

execute "install_logstash" do
  command "dpkg -i logstash_1.4.2-1-2c0f5a1_all.deb"
end

cookbook_file "/etc/logstash/conf.d/logstash.conf" do
  source "logstash.conf"
end

execute "start_logstash" do
  command "service logstash restart"
end

