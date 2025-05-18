### **`ldapadd` Command in Linux**

**Purpose:**

* Adds entries to an LDAP (Lightweight Directory Access Protocol) directory.
* Typically used to populate or extend the LDAP directory with new organizational units, groups, or user accounts.

---

#### **Basic Syntax:**

```bash
ldapadd [options] -x -D "bind_dn" -W -f filename.ldif
```

---

#### **Common Options:**

| **Option**               | **Description**                                       |
| ------------------------ | ----------------------------------------------------- |
| **`-x`**                 | Use simple authentication (instead of SASL).          |
| **`-D "bind_dn"`**       | Specify the distinguished name (DN) to bind as.       |
| **`-W`**                 | Prompt for the bind password (more secure than `-w`). |
| **`-H ldap://hostname`** | Specify the LDAP server URI.                          |
| **`-f filename.ldif`**   | Specify the LDIF file to import.                      |
| **`-c`**                 | Continue on errors (don’t stop on the first failure). |
| **`-S log_file`**        | Log rejected entries to a specified file.             |

---

#### **Basic Workflow:**

1. **Prepare the LDIF File:**

   * This file contains the LDAP entries you want to add, written in the LDIF (LDAP Data Interchange Format) syntax.
   * Example `users.ldif`:

   ```ldif
   dn: uid=jdoe,ou=users,dc=example,dc=com
   objectClass: inetOrgPerson
   uid: jdoe
   cn: John Doe
   sn: Doe
   givenName: John
   mail: jdoe@example.com
   userPassword: secret123
   ```

2. **Run the `ldapadd` Command:**

   * Using a simple bind:

   ```bash
   ldapadd -x -D "cn=admin,dc=example,dc=com" -W -f users.ldif
   ```

   * Using a specific LDAP server:

   ```bash
   ldapadd -x -D "cn=admin,dc=example,dc=com" -W -H ldap://ldap.example.com -f users.ldif
   ```

3. **Verify the Entry:**

   * Confirm the entry was added:

   ```bash
   ldapsearch -x -b "dc=example,dc=com" "(uid=jdoe)"
   ```

---

#### **Common Use Cases:**

* **Adding a Single User:**

```ldif
dn: uid=alice,ou=users,dc=example,dc=com
objectClass: inetOrgPerson
uid: alice
cn: Alice Smith
sn: Smith
givenName: Alice
mail: alice@example.com
userPassword: password123
```

* **Adding a Group:**

```ldif
dn: cn=developers,ou=groups,dc=example,dc=com
objectClass: posixGroup
cn: developers
gidNumber: 1001
memberUid: alice
memberUid: bob
```

* **Adding an Organizational Unit (OU):**

```ldif
dn: ou=users,dc=example,dc=com
objectClass: organizationalUnit
ou: users
```

---

#### **Key Considerations:**

* Make sure the `bind_dn` has the necessary permissions to add entries.
* Passwords in LDIF files should be hashed (e.g., using SSHA) for security.
* Test your LDIF file syntax before adding large datasets.

---

#### **Troubleshooting:**

* **Permission Denied:**
  Ensure the bind user has write access to the directory.

* **Invalid DN Syntax:**
  Check for spacing or formatting issues in your LDIF file.

* **Connection Refused:**
  Make sure the LDAP server is running and reachable.
