#!/bin/sh

yum install -y httpd
yum install -y php
yum install -y php-mbstring
yum install -y unzip
cd /tmp
wget http://iij.dl.sourceforge.jp/pukiwiki/61634/pukiwiki-1_5_0_eucjp.zip
unzip pukiwiki-1_5_0_eucjp.zip
echo -n passw0rd | md5sum | awk '{print $1}'


bed128365216c019988915ed3add75fb
