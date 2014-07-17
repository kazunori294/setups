yum -y install squid
cp /etc/squid/squid.conf  /etc/squid/squid.conf.bak

sed -i "s/http_port 3128/http_port 8080/g" /etc/squid/squid.conf
echo -e "\nforwarded_for off" | tee -a /etc/squid/squid.conf
echo -e "request_header_access X-Forwarded-For deny all" | tee -a /etc/squid/squid.conf
echo -e "request_header_access Via deny all" | tee -a /etc/squid/squid.conf
echo -e "request_header_access Cache-Control deny all" | tee -a /etc/squid/squid.conf

service squid restart
chkconfig squid on


