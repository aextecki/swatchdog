# Swatchdog: Intelligent Process Monitoring & Service Recovery Agent

A lightweight, user-friendly Bash automation tool designed to monitor system processes and execute self-healing workflows when critical services crash. 

Built with an intelligent translation layer, it bridges the gap between human-readable application nicknames and complex background system realities (`systemd` unit names vs. process table binaries), making it fully accessible to junior administrators and DevOps teams alike.

---

## 🚀 Key Features

- **Autonomous Self-Healing:** Detects dead processes and automatically handles `systemctl` state-resets, service enabling, and forced restarts.
- **Intelligent Translation Layer:** Uses a `case`-driven switchboard to map friendly names (`ssh`, `web`, `database`) to their exact process strings (`sshd`, `apache2`, `mariadbd`) and systemd tracking units automatically.
- **Robust Error Handling:** Validates inputs, converts variables to lowercase for safety, and implements multi-stage validation to confirm successful recovery before exiting.
- **Vim-Optimized Workflow:** Designed to be highly modular, portable, and testable directly via standard shell execution pipelines.

---

## 🛠️ Monitored Environments & Architecture

The script handles the native operational quirks of major enterprise daemons automatically:

| Friendly Input | Monitored Process (`pgrep`) | Systemd Unit (`systemctl`) | Target Service |
| :--- | :--- | :--- | :--- |
| `ssh` / `sshd` | `sshd` | `ssh` | Secure Shell Daemon |
| `web` / `apache` | `apache2` | `apache2` | Apache HTTP Server |
| `database` / `mysql` | `mariadbd` | `mariadb` | MariaDB / MySQL Engine |

---

## 📦 Installation & Setup

Clone the repository and assign execution permissions to your local environment:

```bash
# Clone this repository
git clone https://github.com/aextecki/swatchdog.git

# Enter the directory
cd swatchdog

# Grant executable permission to the script
chmod +x swatchdog.sh

# Run the script by passing a supported friendly service nickname as a single command-line argument:
./swatchdog.sh <service_nickname>

# Example
# Check and recover SSH services
./swatchdog.sh ssh

# Check and recover Apache Web Server
./swatchdog.sh web

#Sample output
$ ./swatchdog.sh ssh
Checking the status of: Secure Shell (SSH)...
OK: Secure Shell (SSH) is running perfectly.

#When the services is going to restart or restored
$ ./swatchdog.sh ssh
Checking the status of: Secure Shell (SSH)...
ALERT: Secure Shell (SSH) process is dead or missing!
Initiating Intelligent Service Recovery...
-> Enabling system service (ssh)...
-> Resetting failed service counters...
-> Executing: sudo systemctl restart ssh
RECOVERY SUCCESSFUL: Secure Shell (SSH) has been safely restored online!
