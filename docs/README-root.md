# 🇫🇷 LexOrbital Module Server | 🇬🇧 LexOrbital Module Server

> **Production-ready server infrastructure module** with integrated security and GDPR compliance for the LexOrbital ecosystem.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Documentation](https://img.shields.io/badge/docs-bilingual-brightgreen)](./docs)

---

## 🌍 Language / Langue

**🇫🇷 Version française** (documentation complète)  
**🇬🇧 English version** (professional showcase)

👉 **[Documentation FR (complète)](./docs/fr/index.md)**  
👉 **[Documentation EN (showcase)](./docs/en/index.md)**

---

## 🎯 What is This? / Qu'est-ce que c'est ?

**🇬🇧 English:**  
LexOrbital Module Server is an **infrastructure module** of the LexOrbital ecosystem providing:

- **Automated provisioning** (Ansible)
- **Security hardening** (OWASP, ANSSI standards)
- **GDPR compliance built-in** (pseudonymization, retention policies)
- **Production deployment** (Docker Compose/Swarm)

**Ideal for:** Startups and scale-ups needing compliant and secure infrastructure without reinventing the wheel.

---

**🇫🇷 Français :**  
LexOrbital Module Server est un **module infrastructure** de l'écosystème LexOrbital fournissant :

- **Provisionnement automatisé** (Ansible)
- **Durcissement sécurité** (standards OWASP, ANSSI)
- **Conformité RGPD intégrée** (pseudonymisation, politiques de rétention)
- **Déploiement production** (Docker Compose/Swarm)

**Idéal pour :** Startups et scale-ups nécessitant une infrastructure conforme et sécurisée sans réinventer la roue.

---

## 🚀 Quick Start / Démarrage Rapide

### Prerequisites / Prérequis

- Debian 11+ or Ubuntu 20.04+ / Debian 11+ ou Ubuntu 20.04+
- Ansible 2.14+ (on your local machine) / Ansible 2.14+ (sur votre machine locale)
- SSH access to target server / Accès SSH au serveur cible

### Installation

```bash
# 1. Clone the repository / Cloner le repository
git clone https://github.com/YohanGH/lexorbital-module-server
cd lexorbital-module-server

# 2. Configure Ansible inventory / Configurer l'inventaire Ansible
cd ansible
nano inventories/prod.ini

# 3. Run provisioning / Lancer le provisionnement
ansible-playbook playbooks/site.yml
```

---

## 🏛️ Architecture

**LexOrbital Orbital Architecture / Architecture Orbitale LexOrbital :**

- **Meta-Kernel:** Central orchestration / Orchestration centrale ([lexorbital-core](https://github.com/YohanGH/lexorbital-core))
- **Ring 1 / Anneau 1:** UI modules / Modules UI ([lexorbital-module-ui-kit](https://github.com/YohanGH/lexorbital-module-ui-kit))
- **Ring 2 / Anneau 2:** Infrastructure modules / Modules infrastructure (← **you are here / vous êtes ici**)
- **Ring 3 / Anneau 3:** Application modules / Modules applicatifs

This module is part of **Ring 2 / Anneau 2** and provides secure and compliant server infrastructure for the entire ecosystem.  
Ce module fait partie de **Ring 2 / Anneau 2** et fournit l'infrastructure serveur sécurisée et conforme pour tout l'écosystème.

---

## 🔒 Compliance First / Conformité d'Abord

✅ **GDPR-ready / RGPD-ready:** Pseudonymization, retention policies, privacy by design  
✅ **Security standards / Standards sécurité:** OWASP Top 10, ANSSI recommendations  
✅ **Audit trail / Piste d'audit:** Complete logging with automatic rotation

**🇬🇧 See:** [GDPR Overview](./docs/en/compliance/gdpr-overview.md)  
**🇫🇷 Voir:** [Conformité RGPD](./docs/fr/compliance/overview.md)

---

## 📚 Documentation

### 🇬🇧 English Documentation (Showcase)

**For Recruiters / Decision Makers:**
- [Project Overview](./docs/en/project/overview.md)
- [System Architecture](./docs/en/architecture/system-design.md)
- [GDPR Compliance](./docs/en/compliance/gdpr-overview.md)

**Quick Start:**
- [Getting Started](./docs/en/operations/quickstart.md)

### 🇫🇷 Documentation Française (Complète)

**Pour les Décideurs:**
- [Vue d'ensemble du projet](./docs/fr/project/overview.md)
- [Architecture système](./docs/fr/architecture/system-design.md)
- [Conformité RGPD](./docs/fr/compliance/overview.md)

**Pour les DevOps / SysAdmins:**
- [Prérequis serveur](./docs/fr/operations/prerequisites.md)
- [Installation & Configuration](./docs/fr/operations/installation.md)
- [Guide de déploiement](./docs/fr/operations/deployment.md)

**Pour la Sécurité / Compliance:**
- [Durcissement sécurité](./docs/fr/security/hardening.md)
- [Mesures techniques RGPD](./docs/fr/compliance/gdpr-technical.md)

---

## 🤝 Showcase Project / Projet Vitrine

This module demonstrates / Ce module démontre :

- **Clean architecture** / Architecture propre
- **Infrastructure as Code** (Ansible, Docker, automated scripts)
- **Legal compliance** / Conformité légale (GDPR/RGPD, privacy by design)
- **Production best practices** / Best practices production

---

## 💼 Professional Context / Contexte Professionnel

Developed as part of the **LexOrbital ecosystem** — a modular, compliant, and modern orbital architecture for professional web applications.

Développé dans le cadre de **l'écosystème LexOrbital** — une architecture orbitale modulaire, conforme et moderne pour applications web professionnelles.

---

## 🤝 Contributing / Contribution

See / Voir [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 📄 License

[MIT](./LICENSE)

---

## 📜 Code of Conduct / Code de Conduite

See / Voir [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)

---

**⚠️ PUBLIC-SAFE Repository**

This repository uses `example.com` for domains and `XXXXX` for sensitive ports. Replace these placeholders with your actual values during deployment.

Ce repository utilise `example.com` pour les domaines et `XXXXX` pour les ports sensibles. Remplacez ces placeholders par vos valeurs réelles lors du déploiement.

---

**Version:** 0.1.0  
**Last updated / Dernière mise à jour:** 2025-01-15

---

<div align="center">

**Made with 🌍 by the LexOrbital community**

[🇫🇷 Docs FR](./docs/fr/) • [🇬🇧 Docs EN](./docs/en/) • [Contributing](./CONTRIBUTING.md) • [Issues](https://github.com/YohanGH/lexorbital-module-server/issues)

</div>
