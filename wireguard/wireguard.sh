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
sudo wg show



