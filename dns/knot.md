## Knot

```
apt install -y apt-transport-https lsb-release ca-certificates wget
wget -O /etc/apt/trusted.gpg.d/knot-latest.gpg https://deb.knot-dns.cz/knot-latest/apt.gpg
echo "deb https://deb.knot-dns.cz/knot-latest/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/knot-latest.list
apt update

apt install -y knot knot-dnsutils
knotc reload
```

### Konfigurace

[reference](https://www.knot-dns.cz/docs/2.6/html/configuration.html)

```
template:
  - id: default
    storage: /var/lib/knot/master
    semantic-checks: on

  - id: signed
    storage: /var/lib/knot/signed
    dnssec-signing: on
    semantic-checks: on

  - id: slave
    storage: /var/lib/knot/slave

policy:
  - id: rsa
    algorithm: RSASHA256
    ksk-size: 2048
    zsk-size: 1024

zone:
  - domain: jindra.bsa

  - domain: jindra-secured.bsa
    template: signed
    dnssec-policy: rsa

```


systemctl restart knot
knotc reload
chown knot:knot -R signed/

dig imap.jindra.bsa @localhost
dig -t TXT txt.jindra.bsa @localhost
