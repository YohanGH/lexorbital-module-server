# Infrastructure

> **Stack technique et infrastructure** de LexOrbital Module Server.

---

## 🎯 Objectif

Documenter l'infrastructure technique complète : Docker, Ansible, reverse proxy, et outils de déploiement.

---

## 🐳 Docker

### Version Requise

- Docker 20.10+
- Docker Compose Plugin 2.0+

### Configuration

- Containers non-root
- Réseaux isolés
- Volumes nommés pour persistance
- Health checks configurés

### Commandes Utiles

```bash
# Vérifier version
docker --version
docker compose version

# Lister containers
docker ps

# Voir logs
docker compose logs -f
```

---

## 🤖 Ansible

### Version Requise

- Ansible 2.14+

### Structure

```
ansible/
├── inventories/      # Inventaires (dev, prod)
├── playbooks/       # Playbooks principaux
└── roles/           # Rôles réutilisables
```

### Rôles Disponibles

- `docker` : Installation et configuration Docker
- `nginx` : Configuration reverse proxy
- `security` : Hardening système
- `certbot` : Gestion certificats TLS

---

## 🌐 Nginx

### Rôle

Reverse proxy sur l'hôte pour :
- Gestion TLS/HTTPS
- Routage vers containers
- Logs minimisés (RGPD)
- Protection fail2ban

### Configuration

- Fichiers dans `/etc/nginx/sites-available/`
- Activation via symlinks dans `sites-enabled/`
- Validation : `nginx -t`

---

## 🔐 Certificats TLS

### Let's Encrypt

- Certbot installé sur l'hôte
- Renouvellement automatique (cron)
- Support multi-domaines

### Commandes

```bash
# Générer certificat
sudo certbot --nginx -d example.com

# Tester renouvellement
sudo certbot renew --dry-run
```

---

## 🔒 Sécurité

### Pare-feu UFW

- Configuration minimale par défaut
- Ports ouverts : SSH, HTTP, HTTPS
- Règles spécifiques selon besoins

### Fail2ban

- Protection contre brute force SSH
- Filtres Nginx pour attaques HTTP
- Configuration dans `/etc/fail2ban/`

---

## 📊 Monitoring

### Logs

- Journald pour logs système
- Logs Docker via `docker compose logs`
- Logs Nginx dans `/var/log/nginx/`

### Surveillance

- Health checks Docker
- Monitoring système (optionnel)
- Alertes (à configurer)

---

## 🔄 Backup

### Stratégie

- Sauvegardes automatisées (scripts)
- Rotation des backups
- Tests de restauration réguliers

### Emplacements

- Base de données : `/backup/db/`
- Fichiers : `/backup/files/`

---

## 📖 Voir Aussi

- [Architecture Système](./system-design.md) - Vue d'ensemble
- [Topologie Réseau](./network-topology.md) - Architecture réseau
- [Déploiement](../operations/deployment.md) - Guide déploiement
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

