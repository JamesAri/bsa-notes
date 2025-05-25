apt update && apt install rsyslog -y

systemctl start rsyslog
systemctl enable rsyslog
systemctl status rsyslog

vim /etc/rsyslog.conf

# /module(load="imudp")
# input(type="imudp" port="514")

# module(load="imtcp")
# input(type="imtcp" port="514")

iptables -I INPUT -j ACCEPT -p udp --dport 514
iptables -I INPUT -j ACCEPT -p tcp --dport 514

vim /etc/rsyslog.d/10-remote.conf

# =================================================

$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log" *.* ?RemoteLogs
$template HourlyMailLog,"/var/log/logdir/%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%_mail.log
$template SyslFormat,"%timegenerated% %HOSTNAME%  %syslogtag%%msg:::space$

# zapis logu do souboru dle definice a formatu
mail.*                                                  -?HourlyMailLog;SyslFormat

# ================== LOG DIR REMOTE =========================

mkdir -p /var/log/errors
# chown syslog:adm /var/log/remote
chown syslog:adm /var/log/errors
systemctl restart rsyslog

# CLIENT

vim /etc/rsyslog.conf
# ================
*.* @192.168.1.100:514   # Use @@ for TCP, @ UDP
# ================
systemctl restart rsyslog

# checks
logger "Test message from client"
find /var/log/remote -type f
tail -f /var/log/remote/*/*.log

# template(name="RemoteLogs" type="string" string="/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log")
# action(type="omfile" dynaFile="RemoteLogs" createDirs="on" DirCreateMode="0755" sync="off")

# ============ APACHE LOGGING ============

# == Legacy rsyslog syntax ==

# /etc/rsyslog.d/apache.conf
local6.err      /var/log/apache/httpd-error.log
local6.notice   /var/log/apache/httpd-access.log
# nebo na remote
local6.*        @192.168.1.100:514

# == RainerScript syntax ==
# /etc/rsyslog.d/apache.conf
if $syslogfacility-text == 'local6' and $programname == 'httpd' and ($syslogseverity-text == 'err' or $syslogseverity-text == 'notice') then /var/log/rsyslog-apache-log.log
& stop

# /etc/apache2/apache2.conf
errorlog  "|/usr/bin/tee -a /var/log/www/error.log  | /usr/bin/logger -t httpd -p local6.err"
customlog "|/usr/bin/tee -a /var/log/www/access.log | /usr/bin/logger -t httpd -p local6.notice" extended_ncsa

# module(load="imudp")    # pokud přijímáš UDP logy
# module(load="imtcp")    # pokud přijímáš TCP logy

# ====== LOGGING ======

# RainerScript syntax
# 'error'
# 'critical'
# 'warning'
# 'information'

# Legacy rsyslog syntax
# emerg
# alert
# crit
# err
# warning
# notice
# info
# debug

cat > /etc/rsyslog.d/50-error-logs.conf << 'EOF'
template(name="ErrorLogPath" type="string" string="/var/log/errors/%$YEAR%/%$MONTH%/%$DAY%/errors.log")
if $syslogseverity-text == 'error' then {
    action(type="omfile" dynaFile="ErrorLogPath" createDirs="on" DirCreateMode="0755" sync="off")
    stop
}
EOF
systemctl restart rsyslog
logger -p user.error "This is a test error message"
cd /var/log/errors

# mkdir -p /var/log/errors
# chown root:adm /var/log/errors

