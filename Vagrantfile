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
apt-get install curl -y
apt-get install nano -y
apt-get install nginx -y
apt-get install openjdk-7-jdk -y
cd /home/vagrant
dpkg -i elasticsearch-1.4.2.deb
update-rc.d elasticsearch defaults 95 10
cp /home/vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
service elasticsearch start
dpkg -i logstash-1.4.2-1.deb
service logstash restart
tar -xvzf kibana-latest.tar.gz
cp -R kibana-latest /usr/share/nginx/www/kibana
SCRIPT

$script2 = <<SCRIPT
cp /home/vagrant/logstash.conf /etc/logstash/conf.d/logstash.conf
cp /home/vagrant/netflow.json /usr/share/nginx/www/kibana/app/dashboards/default.json
cp /home/vagrant/drayteksyslog.json /usr/share/nginx/www/kibana/app/dashboards/drayteksyslog.json
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
   config.vm.provision "file", source: "./localELK/elasticsearch-1.4.2.deb", destination: "/home/vagrant/elasticsearch-1.4.2.deb"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/elasticsearch.yml", destination: "/home/vagrant/elasticsearch.yml"
   config.vm.provision "file", source: "./localELK/logstash-1.4.2-1.deb", destination: "/home/vagrant/logstash-1.4.2-1.deb"
   config.vm.provision "file", source: "./localELK/kibana-latest.tar.gz", destination: "/home/vagrant/kibana-latest.tar.gz"
   config.vm.provision "file", source: "./cookbooks/ss_softflowd/files/default/softflowd.conf", destination: "/home/vagrant/softflowd"   
   
   #run the script above
   config.vm.provision "shell", inline: $script

   #copy a few config files into their place post install
   config.vm.provision "file", source: "./cookbooks/ss_logstash/files/default/logstash.conf", destination: "/home/vagrant/logstash.conf"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/netflow.json", destination: "/home/vagrant/netflow.json"
   config.vm.provision "file", source: "./cookbooks/ss_kibana/files/default/drayteksyslog.json", destination: "/home/vagrant/drayteksyslog.json"

   #restart the services we just replaced configs for and attempts to set some mappings for elasticsearch.
   config.vm.provision "shell", inline: $script2
   
   config.vm.provision "shell", path: "updatedEsMappings.sh"

   config.vm.provision "shell", inline: $script3

end
