apt update && sudo apt install rsyslog

sudo systemctl start rsyslog
sudo systemctl enable rsyslog
sudo systemctl status rsyslog

vim /etc/rsyslog.conf

# /module(load="imudp")
# input(type="imudp" port="514")

# module(load="imtcp")
# input(type="imtcp" port="514")

iptables -I INPUT -j ACCEPT -p udp --dport 514
iptables -I INPUT -j ACCEPT -p tcp --dport 514

vim /etc/rsyslog.d/10-remote.conf

# =======

$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs

# rozdeleni logu do adresaru
$template HourlyMailLog,"/var/log/logdir/%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%_mail.log

# formatovani logu
$template SyslFormat,"%timegenerated% %HOSTNAME%  %syslogtag%%msg:::space$

# zapis logu do souboru dle definice a formatu
mail.*                                                  -?HourlyMailLog;SyslFormat

# =======

sudo mkdir -p /var/log/remote
sudo chown syslog:adm /var/log/remote
sudo systemctl restart rsyslog

# CLIENT

vim /etc/rsyslog.conf
# ================
*.* @192.168.1.100:514   # Use @@ for TCP, @ UDP
# ================
sudo systemctl restart rsyslog

# checks
logger "Test message from client"
sudo find /var/log/remote -type f
sudo tail -f /var/log/remote/*/*.log

