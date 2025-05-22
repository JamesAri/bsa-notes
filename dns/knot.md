mkdir -p /var/lib/knot/master
mkdir -p /var/lib/knot/signed
chown -R knot:knot /var/lib/knot
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



---


Here’s a simple example of a Knot DNS server zone defined in **knot.conf**, featuring DNSSEC signing and basic zone parameters:

```conf
# Global server options
server:
    listen: 0.0.0.0@53
    identity: "ns1.example.com"
    version: off
    edns-udp-size: 1232
    zonefile-check: yes

# Logging
log:
    - target: syslog
      any: error
      authservfail: yes

# Define the zone
zone:
    - domain: example.com
      file: /var/lib/knot/zones/example.com.zone
      # Enable DNSSEC automatic signing
      dnssec:
        - signer: local
          key-directory: /var/lib/knot/keys/example.com
          ds-replacement: yes
      # Notify secondaries automatically
      notify:
        - 192.0.2.10  # secondary server IP
      # Allow zone transfers only to listed IPs
      allow-transfer:
        - 192.0.2.10
      # Refresh/Retry/Expire/Min TTL (SOA defaults override if omitted)
      soa-edit: both
      soa-edit-slp: true
      soa-minimum: 3600

# Include other config snippets if needed
include: "/etc/knot/acl.conf"
```

And here’s what the corresponding **zone file** `/var/lib/knot/zones/example.com.zone` might look like:

```dns
$TTL 3600
@   IN  SOA ns1.example.com. hostmaster.example.com. (
        2025052201 ; serial YYYYMMDDnn
        3600       ; refresh (1h)
        900        ; retry   (15m)
        604800     ; expire (1w)
        3600       ; minimum TTL (1h)
)
    IN  NS   ns1.example.com.
    IN  NS   ns2.example.com.

ns1 IN  A    198.51.100.1
ns2 IN  A    198.51.100.2

@   IN  A    198.51.100.10
www IN  A    198.51.100.10
mail IN  A    198.51.100.20
    IN  MX   10 mail.example.com.

; Example of an NSEC3 chain for authenticated denial
; (Generated and managed automatically by Knot when DNSSEC is on)
```

### Explanation of key parts

* **zone: domain / file**
  Declares the zone name and the path to its zone file.
* **dnssec: signer / key-directory**
  Enables automatic DNSSEC signing of this zone, storing keys under the given directory.
* **ds-replacement: yes**
  When keys roll over, Knot will automatically update the DS record in the parent zone (if supported via an API).
* **notify / allow-transfer**
  Controls which secondaries are notified and allowed to AXFR the zone.
* **soa-edit / soa-edit-slp**
  Adjust how Knot updates the SOA record on zone changes (e.g. serial increment policy).

You can adjust time-related parameters, ACLs, logging, and other options as needed for your environment.
