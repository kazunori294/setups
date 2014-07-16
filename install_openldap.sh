yum install -y openldap-servers
yum install -y openldap-clients
cp -f /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf


#lappasswd
#New password: 51SdlQ#A
#Re-enter new password: 
#{SSHA}mEL/uKxDrZeQqyGxfVH3TUhIDnbyOuzp

sed -i '98,101s/^/#/' /etc/openldap/slapd.conf
sed -i '114,117s/^/#/' /etc/openldap/slapd.conf
sed -i '127,134s/^/#/' /etc/openldap/slapd.conf

echo -e '\ndatabase config\nrootdn  "cn=admin,cn=config"\nrootpw  {SSHA}mEL/uKxDrZeQqyGxfVH3TUhIDnbyOuzp' | tee -a /etc/openldap/slapd.conf
echo -e '\ndatabase  bdb\nsuffix    "dc=kazutan,dc=info"\nrootdn    "cn=Manager,dc=kazutan,dc=info"\nrootpw  {SSHA}mEL/uKxDrZeQqyGxfVH3TUhIDnbyOuzp\ndirectory      /var/lib/ldap' | tee -a /etc/openldap/slapd.conf

echo -e '\nindex objectClass                       eq,pres'   | tee -a /etc/openldap/slapd.conf
echo -e 'index ou,cn,mail,surname,givenname      eq,pres,sub' | tee -a /etc/openldap/slapd.conf
echo -e 'index uidNumber,gidNumber,loginShell    eq,pres'     | tee -a /etc/openldap/slapd.conf
echo -e 'index uid,memberUid                     eq,pres,sub' | tee -a /etc/openldap/slapd.conf
echo -e 'index nisMapName,nisMapEntry            eq,pres,sub' | tee -a /etc/openldap/slapd.conf

rm -rf /etc/openldap/slapd.d
mkdir /etc/openldap/slapd.d

cp -f /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d -u

chown -R ldap: /etc/openldap/slapd.d/
chown -R ldap: /var/lib/ldap/

service slapd start
chkconfig slapd on

cat << EOF > /tmp/orig.ldif
dn: dc=kazutan,dc=info
objectClass: dcObject
objectClass: organization
dc: kazutan
o: kazutan

dn: ou=People,dc=kazutan,dc=info
objectClass: organizationalUnit
ou: People

dn: cn=suzuki,ou=People,dc=kazutan,dc=info
objectClass: inetOrgPerson
sn: suzuki
cn: suzuki
mail: suzuki@kazutan.info

dn: cn=tanaka,ou=People,dc=kazutan,dc=info
objectClass: inetOrgPerson
sn: tanaka
cn: tanaka
mail: tanaka@kazutan.info
mail: a.tanaka@kazutan.info
EOF

ldapadd -x -D "cn=Manager,dc=kazutan,dc=info" -w 51SdlQ#A  -f /tmp/orig.ldif
ldapsearch -b dc=kazutan,dc=info -x
