#netmon-ELK#

##Description##
Vagrantfile to deploy the ELK stack [Elasticsearch, Logstash, and Kibana](http://www.elasticsearch.org/overview/) for use as a Netmon and Syslog analysis tool.

===================================
##Setup without Vagrant##
If not using Vagrant and Chef, run the following commands on a fresh debian/ubuntu install after logging in as root to mimic the same behaviour:

###Prepare Apt###
  
	apt-get update

###Install Nginx###
    apt-get install nginx
	service nginx start
  
###Install Elasticsearch###
    apt-get install openjdk-7-jdk
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb
    dpkg -i elasticsearch-1.4.2.deb
    update-rc.d elasticsearch defaults 95 10
    service elasticsearch start
  Elasticsearch 1.4.2 debian package available [here](localELK/elasticsearch-1.4.2.deb).  Use this if connection to elasticsearch.org is slow.

###Install Logstash###
    wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb
    dpkg -i logstash_1.4.2-1-2c0f5a1_all.deb
  Logstash 1.4.2-1 debian package available [here](localELK/logstash-1.4.2-1.deb).  Use this if connection to elasticsearch.org is slow.

  Then copy the logstash.conf file available in this project at: [cookbooks/ss_logstash/files/default/logstash.conf](cookbooks/ss_logstash/files/default/logstash.conf) to: /etc/logstash/conf.d/logstash.conf.  When that is done:
  
    service logstash restart

###Install Kibana 3###
    wget https://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz
    tar -xvzf kibana-latest.tar.gz
    cp -R kibana-latest /usr/share/nginx/www/kibana
  Kibana 3 tarball available [here](localELK/kibana-latest.tar.gz).  Use this if connection to elasticsearch.org is slow.

  Then copy the elasticsearch.yml file available in this project at: [cookbooks/ss_kibana/files/default/elasticsearch.yml](cookbooks/ss_kibana/files/default/elasticsearch.yml) to: /etc/elasticsearch/elasticsearch.yml.  When that is done:

    service elasticsearch restart

###Access Web Portal###
    http://server_ip/kibana

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
	

