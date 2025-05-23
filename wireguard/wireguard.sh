apt install wireguard -y

iptables -A INPUT -p udp --dport 51820 -j ACCEPT

wg genkey > /etc/wireguard/private.key
chmod 600 /etc/wireguard/private.key
cat /etc/wireguard/private.key | wg pubkey > /etc/wireguard/public.key

vim /etc/wireguard/wg0.conf


# SERVER

systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
systemctl status wg-quick@wg0.service


# PEER
sudo wg-quick up /etc/wireguard/wg0.conf


# checks
wg show
wg show wg0 latest-handshakes

# DEBUG

# Allow established traffic back in on eth0 → wg0
iptables -A FORWARD -i eth0 -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow new traffic out on wg0 → eth0
iptables -A FORWARD -i wg0 -o eth0 -j ACCEPT

sudo sysctl -w net.ipv4.ip_forward=1
