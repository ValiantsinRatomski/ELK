#!/bin/bash

sudo su
yum install java-11-openjdk-devel -y
yum install wget -y
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/logstash.repo << EOT
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOT


yum install logstash -y
/usr/share/logstash/bin/system-install

cat > /etc/logstash/conf.d/ls_tomcat.conf <<EOT
input {
  file {
    path => "/var/log/tomcat/*"
    start_position => "beginning"
  }
}

output {
  elasticsearch {
    hosts => ["${es_ip}:9200"]
  }
  stdout { codec => rubydebug }
}
EOT



#----------------------------------------------------------------------------

sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y
sudo systemctl start tomcat
sudo systemctl enable tomcat

chmod 777 /var/log/tomcat
chmod 777 /var/log/tomcat/*

systemctl start logstash