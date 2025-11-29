# 00 — Préparation du serveur de production (avant déploiement)

Ce document décrit les **préconditions obligatoires** pour préparer un serveur Linux de production sécurisé et conforme RGPD.

**À exécuter AVANT de déployer votre application.**

> **⚠️ Document PUBLIC-SAFE :** Ce guide utilise des valeurs d'exemple (`example.com`, `myapp`, etc.). Remplacez-les par vos propres valeurs lors de la mise en œuvre.

---

## 0. Préparation du serveur

**Checklist des prérequis :**

- [ ] Mise à jour de l'OS
- [ ] Pare-feu minimal strict (iptables ou UFW)
- [ ] SSH sécurisé (clé publique + port non-standard + root désactivé)
- [ ] Fail2ban configuré
- [ ] Désactivation des services inutiles
- [ ] Vérification disque / partitions
- [ ] Synchronisation horaire (NTP / chrony)
- [ ] Journalisation conforme RGPD (journald + logrotate)
- [ ] Création d'un utilisateur système applicatif non-root
- [ ] Installation Docker + groupe docker
- [ ] Installation Nginx (reverse proxy global)
- [ ] Préparation DNS pour domaine + sous-domaines
- [ ] Génération certificats TLS (Let's Encrypt / Certbot)

---

### 1. Mise à jour du système

```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```


### 2. Sécurisation SSH

Modifier le mot de passe root :

```bash
sudo passwd root
```

Changer le port SSH (recommandé 49152–65535) :

```bash
sudo nano /etc/ssh/sshd_config
# Port XXXXX  # ⚠️ Remplacer par un port de votre choix entre 49152-65535
```

> **Note de sécurité :** Choisir un port non-standard pour SSH réduira les tentatives d'accès automatisées. Conservez ce port en lieu sûr.

Désactiver l'accès root et l'authentification par mot de passe :

```bash
# Dans /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
```

Redémarrer SSH :

```bash
sudo systemctl restart sshd
```

Ajouter la clé SSH publique :

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
# Coller votre clé publique SSH
chmod 600 ~/.ssh/authorized_keys
```


### 3. Installation des dépendances minimales

```bash
sudo apt install -y curl git ufw fail2ban htop ca-certificates gnupg lsb-release chrony
```


### 4. Pare-feu UFW (version simple)

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow XXXXX/tcp  # ⚠️ Remplacer par votre port SSH personnalisé
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo ufw enable
```

> **Important :** Remplacez `XXXXX` par le port SSH que vous avez configuré à l'étape 2.


### 5. Désactivation des services inutiles

```bash
sudo systemctl disable --now cups
sudo systemctl disable --now avahi-daemon
sudo systemctl disable --now bluetooth
sudo systemctl disable --now isc-dhcp-server
sudo systemctl disable --now rpcbind
```


### 6. Vérification de l'architecture serveur

**Recommandations :**

- OS recommandé : Ubuntu 22.04 LTS ou Debian 12
- CPU : 1+ vCPU
- RAM : 1+ Go
- Disque : 20+ Go SSD
- Ports ouverts : XXXXX/tcp (SSH personnalisé), 80/tcp, 443/tcp

Vérification disque :

```bash
df -h
lsblk
```


### 7. Journalisation conforme RGPD

Limiter la taille et la durée des logs systemd :

```bash
sudo nano /etc/systemd/journald.conf
```

Ajouter les paramètres suivants :

```
SystemMaxUse=200M
SystemMaxFileSize=20M
MaxRetentionSec=2592000
```

Redémarrer journald :

```bash
sudo systemctl restart systemd-journald
```

Installer logrotate :

```bash
sudo apt install logrotate -y
```

### Nettoyage / maintenance système

```bash
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```


### 8. Création de l'utilisateur système applicatif

Créer le groupe (remplacer `myapp` par le nom de votre application) :

```bash
sudo groupadd myapp
```

Créer l'utilisateur système :

```bash
sudo adduser --system --shell /usr/sbin/nologin --home /srv/myapp myapp
sudo usermod -g myapp myapp
```

Donner les permissions :

```bash
sudo mkdir -p /srv/myapp
sudo chown -R myapp:myapp /srv/myapp
```

Pour entrer dans cet utilisateur (debug/maintenance) :
```bash
sudo su -s /bin/bash myapp
```

Pour aller dans son home :
```bash
cd /srv/myapp
```

Pour sortir :
```bash
exit
```

### 9. Installation de Docker et Docker Compose

```bash
sudo apt install -y docker.io docker-compose-plugin
```

Créer le groupe docker si nécessaire :

```bash
sudo groupadd docker
```

Ajouter votre utilisateur applicatif au groupe docker :

```bash
sudo usermod -aG docker myapp  # Remplacer myapp par votre utilisateur
```

Recharger les groupes :

```bash
newgrp docker
```

### 10. Installation du Reverse Proxy global (Nginx)

Le reverse-proxy Nginx vit sur l’hôte, afin de gérer :
- TLS / HTTPS
-   Let’s Encrypt (certbot)
-logs minimisés RGPD
-protection Fail2ban
-redirection HTTP → HTTPS
-routage vers les containers (core-front, core-back, etc.)

Installer Nginx :
```bash
sudo apt install -y nginx
```

Vérifier :
```bash
sudo systemctl status nginx
```

### 11. Préparation TLS (Let’s Encrypt / Certbot)

Installer Certbot :
```bash
sudo apt install -y certbot python3-certbot-nginx
```

### 12. Préparation DNS

Avant d'obtenir un certificat SSL, configurer vos enregistrements DNS chez votre fournisseur :

**Enregistrements DNS requis :**
```
Type A  : example.com        → <IP_PUBLIQUE_SERVEUR>
Type A  : www.example.com    → <IP_PUBLIQUE_SERVEUR>
Type A  : api.example.com    → <IP_PUBLIQUE_SERVEUR>
```

> **Note :** Remplacez `example.com` par votre domaine et `<IP_PUBLIQUE_SERVEUR>` par l'IP publique de votre serveur.

Attendre la propagation DNS (quelques minutes à 24h selon le TTL).

Vérifier la propagation :
```bash
dig +short example.com
nslookup example.com
```

---

### 13. Configuration Nginx initiale pour Let's Encrypt

Créer un vhost minimal HTTP pour la validation Let's Encrypt :

```bash
sudo nano /etc/nginx/sites-available/myapp.conf
```

Contenu :
```nginx
server {
    listen 80;
    server_name example.com www.example.com api.example.com;

    location / {
        return 200 "Server Ready\n";
        add_header Content-Type text/plain;
    }
}
```

Activer la configuration :
```bash
sudo ln -s /etc/nginx/sites-available/myapp.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

### 14. Génération du certificat TLS multi-domaine

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

Certbot va automatiquement :
- Valider les domaines via challenge HTTP-01
- Générer les certificats SSL
- Modifier la configuration Nginx pour HTTPS
- Configurer la redirection HTTP → HTTPS
- Créer un renouvellement automatique (cron)

Vérifier le renouvellement automatique :
```bash
sudo certbot renew --dry-run
```

---

### 15. Emplacement recommandé du dépôt

```bash
/srv/myapp/  # Répertoire de l'application
```

---

## ✓ Serveur prêt

Le serveur est sécurisé, conforme RGPD/CNIL, et prêt pour le déploiement de l'application.

**Prochaines étapes :**
1. Cloner le dépôt dans `/srv/myapp/`
2. Configurer les variables d'environnement
3. Lancer les containers Docker
4. Configurer le reverse proxy Nginx complet avec les bons `proxy_pass`
