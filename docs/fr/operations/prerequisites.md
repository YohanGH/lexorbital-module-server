# Prérequis Serveur

> **Préparation obligatoire du serveur** avant installation de LexOrbital Module Server.

Ce document décrit les **préconditions obligatoires** pour installer un serveur LexOrbital.  
À exécuter **avant de cloner** le module `lexorbital-module-server`.

> **⚠️ Document PUBLIC-SAFE :** Ce guide utilise des valeurs d'exemple pour les données sensibles (domaines, ports, IPs). Remplacez-les par vos propres valeurs lors de la mise en œuvre.

---

## 🎯 Objectif

Préparer un serveur Debian/Ubuntu avec :
- ✅ Sécurité SSH renforcée
- ✅ Pare-feu configuré (UFW)
- ✅ Docker et Docker Compose installés
- ✅ Nginx comme reverse proxy
- ✅ Certificats TLS (Let's Encrypt)
- ✅ Conformité RGPD (journalisation limitée)

---

## 📋 Checklist Prérequis

**Checklist des prérequis minimaux :**

- [ ] Mise à jour de l'OS
- [ ] SSH sécurisé de base (clé publique + port non-standard + root désactivé)
- [ ] Pare-feu UFW minimal (ports essentiels)
- [ ] Désactivation des services inutiles
- [ ] Vérification disque / partitions
- [ ] Synchronisation horaire (NTP / chrony)
- [ ] Journalisation de base (journald)
- [ ] Création de l'utilisateur système « lexorbital »
- [ ] Installation Docker + groupe docker
- [ ] Installation Nginx (reverse proxy global)
- [ ] Préparation DNS pour domaine + sous-domaines
- [ ] Génération certificats TLS (Let's Encrypt / Certbot)

> **Note :** Pour le durcissement avancé (fail2ban, monitoring, permissions fines), voir [Durcissement Sécurité](../security/hardening.md) et [Audit Permissions](../security/permissions-audit.md).

---

## 🖥️ Configuration Matérielle Recommandée

**Configuration minimale :**

- **OS :** Ubuntu 22.04 LTS ou Debian 12
- **CPU :** 1+ vCPU
- **RAM :** 2+ Go (4 Go recommandé)
- **Disque :** 20+ Go SSD
- **Réseau :** IP publique fixe
- **Ports ouverts :** 
  - `XXXXX/tcp` (SSH personnalisé)
  - `80/tcp` (HTTP)
  - `443/tcp` (HTTPS)

---

## 1. Mise à Jour du Système

```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```

---

## 2. Sécurisation SSH de Base

### 2.1. Modification du Mot de Passe Root

```bash
sudo passwd root
```

### 2.2. Configuration SSH

Éditer la configuration SSH :

```bash
sudo nano /etc/ssh/sshd_config
```

**Paramètres minimaux à configurer :**

```
Port XXXXX  # ⚠️ Remplacer par un port entre 49152-65535
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

**Redémarrer SSH :**

```bash
sudo systemctl restart sshd
```

### 2.3. Ajout de Votre Clé SSH

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
# Coller votre clé publique SSH
chmod 600 ~/.ssh/authorized_keys
```

> **Pour la configuration avancée** (fail2ban, timeouts, etc.), voir [Configuration SSH](../security/ssh-configuration.md).

---

## 3. Installation des Dépendances Minimales

```bash
sudo apt install -y curl git ufw htop ca-certificates gnupg lsb-release chrony
```

> **Note :** Fail2ban sera configuré dans [Durcissement Sécurité](../security/hardening.md) après le déploiement.

---

## 4. Configuration Pare-feu UFW

### Configuration Minimale

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow XXXXX/tcp  # ⚠️ Remplacer par votre port SSH personnalisé
sudo ufw allow 80/tcp     # HTTP
sudo ufw allow 443/tcp    # HTTPS

sudo ufw enable
sudo ufw status
```

> **Important :** Remplacez `XXXXX` par le port SSH configuré à l'étape 2.
> 
> **Pour des règles avancées** (rate limiting, règles spécifiques), voir [Règles Firewall](../security/firewall-rules.md).

---

## 5. Désactivation des Services Inutiles

```bash
sudo systemctl disable --now cups
sudo systemctl disable --now avahi-daemon
sudo systemctl disable --now bluetooth
sudo systemctl disable --now isc-dhcp-server
sudo systemctl disable --now rpcbind
```

---

## 6. Vérification Architecture Serveur

### Vérification Disque

```bash
df -h
lsblk
```

### Vérification Mémoire

```bash
free -h
```

### Vérification CPU

```bash
lscpu
```

---

## 7. Journalisation de Base (RGPD)

Configurer les limites de logs systemd :

```bash
sudo nano /etc/systemd/journald.conf
```

**Ajouter les paramètres suivants :**

```
SystemMaxUse=200M
SystemMaxFileSize=20M
MaxRetentionSec=2592000  # 30 jours
```

**Redémarrer journald :**

```bash
sudo systemctl restart systemd-journald
```

> **Pour la configuration avancée** (logrotate détaillé pour Nginx, rétention spécifique), voir [Politique de Journalisation](../compliance/logging-policy.md).

---

## 8. Création de l'Utilisateur Système

### Créer le Groupe et l'Utilisateur

```bash
sudo groupadd lexorbital
sudo adduser --system --shell /usr/sbin/nologin --home /srv/lexorbital --ingroup lexorbital lexorbital
```

### Créer le Répertoire de Travail

```bash
sudo mkdir -p /srv/lexorbital
sudo chown -R lexorbital:lexorbital /srv/lexorbital
```

> **Pour la gestion détaillée des permissions** (fichiers sensibles, logs, backups, audit), voir [Audit des Permissions](../security/permissions-audit.md).

---

## 9. Installation Docker et Docker Compose

### Installation

```bash
sudo apt install -y docker.io docker-compose-plugin
```

### Configuration Groupe Docker

```bash
sudo groupadd docker
sudo usermod -aG docker lexorbital
newgrp docker
```

### Vérification

```bash
docker --version
docker compose version
```

---

## 10. Installation Reverse Proxy (Nginx)

Le reverse-proxy Nginx vit sur l'hôte, afin de gérer :
- TLS / HTTPS
- Let's Encrypt (certbot)
- Logs minimisés RGPD
- Protection Fail2ban
- Redirection HTTP → HTTPS
- Routage vers les containers (core-front, core-back, etc.)

### Installation

```bash
sudo apt install -y nginx
```

### Vérification

```bash
sudo systemctl status nginx
```

---

## 11. Installation Let's Encrypt (Certbot)

```bash
sudo apt install -y certbot python3-certbot-nginx
```

---

## 12. Configuration DNS

Avant d'obtenir un certificat SSL, configurer vos enregistrements DNS chez votre fournisseur :

**Enregistrements DNS requis :**

```
Type A  : example.com        → <IP_PUBLIQUE_SERVEUR>
Type A  : www.example.com    → <IP_PUBLIQUE_SERVEUR>
Type A  : api.example.com    → <IP_PUBLIQUE_SERVEUR>
```

> **Note :** Remplacez `example.com` par votre domaine et `<IP_PUBLIQUE_SERVEUR>` par l'IP publique de votre serveur.

### Vérification Propagation DNS

```bash
dig +short example.com
nslookup example.com
```

**Attendre :** Propagation DNS (quelques minutes à 24h selon le TTL).

---

## 13. Configuration Nginx Initiale

Créer un vhost minimal HTTP pour la validation Let's Encrypt :

```bash
sudo nano /etc/nginx/sites-available/lexorbital.conf
```

**Contenu :**

```nginx
server {
    listen 80;
    server_name example.com www.example.com api.example.com;

    location / {
        return 200 "LexOrbital Server Ready\n";
        add_header Content-Type text/plain;
    }
}
```

**Activer la configuration :**

```bash
sudo ln -s /etc/nginx/sites-available/lexorbital.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## 14. Génération Certificat TLS Multi-Domaine

```bash
sudo certbot --nginx \
  -d example.com \
  -d www.example.com \
  -d api.example.com \
  --non-interactive \
  --agree-tos \
  --email contact@example.com
```

> **Important :** Remplacez tous les `example.com` par votre domaine réel et l'email de contact.

**Certbot effectue automatiquement :**
- Validation des domaines via challenge HTTP-01
- Génération des certificats SSL
- Modification configuration Nginx pour HTTPS
- Configuration redirection HTTP → HTTPS
- Création renouvellement automatique (cron)

### Vérification Renouvellement Automatique

```bash
sudo certbot renew --dry-run
```

---

## 15. Emplacement Recommandé du Dépôt

```bash
/srv/lexorbital/lexorbital-module-server
```

---

## ✅ Serveur Prêt

Le serveur est sécurisé, conforme RGPD/CNIL, et prêt pour l'installation.

### Prochaines Étapes

1. [Installation et Configuration](./installation.md)
2. [Provisionnement Ansible](./ansible-provisioning.md)
3. [Déploiement](./deployment.md)

---

## 📖 Voir Aussi

- [Installation](./installation.md) - Installation après clone
- [Configuration SSH Avancée](../security/ssh-configuration.md) - Durcissement SSH
- [Règles Firewall](../security/firewall-rules.md) - Configuration UFW avancée
- [Durcissement Sécurité](../security/hardening.md) - Hardening complet
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-12-01  
**Version :** 1.0.0
