### **`useradd` Command in Linux**

**Purpose:**

* Creates a new user account.
* Sets up the user’s home directory, default shell, and other basic settings.

---

#### **Basic Syntax:**

```bash
useradd [options] username
```

---

#### **Common Options:**

| **Option**                    | **Description**                                                                 |
| ----------------------------- | ------------------------------------------------------------------------------- |
| **`-m`**                      | Create the user’s home directory.                                               |
| **`-d [directory]`**          | Specify a custom home directory.                                                |
| **`-s [shell]`**              | Set the user’s default login shell.                                             |
| **`-g [group]`**              | Set the primary group for the user.                                             |
| **`-G [groups]`**             | Add the user to supplementary groups.                                           |
| **`-u [UID]`**                | Specify a unique user ID.                                                       |
| **`-c [comment]`**            | Add a comment (usually the user’s full name).                                   |
| **`-e [YYYY-MM-DD]`**         | Set an account expiration date.                                                 |
| **`-f [days]`**               | Set the number of days after a password expires before the account is disabled. |
| **`-p [encrypted password]`** | Set a pre-encrypted password (not recommended for security reasons).            |
| **`-r`**                      | Create a system account (no login, lower UID).                                  |

---

#### **Examples:**

1. **Create a Basic User (Home Directory and Shell):**

```bash
useradd -m -s /bin/bash alice
```

2. **Create a User with a Custom Home Directory:**

```bash
useradd -m -d /home/developers/bob -s /bin/zsh bob
```

3. **Create a User with a Specific UID and Group:**

```bash
useradd -u 2001 -g developers charlie
```

4. **Create a User with Multiple Groups:**

```bash
useradd -m -G developers,sysadmins dave
```

5. **Create a System User (No Login):**

```bash
useradd -r -s /usr/sbin/nologin webserver
```

6. **Create a User with an Expiration Date:**

```bash
useradd -m -e 2025-12-31 eve
```

7. **Create a User with a Comment (Full Name):**

```bash
useradd -m -c "Frank White" frank
```

---

#### **Post-User Creation Steps:**

* Set a password for the new user:

```bash
passwd alice
```

* Verify the user’s account details:

```bash
id alice
```

* Check the user’s default shell:

```bash
getent passwd alice
```

* Remove a user (including home directory):

```bash
userdel -r alice
```

---

#### **Checking User Configuration:**

* Default settings are typically stored in `/etc/default/useradd` and `/etc/login.defs`.
