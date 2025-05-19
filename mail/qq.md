### **SPF, DKIM, and DMARC for Postfix**

To secure your email server and improve your domain's reputation, you should implement **SPF (Sender Policy Framework)**, **DKIM (DomainKeys Identified Mail)**, and **DMARC (Domain-based Message Authentication, Reporting, and Conformance)**. These mechanisms work together to prevent spoofing, phishing, and spam.

---

#### **1. SPF (Sender Policy Framework)**

**Purpose:** Prevents spammers from sending unauthorized emails claiming to be from your domain.

**SPF Record Format:** **TXT** DNS record.

**Example SPF Record:**

```plaintext
v=spf1 ip4:147.228.67.42 include:_spf.google.com -all
```

**Breakdown:**

* **v=spf1** - Indicates the SPF version.
* **ip4:147.228.67.42** - Authorizes this IP to send mail for your domain.
* **include:\_spf.google.com** - Authorizes Google's servers as valid senders.
* **-all** - Hard fail for any server not explicitly listed.

**Adding the Record:**

* **BIND Zone File:**

  ```plaintext
  @ IN TXT "v=spf1 ip4:147.228.67.42 -all"
  ```

* **Postfix Configuration (optional):**
  Use **postscreen** or **policyd-spf** to enforce SPF checks.

  ```bash
  sudo apt install postfix-policyd-spf-python
  ```

* Add to **main.cf**:

  ```plaintext
  policyd-spf_time_limit = 3600
  smtpd_recipient_restrictions =
      permit_mynetworks,
      permit_sasl_authenticated,
      reject_unauth_destination,
      check_policy_service unix:private/policyd-spf
  ```

* Reload Postfix:

  ```bash
  sudo systemctl restart postfix
  ```

---

#### **2. DKIM (DomainKeys Identified Mail)**

**Purpose:** Digitally signs outgoing messages to verify their authenticity.

**Install DKIM Tools:**

```bash
sudo apt install opendkim opendkim-tools
```

**Configure OpenDKIM:**

* **Edit /etc/opendkim.conf:**

  ```plaintext
  AutoRestart             Yes
  AutoRestartRate         10/1h
  Umask                   002
  Syslog                  yes
  LogWhy                  yes
  Domain                  example.com
  KeyFile                 /etc/dkim/keys/example.com/default.private
  Selector               default
  Socket                 inet:12345@localhost
  PidFile                /var/run/opendkim/opendkim.pid
  UserID                 opendkim:opendkim
  Mode                   sv
  OversignHeaders        From
  ```

* **Generate DKIM Keys:**

  ```bash
  sudo mkdir -p /etc/dkim/keys/example.com
  sudo opendkim-genkey -D /etc/dkim/keys/example.com/ -d example.com -s default
  sudo chown -R opendkim:opendkim /etc/dkim/keys/example.com/
  sudo chmod 600 /etc/dkim/keys/example.com/default.private
  ```

* **Add the public key to DNS:**
  Copy the contents of **default.txt** and add it to your **BIND** zone file as a **TXT** record:

  ```plaintext
  default._domainkey IN TXT "v=DKIM1; k=rsa; p=MIIBIjANBgkqh..."
  ```

* **Link OpenDKIM to Postfix:**

  **/etc/postfix/main.cf**

  ```plaintext
  milter_default_action = accept
  smtpd_milters = inet:localhost:12345
  non_smtpd_milters = inet:localhost:12345
  ```

* **Restart Services:**

  ```bash
  sudo systemctl restart opendkim
  sudo systemctl restart postfix
  ```

---

#### **3. DMARC (Domain-based Message Authentication, Reporting, and Conformance)**

**Purpose:** Provides reporting and strict enforcement of SPF and DKIM policies.

**Example DMARC Record:**

```plaintext
_dmarc.example.com. IN TXT "v=DMARC1; p=quarantine; rua=mailto:dmarc-reports@example.com; ruf=mailto:dmarc-reports@example.com; sp=reject; fo=1"
```

**Breakdown:**

* **v=DMARC1** - Specifies the DMARC version.
* **p=quarantine** - How to handle failed messages (**none**, **quarantine**, or **reject**).
* **rua** - Aggregate report address.
* **ruf** - Forensic report address.
* **sp=reject** - Subdomain policy (reject messages from subdomains if they fail DMARC).
* **fo=1** - Generate reports for all failures.

**Add the Record:**

* **BIND Zone File:**

  ```plaintext
  _dmarc IN TXT "v=DMARC1; p=quarantine; rua=mailto:dmarc-reports@example.com; sp=reject; fo=1"
  ```

---

### **4. Verify Your Setup**

* **SPF Check:**

  ```bash
  dig TXT example.com +short
  ```

* **DKIM Check:**

  ```bash
  dig TXT default._domainkey.example.com +short
  ```

* **DMARC Check:**

  ```bash
  dig TXT _dmarc.example.com +short
  ```

---

### **5. Testing and Validation**

Use online tools like:

* **DKIM Core:** [dkimcore.org](https://dkimcore.org/tools/)
* **Mail Tester:** [mail-tester.com](https://www.mail-tester.com/)
* **Google Postmaster Tools** for ongoing monitoring.

---

Would you like me to guide you on setting up DMARC reports and tuning these settings for optimal security?
