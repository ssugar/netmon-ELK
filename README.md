#netmon-ELK#

##Description##
Vagrantfile to deploy the ELK stack [Elasticsearch, Logstash, and Kibana](http://www.elastic.co) and Packetbeat for use as a Netmon and Syslog analysis tool.

===================================
##Setup without Vagrant##
If not using Vagrant, run the following commands on a fresh debian/ubuntu install after logging in as root to mimic the same behaviour

###Prepare Apt###
  
	apt-get update

###Install Nginx###
    apt-get install nginx
	service nginx start
  
###Install Elasticsearch###
    apt-get install openjdk-7-jdk
    wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.1.deb
    dpkg -i elasticsearch-1.7.1.deb
    update-rc.d elasticsearch defaults 95 10
    service elasticsearch start
  Elasticsearch 1.7.1 debian package available [here](localELK/elasticsearch-1.7.1.deb).  Use this if connection to elastic.co is slow.

###Install Logstash###
    wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_1.5.3-1_all.deb
    dpkg -i logstash_1.5.3-1_all.deb
    update-rc.d logstash defaults 95 10
  Logstash 1.5.3-1 debian package available [here](localELK/logstash_1.5.3-1_all.deb).  Use this if connection to elastic.co is slow.

  Then copy the logstash.conf file available in this project at: [cookbooks/ss_logstash/files/default/logstash.conf](cookbooks/ss_logstash/files/default/logstash.conf) to: /etc/logstash/conf.d/logstash.conf.  When that is done:
  
    service logstash restart

###Install Kibana 4###
    wget https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
    tar -xvzf kibana-4.1.1-linux-x64.tar.gz
	mkdir -p /opt/kibana
	cp -R kibana-4.1.1-linux-x64/* /opt/kibana/
	wget https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4
	cp kibana4 /etc/init.d/kibana4
	chmod +x /etc/init.d/kibana4
	update-rc.d kibana4 defaults 96 9
	service kibana4 start
  Kibana 4 tarball available [here](localELK/kibana-4.1.1-linux-x64.tar.gz).  Use this if connection to elastic.co is slow.

###Install Packetbeat###
	https://download.elastic.co/beats/packetbeat/packetbeat_1.0.0-beta2_amd64.deb
	dpkg -i packetbeat_1.0.0-beta2_amd64.deb
	curl -XPUT 'http://localhost:9200/_template/packetbeat' -d@/etc/packetbeat/packetbeat.template.json
	update-rc.d packetbeat defaults 95 10
	curl -L -O https://download.elastic.co/beats/packetbeat/packetbeat-dashboards-1.0.0-beta2.tar.gz
	tar xzvf packetbeat-dashboards-1.0.0-beta2.tar.gz
	cd packetbeat-dashboards-1.0.0-beta2/
	./load.sh
  Packetbeat 1.0.0-beta2 available [here](localELK/packetbeat_1.0.0-beta2_amd64.deb).  Use this if connection to elastic.co is slow.

	
###Access Web Portal###
    http://server_ip:5601

###HyperV Promiscuous Mode point to VM###
Set up the virtual machine running netflow as the destination for port mirroring data (run in powershell on the hyperv host).  [Original article](http://www.cloudbase.it/hyper-v-promiscuous-mode/)

	Set-VMNetworkAdapter vmName -PortMirroring Destination

Set up the hosts virtual switch as the source of port mirroring data. 

Get this [powershell module](https://github.com/cloudbase/unattended-setup-scripts/blob/master/VMSwitchPortMonitorMode.psm1)

    Import-Module .\VMSwitchPortMonitorMode.psm1
	Set-VMSwitchPortMonitorMode -SwitchName switchName -MonitorMode Source
	
Check a switch's port monitoring status

    Get-VMSwitchPortMonitoringMode switchName
	
Disable the port mirroring for a switch

	Set-VMSwitchPortMonitorMode -SwitchName switchName -MonitorMode None