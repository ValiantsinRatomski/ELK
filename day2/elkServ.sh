#!/bin/bash

sudo su
yum install java-11-openjdk-devel -y
yum install wget -y
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

#----------------------------------------------------------------------

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.1-x86_64.rpm
rpm --install elasticsearch-7.9.1-x86_64.rpm

systemctl start elasticsearch.service

#----------------------------------------------------------------------
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/kibana.repo << EOT
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOT

yum install kibana -y
#echo -e '\nserver.port: 5601\nserver.host: "0.0.0.0"\nelasticsearch.hosts: ["http://localhost:9200"]' >> /etc/kibana/kibana.yml
echo 'server.host: "0.0.0.0"' >> /etc/kibana/kibana.yml

systemctl start kibana

#----ELASTICSEARCH------
#echo -e '\nhttp.port: 9200\nnetwork.host: 0.0.0.0\ntransport.host: localhost\ndiscovery.seed_hosts: ["0.0.0.0"]' >> /etc/elasticsearch/elasticsearch.yml
echo -e 'network.host: 0.0.0.0\ndiscovery.seed_hosts: ["0.0.0.0"]' >> /etc/elasticsearch/elasticsearch.yml

systemctl restart elasticsearch.service