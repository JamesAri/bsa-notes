apt install -y stunnel4

STUNNEL_CERT_NAME=private.slechta.bsa

./easyrsa gen-req $STUNNEL_CERT_NAME nopass
./easyrsa sign server $STUNNEL_CERT_NAME

cat /etc/ca/pki/issued/$STUNNEL_CERT_NAME.crt /etc/ca/pki/private/$STUNNEL_CERT_NAME.key > /etc/stunnel/stunnel.slechta.bsa.pem

chmod 600 /etc/stunnel/stunnel.slechta.bsa.pem
chown root:root /etc/stunnel/stunnel.slechta.bsa.pem

echo "
pid = /var/run/stunnel.pid
[https]
accept = 8443
connect = 80
cert = /etc/stunnel/stunnel.slechta.bsa.pem
" > /etc/stunnel/stunnel.conf

systemctl enable stunnel4
systemctl restart stunnel4

iptables -I INPUT -p tcp --dport 8443 -j ACCEPT

# checks
curl -kv https://localhost:8443
