# Ansible Setup and Provisioning

This document explains how to use **Ansible** for automated server provisioning in the LexOrbital infrastructure module.

---

## What is Ansible?

Ansible is an automation tool that allows you to provision, configure, and manage servers in a declarative and idempotent way.

**Benefits:**
- ✅ Agentless (only requires SSH and Python)
- ✅ Idempotent (safe to run multiple times)
- ✅ Human-readable YAML syntax
- ✅ No learning curve for basic usage

---

## Prerequisites

- Ansible >= 2.14 installed on your **local machine**
- SSH access to target server(s)
- Python 3 installed on target server(s)
- User with sudo privileges on target server(s)

---

## Installation

### On your local machine (not on the server)

**Debian/Ubuntu:**
```bash
sudo apt update
sudo apt install ansible
```

**macOS:**
```bash
brew install ansible
```

**Verification:**
```bash
ansible --version
# Expected: ansible [core 2.14+]
```

---

## Quick Start

### 1. Configure the inventory

Edit the inventory file to point to your server:

```bash
cd ansible
nano inventories/prod.ini
```

Replace the example values:
```ini
[servers]
lexorbital-prod ansible_host=192.168.1.100 ansible_user=deploy ansible_port=22
```

**Parameters:**
- `ansible_host`: Server IP address or domain name
- `ansible_user`: SSH user (must have sudo privileges)
- `ansible_port`: SSH port (default: 22)

### 2. Test the connection

Verify that you can connect to your server:

```bash
ansible servers -m ping
```

**Expected output:**
```
lexorbital-prod | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 3. Run the provisioning playbook

Execute the main playbook to provision your server:

```bash
ansible-playbook playbooks/site.yml
```

**This playbook performs the following actions:**
- Updates system packages (`apt update && apt upgrade`)
- Installs essential packages (vim, curl, git, ufw, htop, net-tools, python3-pip)
- Configures UFW firewall (enabled, default policy: deny)
- Opens SSH port (22)
- Sets timezone to UTC

**Expected output:**
```
PLAY RECAP *********************************************************************
lexorbital-prod : ok=5    changed=3    unreachable=0    failed=0    skipped=0
```

---

## Useful Commands

### Dry-run (simulation without changes)
```bash
ansible-playbook playbooks/site.yml --check
```

### List all tasks in the playbook
```bash
ansible-playbook playbooks/site.yml --list-tasks
```

### Run only specific tags
```bash
ansible-playbook playbooks/site.yml --tags "firewall"
```

### Target a single server
```bash
ansible-playbook playbooks/site.yml --limit lexorbital-prod
```

### Verbose mode (debugging)
```bash
ansible-playbook playbooks/site.yml -vvv
```

---

## Understanding the Structure

```
ansible/
├── ansible.cfg           # Global Ansible configuration
├── inventories/          # Server inventories
│   └── prod.ini         # Production servers
├── playbooks/           # Playbooks (automation scripts)
│   └── site.yml        # Main playbook
├── roles/              # Reusable roles
│   └── base/           # Base provisioning role
│       ├── tasks/      # Tasks to execute
│       └── vars/       # Variables
└── README.md           # Ansible documentation
```

### Available Roles

#### `base`
Minimal system provisioning:
- System updates
- Essential packages installation
- UFW firewall configuration
- Timezone configuration

**Available tags:** `base`, `updates`, `packages`, `firewall`, `system`

---

## Verification

After provisioning, verify the configuration:

```bash
# Connect to the server
ssh deploy@192.168.1.100

# Check UFW status
sudo ufw status

# Check installed packages
which vim git curl htop

# Check timezone
timedatectl
```

---

## Troubleshooting

### Error: "Permission denied (publickey)"

**Solution:** Ensure your SSH key is added to the server's `~/.ssh/authorized_keys` and that you're using the correct user.

```bash
# Test SSH connection
ssh deploy@192.168.1.100

# If it fails, add your SSH key
ssh-copy-id deploy@192.168.1.100
```

### Error: "sudo: a password is required"

**Solution:** Ensure your user has passwordless sudo access or use `--ask-become-pass`:

```bash
ansible-playbook playbooks/site.yml --ask-become-pass
```

### Error: "Failed to connect to the host via ssh"

**Solution:** Check the inventory parameters (IP, port, user) and firewall rules.

---

## Best Practices

1. **Always test with `--check` first** before applying changes
2. **Use tags** to run specific parts of playbooks
3. **Document your roles** with clear comments
4. **Version control your inventories** but **never commit secrets**
5. **Use ansible-vault** for sensitive data

---

## Next Steps

Future Ansible roles to be added:

- 🔲 `docker` role - Install Docker and Docker Compose
- 🔲 `reverse-proxy` role - Configure Nginx/Caddy
- 🔲 `security-hardening` role - fail2ban, SSH hardening, etc.
- 🔲 `backup` role - Automated backups

---

## Resources

- [Official Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Community roles
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Full Ansible guide](../../ansible/README.md)

---

**Last updated:** 2025-11-30