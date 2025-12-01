# Documentation LexOrbital Module Server

> Documentation complète pour le déploiement, la maintenance et l'utilisation du module serveur LexOrbital.

---

## 🗺️ Navigation par Rôle

### 👨‍💼 Pour les Décideurs / Recruteurs

**Vous voulez comprendre le projet en 5 minutes ?**

- [📖 Vue d'ensemble du projet](./project/overview.md) - Vision, objectifs, contexte
- [🏗️ Architecture système](./architecture/system-design.md) - Design technique
- [⚖️ Conformité RGPD](./compliance/overview.md) - Conformité et sécurité
- [🎯 Feuille de route](./project/roadmap.md) - Évolution et objectifs

**Temps de lecture estimé :** 15 minutes

---

### 👨‍💻 Pour les Développeurs

**Vous voulez contribuer ou utiliser ce module ?**

- [🚀 Environnement de développement](./howto/setup-dev-environment.md) - Setup rapide
- [🤝 Guide de contribution](./howto/contribute.md) - Comment contribuer
- [🔧 Dépannage](./howto/troubleshooting.md) - Résolution de problèmes
- [📚 Glossaire](./project/glossary.md) - Termes techniques

**Temps de setup estimé :** 30 minutes

---

### 🔧 Pour les DevOps / SysAdmins

**Vous voulez déployer et maintenir ?**

- [📋 Prérequis](./operations/prerequisites.md) - Prérequis système et logiciels
- [⚙️ Installation](./operations/installation.md) - Installation pas à pas
- [🚀 Déploiement](./operations/deployment.md) - Procédures de déploiement
- [🤖 Provisionnement Ansible](./operations/ansible-provisioning.md) - Automatisation
- [🔄 Sauvegarde & Reprise](./operations/backup-recovery.md) - DRP et restauration
- [📊 Monitoring](./operations/monitoring.md) - Surveillance et alertes
- [🔧 Maintenance](./operations/maintenance.md) - Maintenance courante

**Temps de déploiement estimé :** 2-4 heures

---

### 🔒 Pour la Sécurité / Compliance

**Vous voulez auditer la sécurité et la conformité ?**

- [🛡️ Standards de sécurité](./compliance/security-standards.md) - OWASP, ANSSI
- [⚖️ Mesures techniques RGPD](./compliance/gdpr-technical.md) - Article 32
- [🔐 Durcissement système](./security/hardening.md) - Hardening complet
- [📜 Politique de journalisation](./compliance/logging-policy.md) - Logs et pseudonymisation
- [🔍 Audit des permissions](./security/permissions-audit.md) - Procédures d'audit

**Temps d'audit estimé :** 3-6 heures

---

## 📖 Table des Matières Complète

### 📁 Projet

- [Vue d'ensemble](./project/overview.md) - Vision et contexte
- [Feuille de route](./project/roadmap.md) - Évolution du projet
- [Décisions architecturales](./project/decisions.md) - ADRs
- [Glossaire](./project/glossary.md) - Terminologie

### 🏗️ Architecture

- [Design système](./architecture/system-design.md) - Architecture globale
- [Infrastructure](./architecture/infrastructure.md) - Docker, Ansible, orchestration
- [Topologie réseau](./architecture/network-topology.md) - Réseaux et sécurité
- [Diagrammes](./architecture/diagrams/README.md) - Schémas techniques

### ⚖️ Conformité

- [Vue d'ensemble](./compliance/overview.md) - Conformité générale
- [Mesures techniques RGPD](./compliance/gdpr-technical.md) - Article 32
- [Standards de sécurité](./compliance/security-standards.md) - OWASP, ANSSI
- [Politique de journalisation](./compliance/logging-policy.md) - Logs
- [Rétention des données](./compliance/data-retention.md) - Politiques de rétention

### 🔧 Opérations

- [Prérequis](./operations/prerequisites.md) - Configuration minimale
- [Installation](./operations/installation.md) - Installation complète
- [Déploiement](./operations/deployment.md) - Compose/Swarm
- [Provisionnement Ansible](./operations/ansible-provisioning.md) - Automatisation
- [Reverse Proxy](./operations/reverse-proxy.md) - Nginx/Caddy
- [Sauvegarde & Reprise](./operations/backup-recovery.md) - DRP
- [Monitoring](./operations/monitoring.md) - Surveillance
- [Maintenance](./operations/maintenance.md) - Entretien

### 🔒 Sécurité

- [Durcissement système](./security/hardening.md) - Hardening complet
- [Configuration SSH](./security/ssh-configuration.md) - SSH avancé
- [Règles firewall](./security/firewall-rules.md) - UFW
- [Audit des permissions](./security/permissions-audit.md) - Procédures
- [Réponse aux incidents](./security/incident-response.md) - Procédures

### 🎯 Guides Pratiques

- [Setup environnement dev](./howto/setup-dev-environment.md)
- [Exécuter playbook Ansible](./howto/run-ansible-playbook.md)
- [Déployer une application](./howto/deploy-application.md)
- [Configurer webhook](./howto/configure-webhook.md)
- [Dépannage](./howto/troubleshooting.md)
- [Contribuer](./howto/contribute.md)

### 📚 Référence

- [Scripts utilitaires](./reference/scripts.md) - Documentation scripts
- [Commandes](./reference/commands.md) - Référence commandes
- [Configuration](./reference/configuration.md) - Variables et options
- [Ressources externes](./reference/resources.md) - Sources et liens

---

## 🔍 Recherche Rapide

### Par Tâche

- **Installer le module** → [Prérequis](./operations/prerequisites.md) + [Installation](./operations/installation.md)
- **Déployer en production** → [Déploiement](./operations/deployment.md)
- **Configurer la sécurité** → [Durcissement](./security/hardening.md)
- **Sauvegarder les données** → [Backup & Recovery](./operations/backup-recovery.md)
- **Résoudre un problème** → [Dépannage](./howto/troubleshooting.md)
- **Contribuer au projet** → [Guide de contribution](./howto/contribute.md)

### Par Technologie

- **Docker** → [Infrastructure](./architecture/infrastructure.md), [Déploiement](./operations/deployment.md)
- **Ansible** → [Provisionnement Ansible](./operations/ansible-provisioning.md)
- **Nginx** → [Reverse Proxy](./operations/reverse-proxy.md)
- **RGPD** → [Conformité RGPD](./compliance/gdpr-technical.md)
- **Sécurité** → [Durcissement](./security/hardening.md), [Standards](./compliance/security-standards.md)

### Par Problème Courant

- **Erreur SSH** → [Configuration SSH](./security/ssh-configuration.md)
- **Erreur Docker** → [Dépannage](./howto/troubleshooting.md)
- **Erreur Ansible** → [Provisionnement Ansible](./operations/ansible-provisioning.md)
- **Erreur Nginx** → [Reverse Proxy](./operations/reverse-proxy.md)
- **Problème permissions** → [Audit Permissions](./security/permissions-audit.md)

---

## 📝 Conventions de Documentation

Ce projet suit le [Guide de Style LexOrbital](./template/style-guide.md).

**Principes :**
- ✅ Documentation en **français** (contexte légal français)
- ✅ Exemples PUBLIC-SAFE (pas de secrets)
- ✅ Instructions testables et reproductibles
- ✅ Mise à jour régulière

---

## 🤝 Contribuer à la Documentation

La documentation est **vivante** et s'améliore en continu.

**Pour contribuer :**

1. Identifier une amélioration ou correction
2. Suivre le [Guide de style](./template/style-guide.md)
3. Créer une PR avec description claire
4. Mettre à jour la date de dernière modification

Voir [Guide de contribution](./howto/contribute.md) pour plus de détails.

---

## 📄 À Propos de Cette Documentation

- **Structure :** Basée sur [lexorbital-template-docs](https://github.com/YohanGH/lexorbital-template-docs)
- **Style :** [Guide de style LexOrbital](./template/style-guide.md)
- **Licence :** [MIT](../../LICENSE)

---

**Dernière mise à jour :** 2025-12-01  
**Version documentation :** 1.0.0
