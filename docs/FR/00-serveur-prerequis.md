# 00 — Préparation du serveur LexOrbital (avant clone)

Ce document décrit les **préconditions obligatoires** pour installer un serveur LexOrbital.
À exécuter **avant de cloner** le module `lexorbital-module-server`.

> **⚠️ Document PUBLIC-SAFE :** Ce guide utilise des valeurs d'exemple pour les données sensibles (domaines, ports, IPs). Remplacez-les par vos propres valeurs lors de la mise en œuvre.

---

## 0. Préparation du serveur

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

> **Note :** Pour le durcissement avancé (fail2ban, monitoring, permissions fines), voir les documents `03-renforcement-de-la-securite.md` et `04-utilisateurs-et-autorisations.md`.

---

### 1. Mise à jour du système

```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```


### 2. Sécurisation SSH de base

Modifier le mot de passe root :

```bash
sudo passwd root
```

Configurer SSH :

```bash
sudo nano /etc/ssh/sshd_config
```

Paramètres minimaux à configurer :

```
Port XXXXX  # ⚠️ Remplacer par un port entre 49152-65535
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

Redémarrer SSH :

```bash
sudo systemctl restart sshd
```

Ajouter votre clé SSH publique :

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
# Coller votre clé publique SSH
chmod 600 ~/.ssh/authorized_keys
```

> **Pour la configuration avancée** (fail2ban, timeouts, etc.), voir `03-renforcement-de-la-securite.md`.


### 3. Installation des dépendances minimales

```bash
sudo apt install -y curl git ufw htop ca-certificates gnupg lsb-release chrony
```

> **Note :** Fail2ban sera configuré dans `03-renforcement-de-la-securite.md` après le déploiement.


### 4. Pare-feu UFW (configuration minimale)

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
> **Pour des règles avancées** (rate limiting, règles spécifiques), voir `03-renforcement-de-la-securite.md`.


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


### 7. Journalisation de base (RGPD)

Configurer les limites de logs systemd :

```bash
sudo nano /etc/systemd/journald.conf
```

Ajouter les paramètres suivants :

```
SystemMaxUse=200M
SystemMaxFileSize=20M
MaxRetentionSec=2592000  # 30 jours
```

Redémarrer journald :

```bash
sudo systemctl restart systemd-journald
```

> **Pour la configuration avancée** (logrotate détaillé pour Nginx, rétention spécifique), voir `03-renforcement-de-la-securite.md`.


### 8. Création de l'utilisateur système lexorbital

Créer le groupe et l'utilisateur :

```bash
sudo groupadd lexorbital
sudo adduser --system --shell /usr/sbin/nologin --home /srv/lexorbital --ingroup lexorbital lexorbital
```

Créer le répertoire de travail :

```bash
sudo mkdir -p /srv/lexorbital
sudo chown -R lexorbital:lexorbital /srv/lexorbital
```

> **Pour la gestion détaillée des permissions** (fichiers sensibles, logs, backups, audit), voir `04-utilisateurs-et-autorisations.md`.

### 9. Installation de Docker et Docker Compose

```bash
sudo apt install -y docker.io docker-compose-plugin
```

Créer le groupe docker si nécessaire :

```bash
sudo groupadd docker
```

Ajouter l'utilisateur lexorbital au groupe docker :

```bash
sudo usermod -aG docker lexorbital
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
sudo nano /etc/nginx/sites-available/lexorbital.conf
```

Contenu :
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

Activer la configuration :
```bash
sudo ln -s /etc/nginx/sites-available/lexorbital.conf /etc/nginx/sites-enabled/
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
/srv/lexorbital/lexorbital-module-server
```

---

## ✓ Serveur prêt

Le serveur est sécurisé, conforme RGPD/CNIL, et prêt pour l'installation via `provisionning/` et `deploy/`.

**Prochaines étapes :**
1. Cloner le dépôt dans `/srv/lexorbital/`
2. Configurer les variables d'environnement
3. Créer les secrets Docker
4. Lancer les containers Docker
5. Configurer le reverse proxy Nginx complet avec les bons `proxy_pass`
