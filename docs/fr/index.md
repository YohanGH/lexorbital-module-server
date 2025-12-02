# 📚 Documentation LexOrbital Module Server

> **Documentation complète** du module serveur LexOrbital.

---

## 🎯 Bienvenue

Cette documentation couvre tous les aspects du **LexOrbital Module Server**, incluant le nouveau **système de surveillance multi-couches**.

---

## 🗂️ Navigation

### 📖 Projet

- [Vue d'ensemble](./project/overview.md)
- [Glossaire](./project/glossary.md)
- [Décisions techniques](./project/decisions.md)

### 🏛️ Architecture

- [Design Système](./architecture/system-design.md)
- [Infrastructure](./architecture/infrastructure.md)
- [Topologie Réseau](./architecture/network-topology.md)

### 🔧 Opérations

- [Prérequis](./operations/prerequisites.md)
- [Installation](./operations/installation.md)
- [Déploiement](./operations/deployment.md)
- [Provisioning Ansible](./operations/ansible-provisioning.md)
- [Reverse Proxy](./operations/reverse-proxy.md)
- [Backup & Recovery](./operations/backup-recovery.md)
- [Maintenance](./operations/maintenance.md)
- [Monitoring](./operations/monitoring.md)

### 🔒 Sécurité

- [Hardening](./security/hardening.md)
- [Configuration SSH](./security/ssh-configuration.md)
- [Règles Firewall](./security/firewall-rules.md)
- [Audit des Permissions](./security/permissions-audit.md)
- [Réponse aux Incidents](./security/incident-response.md)

### ✅ Conformité

- [Vue d'ensemble](./compliance/overview.md)
- [Mesures Techniques RGPD](./compliance/gdpr-technical.md)
- [Standards de Sécurité](./compliance/security-standards.md)
- [Politique de Logging](./compliance/logging-policy.md)
- [Rétention des Données](./compliance/data-retention.md)

### 📘 Référence

- [Commandes](./reference/commands.md)
- [Configuration](./reference/configuration.md)
- [Scripts](./reference/scripts.md)
- [Ressources](./reference/resources.md)

### 📝 How-To Guides

- [Setup Dev Environment](./howto/setup-dev-environment.md)
- [Déployer une Application](./howto/deploy-application.md)
- [Configurer Pre-commit](./howto/pre-commit-setup.md)
- [Exécuter Playbook Ansible](./howto/run-ansible-playbook.md)
- [Configurer Webhook](./howto/configure-webhook.md)
- [Contribuer](./howto/contribute.md)
- [Dépannage](./howto/troubleshooting.md)

---


### 🌟 Fonctionnalités

✅ **Rapports JSON structurés** consommables par API  
✅ **Automatisation** via systemd timers  
✅ **Alertes** intelligentes (email, webhook)  
✅ **RGPD-compliant** by design (pseudonymisation, rétention)  
✅ **Tests** unitaires et d'intégration  
✅ **Documentation** complète

## 🚀 Démarrage Rapide Global

### Pour les Décideurs / Recruteurs

1. [Vue d'ensemble du Projet](./project/overview.md)
2. [Architecture Système](./architecture/system-design.md)
3. [Conformité RGPD](./compliance/overview.md)

### Pour DevOps / SysAdmins

1. [Prérequis Serveur](./operations/prerequisites.md)
2. [Installation & Configuration](./operations/installation.md)
3. [Guide de Déploiement](./operations/deployment.md)
4. [Provisioning Ansible](./operations/ansible-provisioning.md)
5. **[🆕 Surveillance](./operations/surveillance-guide.md)**

### Pour Sécurité / Conformité

1. [Hardening Sécurité](./security/hardening.md)
2. [Mesures Techniques RGPD](./compliance/gdpr-technical.md)
3. [Standards de Sécurité](./compliance/security-standards.md)
4. **[🆕 RGPD Surveillance](./compliance/surveillance-gdpr.md)**

---

## 📦 Structure du Projet

```
lexorbital-module-server/
├── ansible/                 # Playbooks et rôles Ansible
├── backup/                  # Scripts de sauvegarde
├── deploy/                  # Scripts de déploiement
├── docs/                    # Documentation (vous êtes ici)
├── monitoring/              # 🆕 Système de surveillance
│   ├── config/             # Configuration
│   ├── lib/                # Bibliothèques communes
│   ├── modules/            # Modules de surveillance
│   ├── orchestrator/       # Orchestrateur principal
│   ├── schemas/            # Schemas JSON
│   ├── tests/              # Tests
│   └── types/              # Types TypeScript
├── reverse-proxy/          # Configurations Nginx/Caddy
├── scripts/                # Scripts utilitaires
├── systemd/                # Services systemd
│   └── surveillance/       # 🆕 Timers de surveillance
└── var/                    # Assets web
```

---

## 🤝 Contribuer

Consultez [CONTRIBUTING.md](../../CONTRIBUTING.md) pour les guidelines de contribution.

---

## 📄 Licence

[MIT License](../../LICENSE)

---

## 📞 Support

- **GitHub Issues** : [Créer une issue](https://github.com/YohanGH/lexorbital-module-server/issues)
- **Security** : Voir [SECURITY.md](../../SECURITY.md)
- **Support** : Voir [SUPPORT.md](../../SUPPORT.md)

---

## 📈 Changelog

Voir [CHANGELOG.md](../../CHANGELOG.md) pour l'historique des versions.

---

**Version Documentation** : 1.0.0
**Dernière mise à jour** : 2025-12-02
**Maintenu par** : [YohanGH](https://github.com/YohanGH)

---

<div align="center">

**Made with 🚀 by the LexOrbital community**

[GitHub](https://github.com/YohanGH/lexorbital-module-server) • [Documentation](.) • [Contributing](../../CONTRIBUTING.md)

</div>
