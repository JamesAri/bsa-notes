apt install -y postfix mailutils

# MAILS
cat /var/log/mail.log

# TESTING
echo "Test" | mail -s "Testovaci mail" jakub@jakub.bsa
echo "Test" | mail -s "Testovaci mail" root
echo "Test" | mail -s "Testovaci mail" root@localhost
echo "Test" | mail -s "Testovaci mail" pavlik

telnet localhost 25
HELO jakub.bsa
MAIL FROM: test1234@jakub.bsa
RCPT TO: root@localhost
DATA
Subject: Testovaci
Ahoj svete
.
QUIT

cat /var/mail/root

# ALLIASES
vim /etc/aliases
## apply changes
newaliases

# POSTFIX CONFIGURATION
cat >> /etc/postfix/main.cf << 'EOF'
home_mailbox = Maildir/
mailbox_command =
EOF

mkdir /root/Maildir

TMP_USER=pavlik
mkdir /home/$TMP_USER/Maildir
chown -R $TMP_USER:$TMP_USER /home/$TMP_USER/Maildir

systemctl restart postfix

# MUTT FOR MAIL READING
apt-get install mutt

mutt -f /home/$TMP_USER/Maildir
mutt -f /var/spool/mail/root

apt install mutt -y
soubor .muttrc
set folder        = imap://jakub:test123@bsa1.jakub.bsa:143
set spoolfile     = imap://jakub:test123@bsa1.jakub.bsa:143
set smtp_url      = smtp://jakub:test123@bsa1.jakub.bsa:25
set ----------    = smtp://<user>:<pwsd>@bsa1.jakub.bsa:25




# DOVECOT

apt-get install dovecot-pop3d -y

vim /etc/dovecot/conf.d/10-mail.conf
# uncomment
mail_location = maildir:~/Maildir

vim /etc/postfix/main.cf
virtual_alias_domains = hash:/etc/postfix/virtual_domains
virtual_alias_maps = hash:/etc/postfix/virtual

vim /etc/postfix/virtual_domains
jakub2.bsa	OK
jakub3.bsa	OK

vim /etc/postfix/virtual
info@jakub2.bsa	root
info@jakub3.bsa	pepa

postmap /etc/postfix/virtual_domains
postmap /etc/postfix/virtual
systemctl restart postfix dovecot

# checks
postmap -q info@jakub2.bsa hash:/etc/postfix/virtual
postconf virtual_alias_domains

# SPF
# check, ze bezi service
netstat -anp | grep private/policyd-spf

vim /var/cache/bind/db.jakub.bsa
@      IN TXT     "v=spf1 mx a ip4:<IP>/32 ~all"

rndc reload
rndc sign jakub.bsa

# check
dig -4 jakub.bsa TXT @localhost

# vynuceni SPF pri prijmu mailu
apt-get install postfix-policyd-spf-python

vim /etc/postfix/master.cf
policyd-spf  unix  -       n       n       -       0       spawn
    user=policyd-spf argv=/usr/bin/policyd-spf
# policyd-spf unix    -       n       n       -       -      spawn
#   user=vmail argv=/usr/bin/policyd-spf

vim /etc/postfix/main.cf
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination check_policy_service unix:private/policyd-spf

# check
apt-get install netcat -y
nc -U /var/spool/postfix/private/policyd-spf


echo "Test" | mail -s "Testovaci mail" root
vim /var/mail/root #

nc -U /var/spool/postfix/private/policyd-spf
request=smtpd_access_policy
protocol_state=RCPT
protocol_name=SMTP
helo_name=fake.example.com
queue_id=ABC12345
sender=someone@jakub.bsa
recipient=test@jakub.bsa
client_address=127.0.0.1
client_name=localhost
[empty line]

# nebo

nc -U /var/spool/postfix/private/policyd-spf
request=smtpd_access_policy
protocol_state=RCPT
protocol_name=SMTP
helo_name=h****forge.com
queue_id=8045F2AB23
sender=
recipient=falko.timme@*******.de
client_address=1.2.3.4
client_name=www.example.com
[empty line]

