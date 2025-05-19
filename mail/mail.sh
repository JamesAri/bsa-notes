apt install -y postfix
apt install mailutils -y

cat /var/log/mail.log

# ==== test mail ====
echo "Test" | mail -s "Testovaci mail" jakub@jakub.bsa

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
# ==== test mail ====

vim /etc/aliases


############################
apt-get install mutt

@      IN TXT     "v=spf1 mx a ip4:147.228.173.174/32 ~all"
