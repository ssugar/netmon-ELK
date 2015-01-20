#senseHCMC-ELK#

##Description##
Vagrantfile and Chef recipes to deploy the ELK stack [Elasticsearch, Logstash, and Kibana](http://www.elasticsearch.org/overview/) for use in the senseHCMC project.

===================================
##Setup without Vagrant##
If not using Vagrant and Chef, run the following commands on a fresh debian/ubuntu install after logging in as root to mimic the same behaviour:

###Prepare Apt###
  We will be setting apt to use a mirror located in Vietnam.
  
  Example 1 - Debian Wheezy
  -------------------------
  
    echo "deb http://mirror.debian.vn/debian/ wheezy main restricted universe" > /etc/apt/sources.list
    echo "deb http://mirror.debian.vn/debian/ wheezy-updates main restricted universe" >> /etc/apt/sources.list
    echo "deb http://mirror.debian.vn/debian/ wheezy-security main restricted universe" >> /etc/apt/sources.list
	
  Example 2 - Ubuntu Precise Pangolin
  -----------------------------------

    echo "deb http://mirror-fpt-telecom.fpt.net/ubuntu/ precise main restricted universe" > /etc/apt/sources.list
    echo "deb http://mirror-fpt-telecom.fpt.net/ubuntu/ precise-updates main restricted universe" >> /etc/apt/sources.list
    echo "deb http://mirror-fpt-telecom.fpt.net/ubuntu/ precise-security main restricted universe" >> /etc/apt/sources.list
  
  Update apt after changing sources
  
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
===================================
##Testing##
###sendData.py script###
  This will send a json formatted string over UDP with six random data points, one for each of the six testing sensors, into Logstash.  Cron job below will run this script once every minute.

  Copy the sendData.py file available in this project at: [testing/sendData.py](testing/sendData.py) to the server, then create a cronjob replacing /path/to/sendData.py with your path:
 
    crontab -l | { cat; echo "* * * * * python /path/to/sendData.py"; } | crontab -   
  This testing script could be be easily modified to run from a different machine, use a different port, or even a different protocol.

###Basic 6 Sensor Kibana Dashboard###
  This will set a basic 6 sensor dashboard as the default dasboard in Kibana.  This dashboard was based off of data created by the testing script above, so it will require changes when the sensor names are chosen.

  Copy the senseHCMCDashboard.json file available in this project at: 
  [cookbooks/ss_kibana/files/default/senseHCMCDashboard.json](cookbooks/ss_kibana/files/default/senseHCMCDashboard.json) 
  to: 
  /usr/share/nginx/www/kibana/app/dashboards/default.json

