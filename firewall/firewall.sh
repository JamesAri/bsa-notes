# Saving rules: https://askubuntu.com/questions/119393/how-to-save-rules-of-the-iptables

iptables -nvL

apt-get install fail2ban -y

iptables -A INPUT -s  147.228.0.0/16  -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j DROP
# iptables -A INPUT -p tcp --dport 22 -j DROP

iptables -I INPUT -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 8443 -j ACCEPT


apt install iptables-persistent -y

iptables-save > /etc/network/iptables
iptables-restore /etc/network/iptables

# nastaveni po nahozeni interface
/etc/network/interfaces
	post-up /sbin/iptables-restore /etc/network/iptables
