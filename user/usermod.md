#### **2. `usermod` Command**

**Purpose:**

* Modifies existing user accounts.
* Controls group memberships, home directories, shell assignments, and more.

**Basic Syntax:**

```bash
usermod [options] username
```

**Common Options:**

| **Option** | **Description**                                                                        |
| ---------- | -------------------------------------------------------------------------------------- |
| **`-aG`**  | Append the user to a supplementary group (must be used with `-G`).                     |
| **`-G`**   | Specify a list of supplementary groups (replaces current group list if `-a` not used). |
| **`-l`**   | Change the username.                                                                   |
| **`-d`**   | Change the user's home directory.                                                      |
| **`-s`**   | Change the user's default shell.                                                       |
| **`-L`**   | Lock the user account.                                                                 |
| **`-U`**   | Unlock the user account.                                                               |
| **`-e`**   | Set the account expiration date.                                                       |
| **`-p`**   | Set a pre-encrypted password (usually avoided for security reasons).                   |

**Examples:**

* Add a user to a group (append without replacing):

```bash
usermod -aG developers alice
```

* Change the username:

```bash
usermod -l newusername oldusername
```

* Change the user's home directory:

```bash
usermod -d /new/home/directory alice
```

* Lock a user account:

```bash
usermod -L alice
```

* Unlock a user account:

```bash
usermod -U alice
```

* Set an account expiration date:

```bash
usermod -e 2025-12-31 alice
```

---

#### **Combining `addgroup` and `usermod` for User Management:**

Typical Workflow:

1. Create a group:

```bash
addgroup developers
```

2. Create a user (if not already created):

```bash
useradd -m -s /bin/bash alice
```

3. Add the user to the new group:

```bash
usermod -aG developers alice
```

4. Verify group membership:

```bash
groups alice
```

---

#### **Key Differences:**

| **Aspect**     | **addgroup**     | **usermod**                                  |
| -------------- | ---------------- | -------------------------------------------- |
| **Purpose**    | Create groups    | Modify user properties                       |
| **Scope**      | Groups only      | Users only                                   |
| **System Use** | Group management | User management, including group memberships |

