curl -L http://toolbelt.treasuredata.com/sh/install-redhat.sh | sh
/usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-elasticsearch

cp /etc/td-agent/td-agent.con  /etc/td-agent/td-agent.con.bak

cat << EOF  >> /etc/td-agent/td-agent.conf

<source> 
  type tail 
  path /var/log/squid/access.log 
  pos_file /var/log/td-agent/squid-access.log.pos 
  tag kibana.squid.access 
  format /^(?<date>[^ ]+)\s+(?<duration>.*) (?<client address>.*) (?<result code>.*) (?<bytes>.*) (?<request method>.*) (?<url>.*) (?<rfc931>.*) (?<hierarchy code>.*) (?<type>.*)$/ 
  time_format %b %d %H:%M:%S 
</source>


<match kibana.*.*>
  type elasticsearch
  type_name access_log
  host lab-kibana01.kazutan.info
  port 9200
  logstash_format true
  include_tag_key true
  tag_key @log_name
</match>

EOF

chmod -R 777 /var/log/squid

service td-agent restart
chkconfig td-agent on
