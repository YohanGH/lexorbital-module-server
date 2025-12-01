# Référence Configuration

> **Référence des variables et options de configuration** pour LexOrbital Module Server.

---

## 🎯 Objectif

Documenter les variables de configuration et options disponibles.

---

## 🔧 Variables Ansible

### Inventaire

**Fichier :** `ansible/inventories/prod.ini`

```ini
[servers]
server1 ansible_host=192.168.1.100 ansible_user=admin
```

### Variables de Groupe

**Fichier :** `ansible/group_vars/all.yml`

```yaml
docker_version: "20.10"
nginx_version: "latest"
ssh_port: 49152
```

---

## 🐳 Docker Compose

### Variables d'Environnement

**Fichier :** `.env`

```bash
COMPOSE_PROJECT_NAME=lexorbital
TZ=Europe/Paris
```

---

## 🌐 Nginx

### Configuration

**Fichier :** `/etc/nginx/sites-available/lexorbital.conf`

```nginx
server {
    listen 80;
    server_name example.com;
    # Configuration...
}
```

---

## 🔐 SSH

### Configuration

**Fichier :** `/etc/ssh/sshd_config`

```ssh
Port XXXXX
PermitRootLogin no
PasswordAuthentication no
```

---

## 📖 Voir Aussi

- [Scripts](./scripts.md) - Scripts utilitaires
- [Commandes](./commands.md) - Référence commandes
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

