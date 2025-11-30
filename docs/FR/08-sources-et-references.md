# Sources et références

Ce document liste toutes les sources consultées et références utilisées pour la création et le développement du module serveur LexOrbital.

---

## Infrastructure et serveur

### Systèmes d'exploitation

- **Ubuntu Server**
  - Documentation officielle : https://ubuntu.com/server/docs
  - Guide d'installation : https://ubuntu.com/server/docs/installation
  - Recommandation : Ubuntu 22.04 LTS ou supérieur

- **Debian**
  - Documentation officielle : https://www.debian.org/doc/
  - Guide d'administration : https://www.debian.org/doc/manuals/debian-handbook/
  - Recommandation : Debian 12 (Bookworm) ou supérieur

### Conteneurisation

- **Docker**
  - Documentation officielle : https://docs.docker.com/
  - Guide de sécurité : https://docs.docker.com/engine/security/
  - Best practices : https://docs.docker.com/develop/dev-best-practices/
  - Utilisé pour l'isolation des services et la portabilité

- **Docker Compose**
  - Documentation officielle : https://docs.docker.com/compose/
  - Guide de référence : https://docs.docker.com/compose/compose-file/
  - Utilisé pour l'orchestration locale et le développement

- **Docker Swarm**
  - Documentation officielle : https://docs.docker.com/engine/swarm/
  - Guide de déploiement : https://docs.docker.com/engine/swarm/swarm-mode/
  - Utilisé pour l'orchestration en production avec haute disponibilité

### Provisionnement et automatisation

- **Ansible**
  - Documentation officielle : https://docs.ansible.com/
  - Getting Started Guide : https://docs.ansible.com/ansible/latest/getting_started/
  - Best Practices : https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html
  - Ansible Galaxy : https://galaxy.ansible.com/
  - Utilisé pour le provisionnement automatisé et idempotent des serveurs
  - Rôle `base` fourni pour la configuration système minimale

- **ansible-lint**
  - Documentation officielle : https://ansible-lint.readthedocs.io/
  - Règles : https://ansible-lint.readthedocs.io/rules/
  - Utilisé pour valider la qualité des playbooks et rôles Ansible
  - Intégré dans pre-commit

- **yamllint**
  - Documentation officielle : https://yamllint.readthedocs.io/
  - Configuration : https://yamllint.readthedocs.io/en/stable/configuration.html
  - Utilisé pour valider la syntaxe et le style YAML
  - Configuration personnalisée pour Ansible (`.yamllint.yaml`)

- **Molecule**
  - Documentation officielle : https://molecule.readthedocs.io/
  - Guide de démarrage : https://molecule.readthedocs.io/en/latest/getting-started.html
  - Framework de test pour rôles Ansible (prévu dans la roadmap)

### Reverse Proxy

- **Nginx**
  - Documentation officielle : https://nginx.org/en/docs/
  - Guide de configuration : https://nginx.org/en/docs/http/configuring_https_servers.html
  - Guide de sécurité : https://nginx.org/en/docs/http/ngx_http_core_module.html#server_tokens
  - Utilisé comme reverse proxy principal en production
  - Configuration RGPD-compliant avec pseudonymisation des IPs

- **Caddy**
  - Documentation officielle : https://caddyserver.com/docs/
  - Guide de configuration : https://caddyserver.com/docs/caddyfile
  - Alternative moderne avec TLS automatique
  - Fourni comme exemple dans le module

### Certificats SSL/TLS

- **Let's Encrypt**
  - Site officiel : https://letsencrypt.org/
  - Documentation : https://letsencrypt.org/docs/
  - Service de certificats SSL gratuits et automatisés

- **Certbot**
  - Documentation officielle : https://eff-certbot.readthedocs.io/
  - Guide d'utilisation : https://eff-certbot.readthedocs.io/en/stable/using.html
  - Plugin Nginx : https://eff-certbot.readthedocs.io/en/stable/using.html#nginx
  - Utilisé pour l'obtention et le renouvellement automatique des certificats

---

## Sécurité réseau

### Pare-feu

- **UFW (Uncomplicated Firewall)**
  - Documentation Ubuntu : https://help.ubuntu.com/community/UFW
  - Guide de référence : https://help.ubuntu.com/community/UFW
  - Utilisé pour la configuration simplifiée d'iptables
  - Configuration minimale et avancée documentée

- **iptables**
  - Documentation : https://netfilter.org/documentation/
  - Guide de référence : https://www.netfilter.org/documentation/
  - Utilisé en arrière-plan par UFW

### Protection contre les attaques

- **Fail2ban**
  - Documentation officielle : https://www.fail2ban.org/wiki/index.php/Main_Page
  - Guide de configuration : https://www.fail2ban.org/wiki/index.php/MANUAL_0_8
  - Utilisé pour protéger SSH et autres services contre les attaques par force brute

### Sécurisation SSH

- **OpenSSH**
  - Documentation officielle : https://www.openssh.com/manual.html
  - Guide de configuration : https://www.openssh.com/manual.html#configuration
  - Guide de sécurité : https://www.openssh.com/security.html
  - Utilisé pour l'accès sécurisé au serveur

---

## Gestion des logs et monitoring

### Journalisation système

- **systemd / journald**
  - Documentation systemd : https://www.freedesktop.org/software/systemd/man/systemd.html
  - Documentation journald : https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html
  - Configuration RGPD : https://www.freedesktop.org/software/systemd/man/journald.conf.html
  - Utilisé pour la journalisation système conforme RGPD

- **logrotate**
  - Documentation : https://linux.die.net/man/8/logrotate
  - Guide de configuration : https://linux.die.net/man/5/logrotate.conf
  - Utilisé pour la rotation et la rétention des logs

### Synchronisation horaire

- **chrony**
  - Documentation officielle : https://chrony.tuxfamily.org/documentation.html
  - Guide de configuration : https://chrony.tuxfamily.org/doc/4.3/chrony.conf.html
  - Utilisé pour la synchronisation NTP

---

## Bases de données

### PostgreSQL

- **PostgreSQL**
  - Documentation officielle : https://www.postgresql.org/docs/
  - Guide d'administration : https://www.postgresql.org/docs/current/admin.html
  - Guide de sécurité : https://www.postgresql.org/docs/current/security.html
  - Utilisé comme base de données principale
  - Configuration avec isolation réseau et secrets Docker

---

## Standards et conformité

### Sécurité

- **OWASP (Open Web Application Security Project)**
  - Site officiel : https://owasp.org/
  - OWASP Top 10 : https://owasp.org/www-project-top-ten/
  - Secure Headers Project : https://owasp.org/www-project-secure-headers/
  - Référence pour les bonnes pratiques de sécurité web

- **ANSSI (Agence Nationale de la Sécurité des Systèmes d'Information)**
  - Site officiel : https://cyber.gouv.fr/
  - Guide de cloisonnement système : https://cyber.gouv.fr/sites/default/files/2017/12/guide_cloisonnement_systeme_anssi_pg_040_v1.pdf
  - Guide de sélection cryptographique : https://cyber.gouv.fr/sites/default/files/2021/03/anssi-guide-selection_crypto-1.0.pdf
  - Solutions certifiées : https://cyber.gouv.fr/decouvrir-les-solutions-certifiees
  - Recommandations authentification multifacteur : https://cyber.gouv.fr/publications/recommandations-relatives-lauthentification-multifacteur-et-aux-mots-de-passe
  - Référence pour la sécurité des systèmes d'information en France

- **CERT-FR (Computer Emergency Response Team - France)**
  - Site officiel : https://www.cert.ssi.gouv.fr/
  - Alertes de sécurité : https://www.cert.ssi.gouv.fr/alerte/
  - Avis de sécurité : https://www.cert.ssi.gouv.fr/avis/
  - Actualités sécurité : https://www.cert.ssi.gouv.fr/actualite/
  - Utilisé pour le suivi des menaces et vulnérabilités

### Protection des données (RGPD)

- **CNIL (Commission Nationale de l'Informatique et des Libertés)**
  - Site officiel : https://www.cnil.fr/
  - Guide RGPD du développeur : https://github.com/YohanGH/Guide-RGPD-du-developpeur
  - Site développeur CNIL : https://cnil.fr/developpeur
  - Recommandations journalisation : https://www.cnil.fr/fr/la-cnil-publie-une-recommandation-relative-aux-mesures-de-journalisation
  - Recommandations mots de passe : https://www.cnil.fr/fr/mots-de-passe-recommandations-pour-maitriser-sa-securite
  - Outil PIA (Privacy Impact Assessment) : https://www.cnil.fr/fr/outil-pia-telechargez-et-installez-le-logiciel-de-la-cnil
  - Référence pour la conformité RGPD et la protection des données personnelles

- **RGPD (Règlement Général sur la Protection des Données)**
  - Texte officiel : https://www.legifrance.gouv.fr/cnil/id/CNILTEXT000033929210/
  - Site CNIL : https://cnil.fr/
  - Référence légale pour la protection des données personnelles

- **EDPB (European Data Protection Board)**
  - Site officiel : https://www.edpb.europa.eu/
  - Guidelines 4/2019 - Article 25 (Privacy by Design) : https://www.edpb.europa.eu/our-work-tools/documents/public-consultations/2019/guidelines-42019-article-25-data-protection_en
  - Référence pour l'implémentation du privacy-by-design

### Standards techniques

- **RFC 2606 - Reserved Top-Level DNS Names**
  - Spécification : https://datatracker.ietf.org/doc/html/rfc2606
  - Utilisé pour les domaines d'exemple (`example.com`)

- **RFC 5737 - IPv4 Address Blocks Reserved for Documentation**
  - Spécification : https://datatracker.ietf.org/doc/html/rfc5737
  - Utilisé pour les adresses IP d'exemple dans la documentation

- **TLS/SSL**
  - RFC 8446 - TLS 1.3 : https://datatracker.ietf.org/doc/html/rfc8446
  - RFC 5246 - TLS 1.2 : https://datatracker.ietf.org/doc/html/rfc5246
  - Mozilla SSL Configuration Generator : https://ssl-config.mozilla.org/
  - Référence pour la configuration TLS sécurisée

---

## Outils de développement et maintenance

### Gestion de version

- **Git**
  - Documentation officielle : https://git-scm.com/doc
  - Guide de référence : https://git-scm.com/docs
  - Utilisé pour le contrôle de version

### Scripts et automatisation

- **Bash**
  - Documentation : https://www.gnu.org/software/bash/manual/
  - Guide de référence : https://www.gnu.org/software/bash/manual/bash.html
  - Utilisé pour les scripts d'administration et d'audit

- **ShellCheck**
  - Documentation officielle : https://www.shellcheck.net/
  - Wiki : https://github.com/koalaman/shellcheck/wiki
  - Galerie d'erreurs : https://github.com/koalaman/shellcheck/wiki/Checks
  - Utilisé pour valider la qualité des scripts Bash
  - Intégré dans pre-commit

- **shfmt**
  - Documentation : https://github.com/mvdan/sh
  - Releases : https://github.com/mvdan/sh/releases
  - Utilisé pour formater automatiquement les scripts Bash
  - Intégré dans pre-commit

- **pre-commit**
  - Documentation officielle : https://pre-commit.com/
  - Hooks disponibles : https://pre-commit.com/hooks.html
  - Utilisé comme framework de hooks Git pour modules infra
  - Remplace Husky pour les modules d'infrastructure

### Monitoring et maintenance

- **htop**
  - Documentation : https://htop.dev/
  - Utilisé pour le monitoring système

- **cron**
  - Documentation : https://manpages.debian.org/stretch/cron/cron.8.en.html
  - Guide de référence : https://manpages.debian.org/cron
  - Utilisé pour l'automatisation des tâches (backups, audits)

---

## Documentation et ressources complémentaires

### Guides de sécurité serveur

- **Hardening Linux**
  - Guide Ubuntu : https://ubuntu.com/security/hardening
  - Guide Debian : https://www.debian.org/doc/manuals/securing-debian-manual/
  - Référence pour le durcissement des serveurs Linux

### Best practices

- **Docker Security Best Practices**
  - Documentation : https://docs.docker.com/engine/security/
  - Guide : https://docs.docker.com/develop/dev-best-practices/
  - Référence pour la sécurisation des containers

- **Nginx Security Best Practices**
  - Guide OWASP : https://owasp.org/www-project-web-security-testing-guide/
  - Référence pour la sécurisation de Nginx

### Ressources communautaires

- **Server Fault**
  - Site : https://serverfault.com/
  - Forum communautaire pour l'administration système

- **Stack Overflow**
  - Site : https://stackoverflow.com/
  - Forum communautaire pour le développement

---

## Licences et conformité

### Licences open source

- **MIT License**
  - Texte complet : https://opensource.org/licenses/MIT
  - Licence recommandée pour les modules

### Conformité légale

- **Loi pour la Confiance dans l'Économie Numérique (LCEN)**
  - Référence légale pour l'hébergement en France

- **Directive NIS (Network and Information Systems)**
  - Référence pour la sécurité des réseaux et systèmes d'information

---

## Inspiration et philosophie

### Principes de design

- **Sécurité par défaut (Security by Default)**
  - Configuration sécurisée dès l'installation
  - Principe de moindre privilège appliqué

- **Privacy by Design**
  - Pseudonymisation des logs
  - Minimisation des données collectées
  - Conformité RGPD intégrée

- **Isolation et cloisonnement**
  - Réseaux Docker isolés
  - Services non-root
  - Séparation frontend/backend/database

- **Idempotence**
  - Playbooks Ansible exécutables plusieurs fois sans effet de bord
  - Configuration déclarative plutôt qu'impérative
  - État désiré vs. commandes séquentielles

### Concepts clés

- **Infrastructure as Code (IaC)**
  - Configuration reproductible avec Ansible
  - Playbooks versionnés et testables
  - Documentation complète et intégrée
  - Provisionnement automatisé

- **Défense en profondeur**
  - Plusieurs couches de sécurité
  - Firewall + Fail2ban + Isolation réseau
  - Audit régulier

---

## Notes

Cette liste est non exhaustive et sera mise à jour au fur et à mesure du développement du projet. Les sources mentionnées ont servi de références pour la conception, l'implémentation et la documentation du module serveur LexOrbital.

**Dernière mise à jour :** 2025-11-30

---

## Ressources LexOrbital

### Documentation du module

- **Documentation Ansible** : `ansible/README.md`
- **Guide de démarrage rapide Ansible** : `ansible/QUICKSTART.md`
- **Roadmap Ansible** : `ansible/ROADMAP.md`
- **Guide pre-commit** : `docs/FR/pre-commit-setup.md`
- **Guide d'installation** : `docs/FR/01-installation-et-configuration.md`

