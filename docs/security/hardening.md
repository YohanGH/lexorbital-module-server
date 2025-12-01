# Durcissement Serveur (Security Hardening)

> **Mesures avancées de renforcement de la sécurité** à appliquer après le déploiement initial.

Ce document décrit les **mesures avancées de renforcement de la sécurité** à appliquer après le déploiement initial.

> **⚠️ Prérequis :** Avoir complété [Prérequis Serveur](../operations/prerequisites.md) (SSH de base, UFW minimal, utilisateur créé).
> 
> **⚠️ Document PUBLIC-SAFE :** Adaptez selon votre contexte de sécurité.

---

## 1. Sécurisation SSH avancée

### Configuration complète SSH

Améliorer la configuration SSH de base :

```bash
sudo nano /etc/ssh/sshd_config
```

Paramètres avancés à ajouter :

```
# Sécurité de base (déjà fait dans prérequis)
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port XXXXX  # Port personnalisé (49152-65535)

# Protection contre les attaques par force brute
MaxAuthTries 3
LoginGraceTime 30
PermitEmptyPasswords no

# Timeouts pour éviter les connexions zombies
ClientAliveInterval 300
ClientAliveCountMax 2
TCPKeepAlive yes

# Désactiver les fonctionnalités inutiles
X11Forwarding no
AllowTcpForwarding yes  # Garder pour tunnels si nécessaire
PermitTunnel no
```

Redémarrer SSH :

```bash
sudo systemctl restart sshd
sudo systemctl status sshd
```

### Fail2Ban - Protection contre les attaques

Installer Fail2Ban :

```bash
sudo apt install fail2ban -y
```

Créer la configuration personnalisée :

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Configuration recommandée :

```ini
[DEFAULT]
# Temps de bannissement (1 heure)
bantime = 3600

# Fenêtre de temps pour compter les tentatives (10 minutes)
findtime = 600

# Nombre maximum de tentatives avant bannissement
maxretry = 3

# Email de notification (optionnel)
# destemail = admin@example.com
# sendername = Fail2Ban
# action = %(action_mwl)s

[sshd]
enabled = true
port = XXXXX  # ⚠️ Votre port SSH personnalisé
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

Redémarrer et activer Fail2Ban :

```bash
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban
```

Vérifier le statut :

```bash
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

### Monitoring des tentatives SSH

Surveiller les tentatives d'accès :

```bash
# Voir les dernières tentatives échouées
sudo grep "Failed password" /var/log/auth.log | tail -20

# Voir les IPs bannies
sudo fail2ban-client status sshd
```

---

## 2. Firewall (UFW) - Configuration avancée

### Vérifier la configuration de base

La configuration minimale a été faite dans les prérequis. Vérifier :

```bash
sudo ufw status verbose
```

### Règles avancées (optionnel)

#### Limiter le rate limiting sur SSH

```bash
# Limiter les connexions SSH à 6 par minute
sudo ufw limit XXXXX/tcp comment 'SSH rate limit'
```

#### Bloquer des IPs spécifiques

```bash
# Bloquer une IP (exemple)
sudo ufw deny from 192.0.2.100

# Bloquer une plage d'IPs
sudo ufw deny from 192.0.2.0/24
```

#### Autoriser uniquement certaines IPs pour SSH (optionnel, strict)

```bash
# ⚠️ ATTENTION : Risque de se bloquer soi-même si IP change
# sudo ufw delete allow XXXXX/tcp
# sudo ufw allow from YOUR_IP_ADDRESS to any port XXXXX
```

#### Logging des règles firewall

```bash
# Activer le logging UFW
sudo ufw logging on
sudo ufw logging medium  # ou 'high' pour plus de détails

# Voir les logs
sudo tail -f /var/log/ufw.log
```

### Vérification et audit

```bash
# Voir toutes les règles numérotées
sudo ufw status numbered

# Supprimer une règle par numéro
# sudo ufw delete [NUMERO]

# Voir les règles avec plus de détails
sudo ufw show added
```

> **Note :** Backend et base de données ne doivent être exposés QUE sur les réseaux internes Docker. Aucun port backend ne doit être ouvert sur le firewall.

---

## 3. Mises à jour automatiques

### Installation

```bash
sudo apt install unattended-upgrades apt-listchanges -y
```

### Configuration

```bash
sudo dpkg-reconfigure -plow unattended-upgrades
```

Vérifier la configuration :

```bash
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

Configuration recommandée :

```
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";  # Mettre à true si souhaité
```

---

## 4. Gestion avancée des journaux (Logging)

### Vérifier la configuration journald de base

La configuration minimale a été faite dans les prérequis. Vérifier :

```bash
sudo cat /etc/systemd/journald.conf | grep -E "SystemMaxUse|MaxRetentionSec"
```

### Logrotate - Configuration détaillée pour Nginx

Installer logrotate si ce n'est pas déjà fait :

```bash
sudo apt install logrotate -y
```

Créer/modifier la configuration pour Nginx :

```bash
sudo nano /etc/logrotate.d/nginx
```

Configuration recommandée :

```
/var/log/nginx/*.log {
    daily
    missingok
    rotate 30  # Garder 30 jours (RGPD)
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        if [ -f /var/run/nginx.pid ]; then
            kill -USR1 `cat /var/run/nginx.pid`
        fi
    endscript
}
```

### Logrotate - Configuration pour l'application

Créer une configuration pour les logs LexOrbital :

```bash
sudo nano /etc/logrotate.d/lexorbital
```

Configuration :

```
/var/log/lexorbital/*.log {
    daily
    missingok
    rotate 30  # 30 jours
    compress
    delaycompress
    notifempty
    create 0640 lexorbital lexorbital
    sharedscripts
    postrotate
        # Relancer les services si nécessaire
        # systemctl reload lexorbital-backend
    endscript
}
```

### Logrotate - Configuration pour Docker

```bash
sudo nano /etc/logrotate.d/docker
```

Configuration :

```
/var/lib/docker/containers/*/*.log {
    daily
    missingok
    rotate 7  # 7 jours pour les logs Docker
    compress
    delaycompress
    notifempty
    copytruncate
}
```

### Tester la configuration logrotate

```bash
# Test en mode dry-run
sudo logrotate -d /etc/logrotate.conf

# Forcer une rotation de test
sudo logrotate -f /etc/logrotate.d/nginx
```

### Rétention recommandée par type de log

- **Logs de sécurité** (auth.log, fail2ban) : 30 à 90 jours
- **Logs d'application** (Nginx access, app logs) : 30 jours
- **Logs de debugging** : 7 jours maximum
- **Logs Docker** : 7 jours (rotation automatique)

### Audit des logs

Vérifier l'espace disque utilisé par les logs :

```bash
# Taille totale des logs
sudo du -sh /var/log/*

# Logs les plus volumineux
sudo du -h /var/log/* | sort -rh | head -10

# Vérifier la rotation
ls -lh /var/log/nginx/
```

> **RGPD :** Documenter la finalité (sécurité, détection d'incidents) et la durée de rétention dans votre registre RGPD. Les logs sont pseudonymisés (voir configuration Nginx).

---

## 5. Monitoring et alertes

### Monitoring de base

```bash
# Installer des outils de monitoring
sudo apt install htop iotop nethogs -y
```

### Alertes critiques (optionnel)

Configurer des alertes pour :
- Espace disque < 10%
- Charge CPU > 80% pendant 5 minutes
- Tentatives d'authentification SSH échouées
- Services Docker arrêtés

---

## 6. Sauvegardes et tests de restauration

Voir le document [Backup & Recovery](../operations/backup-recovery.md) pour :
- Stratégie de sauvegarde
- Tests de restauration
- Plan de reprise après sinistre (DRP)

---

## Voir aussi

- [Prérequis Serveur](../operations/prerequisites.md)
- [Audit Permissions](./permissions-audit.md)
- [Mesures Techniques RGPD](../compliance/gdpr-technical.md)

---

**Dernière mise à jour :** 2025-12-01

