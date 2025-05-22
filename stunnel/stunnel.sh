apt install -y stunnel4

STUNNEL_CERT_NAME=private.slechta.bsa

./easyrsa gen-req $STUNNEL_CERT_NAME nopass
./easyrsa sign server $STUNNEL_CERT_NAME

cd /etc/ca
cat pki/issued/$STUNNEL_CERT_NAME.crt pki/private/$STUNNEL_CERT_NAME.key > /etc/stunnel/stunnel.slechta.bsa.pem

sudo chmod 600 /etc/stunnel/stunnel.slechta.bsa.pem
sudo chown root:root /etc/stunnel/stunnel.slechta.bsa.pem

echo "
pid = /var/run/stunnel.pid
[https]
accept = 8443
connect = 80
cert = /etc/stunnel/stunnel.slechta.bsa.pem
" > /etc/stunnel/stunnel.conf

systemctl enable stunnel4
systemctl restart stunnel4

iptables -A INPUT -p tcp --dport 8443 -j ACCEPT

# checks
curl -kv https://localhost:8443
