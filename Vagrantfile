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
echo "Asia/Ho_Chi_Minh" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
apt-get update
apt-get install curl wget -y
apt-get install nano -y
apt-get install nginx -y
apt-get install openjdk-7-jdk -y
cd /home/vagrant
dpkg -i elasticsearch-1.7.1.deb
update-rc.d elasticsearch defaults 95 10
cp /etc/elasticsearch/elasticsearch.yml /home/vagrant/elasticsearch.yml.bak
cp /home/vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
service elasticsearch start
dpkg -i logstash_1.5.3-1_all.deb
update-rc.d logstash defaults 95 10
service logstash start
tar -xvzf kibana-4.1.1-linux-x64.tar.gz
mkdir -p /opt/kibana
cp -R kibana-4.1.1-linux-x64/* /opt/kibana/
wget https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4
cp kibana4 /etc/init.d/kibana4
chmod +x /etc/init.d/kibana4
update-rc.d kibana4 defaults 96 9
service kibana4 start
SCRIPT

$script2 = <<SCRIPT
cp /home/vagrant/logstash.conf /etc/logstash/conf.d/logstash.conf
cd /home/vagrant
service nginx restart
service logstash restart
type -a curl
curl -4 -v -XGET http://localhost:9200
SCRIPT

$script3 = <<SCRIPT
apt-get install softflowd -y
service softflowd stop
cp /home/vagrant/softflowd /etc/default/softflowd
service softflowd start
dpkg -i packetbeat_1.0.0-beta2_amd64.deb
curl -XPUT 'http://localhost:9200/_template/packetbeat' -d@/etc/packetbeat/packetbeat.template.json
update-rc.d packetbeat defaults 95 10
curl -L -O https://download.elastic.co/beats/packetbeat/packetbeat-dashboards-1.0.0-beta2.tar.gz
tar xzvf packetbeat-dashboards-1.0.0-beta2.tar.gz
cd packetbeat-dashboards-1.0.0-beta2/
./load.sh
cd ..
service packetbeat start
SCRIPT


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
   #Set the virtual machine 'box' to use
   config.vm.box = "hashicorp/precise64"
   #Set the vm name
   config.vm.define :netmonELK do |t|
   end

   config.vm.provider :hyperv do |v|
	 v.vmname = "netmonELK"
     v.memory = 2048
	 v.cpus = 2
   end
   
   #copy the ELK installer files locally to save time
   config.vm.provision "file", source: "./localELK/elasticsearch-1.7.1.deb", destination: "/home/vagrant/elasticsearch-1.7.1.deb"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/elasticsearch.yml", destination: "/home/vagrant/elasticsearch.yml"
   config.vm.provision "file", source: "./localELK/logstash_1.5.3-1_all.deb", destination: "/home/vagrant/logstash_1.5.3-1_all.deb"
   config.vm.provision "file", source: "./localELK/kibana-4.1.1-linux-x64.tar.gz", destination: "/home/vagrant/kibana-4.1.1-linux-x64.tar.gz"
   config.vm.provision "file", source: "./localELK/packetbeat_1.0.0-beta2_amd64.deb", destination: "/home/vagrant/packetbeat_1.0.0-beta2_amd64.deb"
   config.vm.provision "file", source: "./cookbooks/ss_softflowd/files/default/softflowd.conf", destination: "/home/vagrant/softflowd"   
   
   #run the script above
   config.vm.provision "shell", inline: $script

   #copy a few config files into their place post install
   config.vm.provision "file", source: "./cookbooks/ss_logstash/files/default/logstash.conf", destination: "/home/vagrant/logstash.conf"

   #restart the services we just replaced configs for and attempts to set some mappings for elasticsearch.
   config.vm.provision "shell", inline: $script2
   
   config.vm.provision "shell", path: "updatedEsMappings.sh"

   config.vm.provision "shell", inline: $script3

end
