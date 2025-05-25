vim /etc/resolv.conf
vim /etc/hosts

# KNOT
apt install knot knot-dnsutils -y
knotc reload

mkdir -p /var/lib/knot/master
mkdir -p /var/lib/knot/signed
chown -R knot:knot /var/lib/knot

vim /etc/knot/knot.conf
vim /var/lib/knot/master/knot.jakub.bsa.zone # db.jakub.bsa
vim /var/lib/knot/signed/knot.jakub-secured.bsa.zone # db.jakub.bsa
knotc reload

# checks
dig knot.jakub-secured.bsa +dnssec @127.0.0.1 -t ANY

# BIND
cd /etc/bind/
apt-get install bind9 dnsutils -y
# service bind9 start|stop|restart

cd /etc/bind/
vim /etc/bind/named.conf.options

cd /var/cache/bind
vim /var/cache/bind/db.jakub.bsa

chown bind:bind /var/cache/bind/db.jakub.bsa

mkdir /etc/bind/keys
cd /etc/bind/keys
dnssec-keygen -a ECDSAP256SHA256 -fK jakub.bsa
chmod g+r K*.private
systemctl restart bind9
rndc sign jakub.bsa
rndc signing -list jakub.bsa

iptables -I INPUT -j ACCEPT -p udp --dport 53
iptables -I INPUT -j ACCEPT -p tcp --dport 53
iptables -I INPUT -j ACCEPT -p tcp --dport 953
iptables -I INPUT -j ACCEPT -p udp --dport 953

# checks
dig @localhost mail.jakub.bsa. A
dig -4 @localhost -t ANY jakub.bsa
named-checkzone jakub.bsa /var/cache/bind/db.jakub.bsa # check zone file
dig @localhost -t TXT .jakub.bsa. +short

rndc signing -list jakub.bsa

# chekcs if views
rndc signing -list jakub.bsa IN localnetwork
named-compilezone -f raw -j -o - jakub.bsa /var/cache/bind/jakub.bsa
