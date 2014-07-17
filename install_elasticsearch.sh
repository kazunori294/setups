#!/bin/sh

cat << EOF > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-1.0]
name=Elasticsearch repository for 1.0.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.0/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
EOF

yum install -y java
yum install -y java-1.7.0-openjdk
yum install -y elasticsearch

service elasticsearch restart
chkconfig elasticsearch on

yum install -y httpd
cd /tmp
wget https://download.elasticsearch.org/kibana/kibana/kibana-3.0.0milestone4.tar.gz
tar zxvf kibana-3.0.0milestone4.tar.gz
mv kibana-3.0.0milestone4 /var/www/html/kibana

service httpd restart
chkconfig httpd on

curl -X GET http://localhost:9200/

