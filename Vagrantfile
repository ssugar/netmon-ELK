# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#script to set everything up. chef is slow to download now while the AAG line is cut so only using vagrant provisioners to speed development up
$script = <<SCRIPT
sudo su
echo "deb http://mirror-fpt-telecom.fpt.net/ubuntu/ precise main restricted universe" > /etc/apt/sources.list
echo "deb http://mirror-fpt-telecom.fpt.net/ubuntu/ precise-updates main restricted universe" >> /etc/apt/sources.list
echo "deb http://mirror-fpt-telecom.fpt.net/ubuntu/ precise-security main restricted universe" >> /etc/apt/sources.list
apt-get update
apt-get install curl -y
apt-get install nano -y
apt-get install nginx -y
apt-get install openjdk-7-jdk -y
cd /home/vagrant
dpkg -i elasticsearch-1.4.2.deb
update-rc.d elasticsearch defaults 95 10
service elasticsearch start
dpkg -i logstash-1.4.2-1.deb
service logstash restart
tar -xvzf kibana-latest.tar.gz
cp -R kibana-latest /usr/share/nginx/www/kibana
service elasticsearch restart
SCRIPT

$script2 = <<SCRIPT
cp /home/vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
cp /home/vagrant/logstash.conf /etc/logstash/conf.d/logstash.conf
cp /home/vagrant/drayteksyslog.json /usr/share/nginx/www/kibana/app/dashboards/default.json
cp /home/vagrant/netflow.json /usr/share/nginx/www/kibana/app/dashboards/netflow.json
cd /usr/share/elasticsearch
service elasticsearch restart
bin/plugin -install lukas-vlcek/bigdesk
cd /home/vagrant
service nginx restart
service logstash restart
type -a curl
curl -4 -v -XGET http://localhost:9200
curl -4 -v -XPUT http://localhost:9200/_template/logstash_per_index -d '{"template" : "logstash*","settings": {"index.cache.field.type": "soft","index.store.compress.stored": true},"mappings" : {"_default_" : {"_all" : {"enabled" : false},"properties" : {"@message":     { "index": "analyzed", "type": "string"  },"@source":      { "index": "not_analyzed", "type": "string"  },"@source_host": { "index": "not_analyzed", "type": "string" },"@source_path": { "index": "not_analyzed", "type": "string" },"@tags":        { "index": "not_analyzed", "type": "string" },"@timestamp":   { "index": "not_analyzed", "type": "date" },"@type":        { "index": "not_analyzed", "type": "string" },"source":       { "index": "not_analyzed", "type": "string" },"destination":  { "index": "not_analyzed", "type": "string" },"groupName":    { "index": "not_analyzed", "type": "string" },"lastLoginName":  { "index": "not_analyzed", "type": "string" },"Machine_GroupID":  { "index": "not_analyzed", "type": "string" },"Manufacturer":  { "index": "not_analyzed", "type": "string" },"ConnectionGatewayIp":  { "index": "not_analyzed", "type": "string" },"CPUs.CPU.CpuDesc":  { "index": "not_analyzed", "type": "string" },"lastLoginName":  { "index": "not_analyzed", "type": "string" },"ComputerName":  { "index": "not_analyzed", "type": "string" },"OsType":       { "index": "not_analyzed", "type": "string" },"uptime":       { "index": "analyzed", "type": "float" },"diskused":     { "index": "analyzed", "type": "integer" },"@LoginName":   { "index": "not_analyzed", "type": "string" },"netflow": {"dynamic": true,"path": "full","properties": {"version": { "index": "analyzed", "type": "integer" },"first_switched": { "index": "not_analyzed", "type": "date" },"last_switched": { "index": "not_analyzed", "type": "date" },"direction": { "index": "not_analyzed", "type": "integer" },"flowset_id": { "index": "not_analyzed", "type": "integer" },"flow_sampler_id": { "index": "not_analyzed", "type": "integer" },"flow_seq_num": { "index": "not_analyzed", "type": "long" },"src_tos": { "index": "not_analyzed", "type": "integer" },"tcp_flags": { "index": "not_analyzed", "type": "integer" },"protocol": { "index": "not_analyzed", "type": "integer" },"ipv4_next_hop": { "index": "not_analyzed", "type": "string" },"in_bytes": { "index": "not_analyzed", "type": "long" },"in_pkts": { "index": "not_analyzed", "type": "long" },"out_bytes": { "index": "not_analyzed", "type": "long" },"out_pkts": { "index": "not_analyzed", "type": "long" },"input_snmp": { "index": "not_analyzed", "type": "long" },"output_snmp": { "index": "not_analyzed", "type": "long" },"ipv4_dst_addr": { "index": "not_analyzed", "type": "string" },"ipv4_src_addr": { "index": "not_analyzed", "type": "string" },"dst_mask": { "index": "analyzed", "type": "integer" },"src_mask": { "index": "analyzed", "type": "integer" },"dst_as": { "index": "analyzed", "type": "integer" },"src_as": { "index": "analyzed", "type": "integer" },"l4_dst_port": { "index": "not_analyzed", "type": "long" },"l4_src_port": { "index": "not_analyzed", "type": "long" }},"type": "object"},"geoip": {"dynamic": true,"path": "full","properties": {"city_name": { "index": "not_analyzed", "type": "string"},"real_region_name": { "index": "not_analyzed", "type": "string"}},"type": "object"}}}'
apt-get install softflowd -y
service softflowd stop
cp /home/vagrant/softflowd /etc/default/softflowd
service softflowd start
SCRIPT


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
   #Set the virtual machine 'box' to use
   config.vm.box = "hashicorp/precise64"
   #Set the vm name
   config.vm.define :netmonELK do |t|
   end
   
   #copy the ELK installer files locally to save time
   config.vm.provision "file", source: "./localELK/elasticsearch-1.4.2.deb", destination: "/home/vagrant/elasticsearch-1.4.2.deb"
   config.vm.provision "file", source: "./localELK/logstash-1.4.2-1.deb", destination: "/home/vagrant/logstash-1.4.2-1.deb"
   config.vm.provision "file", source: "./localELK/kibana-latest.tar.gz", destination: "/home/vagrant/kibana-latest.tar.gz"
   config.vm.provision "file", source: "./cookbooks/ss_softflowd/files/default/softflowd.conf", destination: "/home/vagrant/softflowd"   
   
   #run the script above
   config.vm.provision "shell", inline: $script

   #copy a few config files into their place post install
   config.vm.provision "file", source: "./cookbooks/ss_logstash/files/default/logstash.conf", destination: "/home/vagrant/logstash.conf"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/elasticsearch.yml", destination: "/home/vagrant/elasticsearch.yml"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/netflow.json", destination: "/home/vagrant/netflow.json"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/drayteksyslog.json", destination: "/home/vagrant/drayteksyslog.json"

   #restart the services we just replaced configs for and attempts to set some mappings for elasticsearch.
   config.vm.provision "shell", inline: $script2

end
