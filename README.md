# LexOrbital Module Server

> **Production-ready server infrastructure module** with integrated security and GDPR compliance for the LexOrbital ecosystem.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Ansible](https://img.shields.io/badge/Ansible-2.14+-green)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/Docker-20.10+-blue)](https://www.docker.com/)
[![Documentation](https://img.shields.io/badge/docs-complete-brightgreen)](./docs)

---

## 🎯 What is This?

A **proven and reusable infrastructure module** providing:

- **Automated provisioning** (Ansible)
- **Security hardening** (OWASP, ANSSI standards)
- **GDPR compliance** built-in (pseudonymization, retention policies)
- **Production deployment** (Docker Compose/Swarm)
- **Disaster recovery** (DRP, backups, restore testing)

**Ideal for:** Startups and scale-ups needing compliant and secure infrastructure without reinventing the wheel.

---

## 🚀 Quick Start

### Prerequisites

- Debian 11+ or Ubuntu 20.04+
- Ansible 2.14+ (on your local machine)
- SSH access to target server

### Installation in 3 Steps

```bash
# 1. Clone the repository
git clone https://github.com/YohanGH/lexorbital-module-server
cd lexorbital-module-server

# 2. Configure Ansible inventory
cd ansible
nano inventories/prod.ini

# 3. Run provisioning
ansible-playbook playbooks/site.yml
```

**Deployment time:** 2-4 hours for a production-ready server.

---

## 🏛️ Architecture

### LexOrbital Orbital Architecture

- **Meta-Kernel:** Central orchestration ([lexorbital-core](https://github.com/YohanGH/lexorbital-core))
- **Ring 1:** UI modules ([lexorbital-module-ui-kit](https://github.com/YohanGH/lexorbital-module-ui-kit))
- **Ring 2:** Infrastructure modules (← **you are here**)
- **Ring 3:** Application modules

This module is part of **Ring 2** and provides secure and compliant server infrastructure for the entire ecosystem.

### Tech Stack

- **Orchestration:** Docker Compose / Swarm
- **Provisioning:** Ansible
- **Reverse Proxy:** Nginx
- **Certificates:** Let's Encrypt (Certbot)
- **Firewall:** UFW
- **Logging:** journald with automatic rotation

---

## 🔒 Compliance First

✅ **GDPR-ready:** IP pseudonymization, retention policies (30 days), privacy by design  
✅ **Security standards:** OWASP Top 10, ANSSI recommendations  
✅ **Audit trail:** Complete logging with automatic rotation  
✅ **Network isolation:** Frontend/backend/database separation  
✅ **TLS 1.2+:** HSTS, security headers (CSP, X-Frame-Options)

---

## 📚 Documentation

👉 **[Complete Documentation](./docs/index.md)**

### Quick Links

**For Decision Makers / Recruiters:**
- [Project Overview](./docs/project/overview.md)
- [System Architecture](./docs/architecture/system-design.md)
- [GDPR Compliance](./docs/compliance/overview.md)

**For DevOps / SysAdmins:**
- [Server Prerequisites](./docs/operations/prerequisites.md)
- [Installation & Configuration](./docs/operations/installation.md)
- [Deployment Guide](./docs/operations/deployment.md)
- [Ansible Provisioning](./docs/operations/ansible-provisioning.md)

**For Security / Compliance:**
- [Security Hardening](./docs/security/hardening.md)
- [GDPR Technical Measures](./docs/compliance/gdpr-technical.md)
- [Security Standards](./docs/compliance/security-standards.md)

---

## 🤝 Showcase Project

This module demonstrates:

- **Clean architecture** (separation of concerns)
- **Infrastructure as Code** (Ansible, Docker, automated scripts)
- **Legal compliance** (GDPR, privacy by design, CNIL recommendations)
- **Production best practices** (monitoring, backups, security hardening)
- **Complete documentation** (operational guides, technical reference, compliance)

---

## 💼 Professional Context

Developed as part of the **LexOrbital ecosystem** — a modular, compliant, and modern orbital architecture for professional web applications.

**Philosophy:**
- **Security by default** (security by default)
- **Privacy by design** (integrated GDPR compliance)
- **Immutable infrastructure** (idempotent Ansible)
- **Defense in depth** (multiple layers of security)

---

## 🛠️ Features

### Infrastructure

- ✅ Automated and idempotent Ansible provisioning
- ✅ Production-ready Docker Compose and Swarm configurations
- ✅ Nginx reverse proxy with automatic TLS
- ✅ Let's Encrypt certificates with automatic renewal

### Security

- ✅ Security hardening (OWASP, ANSSI)
- ✅ Advanced SSH configuration (ED25519 keys, fail2ban)
- ✅ UFW firewall with strict rules
- ✅ Network isolation (Docker networks)
- ✅ Non-root containers

### GDPR Compliance

- ✅ Log pseudonymization (IP masking)
- ✅ Limited retention (30 days by default)
- ✅ Privacy by design
- ✅ Compliance documentation (Article 32)

### Operations

- ✅ Administration scripts (audit, configuration, update)
- ✅ Disaster recovery plan (DRP)
- ✅ Automated backups
- ✅ Automatic deployment scripts (webhooks)

---

## 🤝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

---

## 📄 License

[MIT](./LICENSE)

---

## 📜 Code of Conduct

See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) for community rules.

---

## 📞 Support

See [SUPPORT.md](./SUPPORT.md) for help.

---

## 🔐 Security

See [SECURITY.md](./SECURITY.md) to report vulnerabilities.

---

**⚠️ PUBLIC-SAFE Repository:** This repository uses `example.com` for domains and `XXXXX` for sensitive ports. Replace these placeholders with your actual values during deployment.

---

**Version:** 0.1.0  
**Last updated:** 2025-12-01  
**Maintained by:** [YohanGH](https://github.com/YohanGH)

---

<div align="center">

**Made with 🚀 by the LexOrbital community**

[Documentation](./docs) • [Contributing](./CONTRIBUTING.md) • [Issues](https://github.com/YohanGH/lexorbital-module-server/issues)

</div>
