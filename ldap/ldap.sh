# https://documentation.ubuntu.com/server/how-to/openldap/install-openldap/index.html
apt install slapd ldap-utils ldapscripts -y
dpkg-reconfigure -plow slapd

apt install libnss-ldap libpam-ldap -y

scp ldap/ldif/create_ou.ldif testy:/tmp/create_ou.ldif
scp ldap/ldif/create_ou2.ldif testy:/tmp/create_ou2.ldif
scp ldap/ldif/create_user.ldif testy:/tmp/create_user.ldif
scp ldap/ldif/modify_user.ldif testy:/tmp/modify_user.ldif
scp ldap/ldif/create_group.ldif testy:/tmp/create_group.ldif

# generate password
slappasswd -h {SSHA}

DOMAIN_TEST="dc=zcu,dc=cz"
DOMAIN="cn=admin,dc=zcu,dc=cz"

# setup
ldapadd -f /tmp/create_ou.ldif -D ${DOMAIN} -w 1234
ldapadd -f /tmp/create_ou2.ldif -D ${DOMAIN} -w 1234
ldapadd -f /tmp/create_user.ldif -D ${DOMAIN} -w 1234
ldapadd -f /tmp/create_group.ldif -D ${DOMAIN} -w 1234
ldapmodify -f /tmp/modify_user.ldif -D ${DOMAIN} -w 1234

# checks
ldapsearch -x -H ldap://localhost -b ${DOMAIN_TEST}
slapcat | less
ldapsearch -x -LLL -H ldap://localhost -D ${DOMAIN} -w 1234 -b ${DOMAIN_TEST} "(uid=pepa2)"

vim /etc/nsswitch.conf
# -> ridat ldap na konec:
# passwd:         ... ldap
# group:          ... ldap
# shadow:         ... ldap
# gshadow:        ... ldap

# check
getent passwd

vim /usr/share/pam-configs/mkhomedir
# Name: Create home directory during login
# Default: yes
# Priority: 900
# Session-Type: Additional
# Session:
#         required        pam_mkhomedir.so umask=0022 skel=/etc/skel

pam-auth-update

# Enable ssh login (change admins and pepa2 to your group and user)
sed -i 's/PasswordAuthentication .*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
cp -r /root/.ssh /home/ldap/pepa2
chown -R pepa2:admins /home/ldap/pepa2/.ssh

