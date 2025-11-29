# 00 — Préparation du serveur LexOrbital (avant clone)

Ce document décrit les **préconditions obligatoires** pour installer un serveur LexOrbital.
A exécuter **avant de cloner** le module `lexorbital-module-infra-server`.

---

## 0. Préparation du serveur

**Checklist des prérequis :**

- [x] Mise à jour de l'OS
- [x] Pare-feu minimal strict (iptables ou UFW)
- [x] SSH sécurisé (clé publique + port non-standard + root désactivé)
- [x] Fail2ban configuré
- [x] Désactivation des services inutiles
- [x] Vérification disque / partitions
- [x] Synchronisation horaire (NTP / chrony)
- [x] Journalisation conforme RGPD (journald + logrotate)
- [x] Création d'un utilisateur système « lexorbital » non-root
- [x] Installation Docker + groupe docker

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
# Port 52049
```

Désactiver l'accès root et l'authentification par mot de passe :

```
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

sudo ufw allow 52049/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo ufw enable
```


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
- Ports ouverts : 52049/tcp, 80/tcp, 443/tcp

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


### 8. Création de l'utilisateur système lexorbital

Créer le groupe :

```bash
sudo groupadd lexorbital
```

Créer l'utilisateur système :

```bash
sudo adduser --system --shell /usr/sbin/nologin --home /srv/lexorbital lexorbital
sudo usermod -g lexorbital lexorbital
```

Donner les permissions :

```bash
sudo mkdir -p /srv/lexorbital
sudo chown -R lexorbital:lexorbital /srv/lexorbital
```

Pour entrer :
```bash
sudo su -s /bin/bash lexorbital
```
Pour aller dans son home :
```bash
cd /srv/lexorbital
```
Pour sortir :
```bash
exit

### 9. Installation de Docker et Docker Compose

```bash
sudo apt install -y docker.io docker-compose-plugin
```

Créer le groupe docker si nécessaire :

```bash
sudo groupadd docker
```

Ajouter lexorbital au groupe docker :

```bash
sudo usermod -aG docker lexorbital
```

Recharger les groupes :

```bash
newgrp docker
```


### 10. Emplacement recommandé du dépôt

```
/srv/lexorbital/lexorbital-module-server
```


## ✓ Serveur prêt

Le serveur est sécurisé, conforme RGPD/CNIL, et prêt pour l'installation via `provisionning/` et `deploy/`.
