#
# Cookbook Name:: ss_kibana
# Recipe:: default
#

#Kibana 3 - available at http://IPAddress/kibana
execute "get_kibana" do
  command "wget https://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz"
end

execute "unpack_kibana" do
  command "tar -xvzf kibana-latest.tar.gz"
end

execute "move_kibana" do
  command "cp -R kibana-latest /usr/share/nginx/www/kibana"
end

cookbook_file "/usr/share/nginx/www/kibana/app/dashboards/default.json" do
  source "drayteksyslog.json"
end

#Update elasticsearch.yml so the new security in version 1.4 doesn't stop Kibana 3 from connecting
cookbook_file "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml"
end

execute "restart_elasticsearch" do
  command "service elasticsearch restart"
end

#Kibana 4 - Need to run the kibana executable for it to work.  It will tell you where it's running.
execute "get_kibana4" do
  command "wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-beta3.tar.gz"
end

execute "unpack_kibana4" do
  command "tar -xvzf kibana-4.0.0-beta3.tar.gz"
end



