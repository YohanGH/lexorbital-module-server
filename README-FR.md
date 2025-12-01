# LexOrbital Module Server

> **Module d'infrastructure serveur production-ready** avec sécurité et conformité RGPD intégrées pour l'écosystème LexOrbital.

## 🎯 Qu'est-ce que c'est ?

Un **module d'infrastructure éprouvé et réutilisable** fournissant :

- **Provisionnement automatisé** (Ansible)
- **Durcissement sécurité** (standards OWASP, ANSSI)
- **Conformité RGPD** intégrée (pseudonymisation, politiques de rétention)
- **Déploiement production** (Docker Compose/Swarm)
- **Plan de reprise** (DRP, sauvegardes, tests de restauration)

**Idéal pour :** Startups et scale-ups nécessitant une infrastructure conforme et sécurisée sans réinventer la roue.

---

## 🚀 Démarrage Rapide

### Prérequis

- Debian 11+ ou Ubuntu 20.04+
- Ansible 2.14+ (sur votre machine locale)
- Accès SSH au serveur cible

### Installation en 3 Étapes

```bash
# 1. Cloner le repository
git clone https://github.com/YohanGH/lexorbital-module-server
cd lexorbital-module-server

# 2. Configurer l'inventaire Ansible
cd ansible
nano inventories/prod.ini

# 3. Lancer le provisionnement
ansible-playbook playbooks/site.yml
```

**Temps de déploiement :** 2-4 heures pour un serveur production-ready.

---

## 🏛️ Architecture

### Architecture Orbitale LexOrbital

- **Meta-Kernel :** Orchestration centrale ([lexorbital-core](https://github.com/YohanGH/lexorbital-core))
- **Anneau 1 :** Modules UI ([lexorbital-module-ui-kit](https://github.com/YohanGH/lexorbital-module-ui-kit))
- **Anneau 2 :** Modules infrastructure (← **vous êtes ici**)
- **Anneau 3 :** Modules applicatifs

Ce module fait partie de **l'Anneau 2** et fournit l'infrastructure serveur sécurisée et conforme pour tout l'écosystème.

### Stack Technique

- **Orchestration :** Docker Compose / Swarm
- **Provisionnement :** Ansible
- **Reverse Proxy :** Nginx
- **Certificats :** Let's Encrypt (Certbot)
- **Pare-feu :** UFW
- **Logs :** journald avec rotation automatique

---

## 🔒 Conformité d'Abord

✅ **RGPD-ready :** Pseudonymisation IPs, politiques de rétention (30 jours), privacy by design  
✅ **Standards de sécurité :** OWASP Top 10, recommandations ANSSI  
✅ **Piste d'audit :** Journalisation complète avec rotation automatique  
✅ **Isolation réseau :** Séparation frontend/backend/database  
✅ **TLS 1.2+ :** HSTS, headers de sécurité (CSP, X-Frame-Options)

---

## 📚 Documentation

👉 **[Documentation Complète](./docs/index.md)**

### Liens Rapides

**Pour les Décideurs / Recruteurs :**
- [Vue d'ensemble du projet](./docs/project/overview.md)
- [Architecture système](./docs/architecture/system-design.md)
- [Conformité RGPD](./docs/compliance/overview.md)

**Pour les DevOps / SysAdmins :**
- [Prérequis serveur](./docs/operations/prerequisites.md)
- [Installation & Configuration](./docs/operations/installation.md)
- [Guide de déploiement](./docs/operations/deployment.md)
- [Provisionnement Ansible](./docs/operations/ansible-provisioning.md)

**Pour la Sécurité / Compliance :**
- [Durcissement sécurité](./docs/security/hardening.md)
- [Mesures techniques RGPD](./docs/compliance/gdpr-technical.md)
- [Standards de sécurité](./docs/compliance/security-standards.md)

---

## 🤝 Projet Vitrine

Ce module démontre :

- **Architecture propre** (séparation des préoccupations)
- **Infrastructure as Code** (Ansible, Docker, scripts automatisés)
- **Conformité légale** (RGPD, privacy by design, recommandations CNIL)
- **Best practices production** (monitoring, sauvegardes, security hardening)
- **Documentation complète** (guides opérationnels, référence technique, compliance)

---

## 💼 Contexte Professionnel

Développé dans le cadre de **l'écosystème LexOrbital** — une architecture orbitale modulaire, conforme et moderne pour applications web professionnelles.

**Philosophie :**
- **Sécurité par défaut** (security by default)
- **Privacy by design** (conformité RGPD intégrée)
- **Infrastructure immuable** (Ansible idempotent)
- **Défense en profondeur** (multiple layers of security)

---

## 🛠️ Features

### Infrastructure

- ✅ Provisionnement Ansible automatisé et idempotent
- ✅ Docker Compose et Swarm configurations production-ready
- ✅ Reverse proxy Nginx avec TLS automatique
- ✅ Certificats Let's Encrypt avec renouvellement automatique

### Sécurité

- ✅ Security hardening (OWASP, ANSSI)
- ✅ Configuration SSH avancée (clés ED25519, fail2ban)
- ✅ Pare-feu UFW avec règles strictes
- ✅ Isolation réseau (Docker networks)
- ✅ Containers non-root

### Conformité RGPD

- ✅ Pseudonymisation logs (masquage IP)
- ✅ Rétention limitée (30 jours par défaut)
- ✅ Privacy by design
- ✅ Documentation conformité (Article 32)

### Opérations

- ✅ Scripts d'administration (audit, configuration, mise à jour)
- ✅ Plan de reprise après sinistre (DRP)
- ✅ Sauvegardes automatisées
- ✅ Scripts de déploiement automatique (webhooks)

---

## 🤝 Contribution

Voir [CONTRIBUTING.md](./CONTRIBUTING.md) pour les directives de contribution.

---

## 📄 License

[MIT](./LICENSE)

---

## 📜 Code de Conduite

Voir [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) pour les règles de la communauté.

---

## 📞 Support

Voir [SUPPORT.md](./SUPPORT.md) pour obtenir de l'aide.

---

## 🔐 Sécurité

Voir [SECURITY.md](./SECURITY.md) pour signaler des vulnérabilités.

---

**⚠️ Repository PUBLIC-SAFE :** Ce repository utilise `example.com` pour les domaines et `XXXXX` pour les ports sensibles. Remplacez ces placeholders par vos valeurs réelles lors du déploiement.

---

**Version :** 0.1.0  
**Dernière mise à jour :** 2025-12-01  
**Maintenu par :** [YohanGH](https://github.com/YohanGH)
