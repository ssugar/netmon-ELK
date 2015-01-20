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
cp /home/vagrant/senseHCMCDashboard.json /usr/share/nginx/www/kibana/app/dashboards/default.json
cd /usr/share/elasticsearch
bin/plugin -install lukas-vlcek/bigdesk
cd /home/vagrant
service nginx restart
service logstash restart
service elasticsearch restart
SCRIPT

$script3 = <<SCRIPT
cd /home/vagrant
tar -xvf updatedEsMappings.tar
./updatedEsMappings.sh
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
   #Set the virtual machine 'box' to use
   config.vm.box = "hashicorp/precise64"
   #Set the vm name
   config.vm.define :elkStack2 do |t|
   end
   
   #copy the ELK installer files locally to save time
   config.vm.provision "file", source: "./localELK/elasticsearch-1.4.2.deb", destination: "/home/vagrant/elasticsearch-1.4.2.deb"
   config.vm.provision "file", source: "./localELK/logstash-1.4.2-1.deb", destination: "/home/vagrant/logstash-1.4.2-1.deb"
   config.vm.provision "file", source: "./localELK/kibana-latest.tar.gz", destination: "/home/vagrant/kibana-latest.tar.gz"
   
   #run the script above
   config.vm.provision "shell", inline: $script

   #copy a few config files into their place post install
   config.vm.provision "file", source: "./cookbooks/ss_logstash/files/default/logstash.conf", destination: "/home/vagrant/logstash.conf"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/elasticsearch.yml", destination: "/home/vagrant/elasticsearch.yml"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/senseHCMCDashboard.json", destination: "/home/vagrant/senseHCMCDashboard.json"
   config.vm.provision "file", source: "./testing/sendData.py", destination: "/home/vagrant/sendData.py"

   #restart the services we just replaced configs for
   config.vm.provision "shell", inline: $script2
   
   #run a shell script that updates the elasticsearch mappings for proper viewing in elasticsearch (kibana) queries
   config.vm.provision "file", source: "./updatedEsMappings.tar", destination: "/home/vagrant/updatedEsMappings.tar"
   config.vm.provision "shell", inline: $script3

   
end
