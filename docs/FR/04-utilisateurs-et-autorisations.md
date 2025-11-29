# 04 — Utilisateurs système et autorisations détaillées

Ce document décrit la **gestion avancée des permissions** et l'audit de sécurité pour LexOrbital.

> **⚠️ Prérequis :** L'utilisateur système `lexorbital` a été créé dans `00-serveur-prerequis.md`.
> 
> **⚠️ Principe de sécurité :** Principe de moindre privilège strictement appliqué.

---

## 1. Principe de sécurité

- ⛔ **JAMAIS** exécuter sous `root`
- ✅ Tous les services tournent sous compte non-privilégié
- ✅ Isolation des processus par utilisateur système
- ✅ Permissions minimales nécessaires
- ✅ Audit régulier des permissions

---

## 2. Vérification de l'utilisateur système

Vérifier que l'utilisateur `lexorbital` existe et est correctement configuré :

```bash
# Vérifier l'utilisateur
id lexorbital

# Vérifier le shell (doit être /usr/sbin/nologin)
getent passwd lexorbital

# Vérifier le groupe
groups lexorbital
```

Si l'utilisateur n'existe pas, le créer selon `00-serveur-prerequis.md`.

---

## 3. Gestion des groupes

### Vérifier l'appartenance au groupe Docker

```bash
# Vérifier si lexorbital est dans le groupe docker
groups lexorbital

# Si absent, ajouter
sudo usermod -aG docker lexorbital
```

### Recharger les groupes (si modification)

```bash
# Pour la session courante
newgrp docker

# Ou se déconnecter/reconnecter
```

### Créer des groupes supplémentaires si nécessaire

```bash
# Exemple : groupe pour les backups
sudo groupadd lexorbital-backup
sudo usermod -aG lexorbital-backup lexorbital
```

---

## 4. Utilisation de l'utilisateur système

### Se connecter en tant qu'utilisateur système (debug)

```bash
sudo su -s /bin/bash lexorbital
```

### Exécuter une commande unique

```bash
sudo -u lexorbital docker ps
sudo -u lexorbital git pull
```

### Sortir de la session

```bash
exit
```

---

## 5. Permissions détaillées des fichiers sensibles

### Structure de répertoires recommandée

```bash
# Répertoire principal
/srv/lexorbital/
├── .env                    # 600 - Secrets
├── .env.example            # 644 - Template
├── docker-compose.yml      # 640 - Configuration
├── scripts/                # 750 - Scripts exécutables
│   └── *.sh               # 750 - Scripts individuels
└── config/                 # 750 - Configurations
```

### Fichiers de configuration sensibles

```bash
# Fichiers .env avec secrets (RGPD)
sudo chown lexorbital:lexorbital /srv/lexorbital/.env
sudo chmod 600 /srv/lexorbital/.env

# Vérifier qu'il n'y a pas de .env world-readable
find /srv/lexorbital -name ".env*" -perm /o+r -ls
```

### Scripts d'application

```bash
# Répertoire scripts
sudo chown -R lexorbital:lexorbital /srv/lexorbital/scripts
sudo chmod 750 /srv/lexorbital/scripts
sudo chmod 750 /srv/lexorbital/scripts/*.sh

# S'assurer qu'aucun script n'est world-writable
find /srv/lexorbital/scripts -type f -perm /o+w -ls
```

### Logs

```bash
# Créer le répertoire de logs
sudo mkdir -p /var/log/lexorbital
sudo chown lexorbital:lexorbital /var/log/lexorbital
sudo chmod 750 /var/log/lexorbital

# Logs individuels
sudo touch /var/log/lexorbital/app.log
sudo touch /var/log/lexorbital/backup.log
sudo chown lexorbital:lexorbital /var/log/lexorbital/*.log
sudo chmod 640 /var/log/lexorbital/*.log
```

### Backups

```bash
# Répertoire de backups
sudo mkdir -p /var/backups/lexorbital
sudo chown lexorbital:lexorbital /var/backups/lexorbital
sudo chmod 750 /var/backups/lexorbital

# Backups individuels (créés par les scripts)
# Les permissions seront héritées du répertoire parent
```

### Certificats SSL (si stockés localement)

```bash
# Si vous stockez des certificats en dehors de Let's Encrypt
sudo mkdir -p /etc/ssl/lexorbital
sudo chown root:lexorbital /etc/ssl/lexorbital
sudo chmod 750 /etc/ssl/lexorbital

# Certificats individuels
sudo chmod 640 /etc/ssl/lexorbital/*.pem
sudo chown root:lexorbital /etc/ssl/lexorbital/*.pem
```

---

## 6. Isolation des containers Docker

Dans le `docker-compose.yml`, spécifier l'utilisateur :

```yaml
services:
  backend:
    user: "1000:1000"  # UID:GID de l'utilisateur lexorbital
    # ou
    user: "lexorbital:lexorbital"
```

Vérifier l'UID/GID :

```bash
id lexorbital
```

---

## 7. Audit complet des permissions

### Script d'audit automatique

Le script d'audit est disponible dans le dépôt :

```bash
# Copier le script depuis le dépôt
sudo cp /srv/lexorbital/lexorbital-module-server/scripts/audit-permissions.sh /usr/local/bin/lexorbital-audit-permissions.sh

# Rendre exécutable
sudo chmod 755 /usr/local/bin/lexorbital-audit-permissions.sh

# Tester le script
sudo /usr/local/bin/lexorbital-audit-permissions.sh
```

Le script vérifie automatiquement :
- Fichiers et répertoires world-writable (CRITIQUE)
- Fichiers sensibles world-readable (.env, .key, .pem)
- Ownership incorrecte (fichiers n'appartenant pas à lexorbital)
- Group ownership incorrecte
- Fichiers avec setuid/setgid
- Répertoires avec sticky bit
- Permissions des logs et backups

Les résultats sont enregistrés dans `/var/log/lexorbital/audit.log`.

### Commandes d'audit manuel

#### Vérifier les fichiers avec permissions trop larges

```bash
# Fichiers world-writable (CRITIQUE - ne devrait rien retourner)
find /srv/lexorbital -type f -perm /o+w -ls

# Répertoires world-writable (CRITIQUE)
find /srv/lexorbital -type d -perm /o+w -ls

# Fichiers world-readable (à vérifier selon sensibilité)
find /srv/lexorbital -type f -perm /o+r -ls
```

#### Vérifier l'ownership

```bash
# Fichiers n'appartenant pas à lexorbital
find /srv/lexorbital ! -user lexorbital -ls

# Fichiers n'appartenant pas au groupe lexorbital
find /srv/lexorbital ! -group lexorbital -ls
```

#### Vérifier les permissions des fichiers sensibles

```bash
# Fichiers .env
ls -la /srv/lexorbital/.env*

# Scripts
ls -la /srv/lexorbital/scripts/

# Logs
ls -la /var/log/lexorbital/

# Backups
ls -la /var/backups/lexorbital/
```

### Audit des logs et backups

```bash
# Vérifier les permissions des logs
find /var/log/lexorbital -type f ! -perm 640 -ls

# Vérifier les permissions des backups
find /var/backups/lexorbital -type f ! -perm 640 -ls
```

### Automatiser l'audit (cron)

Une fois le script installé dans `/usr/local/bin/lexorbital-audit-permissions.sh`, ajouter à la crontab :

```bash
sudo crontab -u lexorbital -e
```

Ajouter la ligne :

```
# Audit des permissions hebdomadaire (dimanche 3h du matin)
0 3 * * 0 /usr/local/bin/lexorbital-audit-permissions.sh
```

> **Note :** Le script gère déjà son propre logging dans `/var/log/lexorbital/audit.log`.

---

## 8. Checklist de sécurité complète

### Utilisateur système

- [ ] Utilisateur `lexorbital` créé avec shell `/usr/sbin/nologin`
- [ ] Utilisateur dans le groupe `docker`
- [ ] Home directory : `/srv/lexorbital` avec permissions 750
- [ ] Ownership correcte sur `/srv/lexorbital`

### Permissions fichiers

- [ ] Fichiers `.env` en mode 600 (owner: lexorbital)
- [ ] Scripts en mode 750 (owner: lexorbital)
- [ ] Fichiers de configuration en mode 640
- [ ] Aucun fichier world-writable dans `/srv/lexorbital`
- [ ] Aucun fichier world-readable sensible (`.env`, `.key`, `.pem`)

### Logs et backups

- [ ] Répertoire `/var/log/lexorbital` créé avec permissions 750
- [ ] Logs individuels en mode 640 (owner: lexorbital)
- [ ] Répertoire `/var/backups/lexorbital` créé avec permissions 750
- [ ] Backups avec permissions restrictives

### Containers Docker

- [ ] Containers configurés avec `user: "lexorbital:lexorbital"` ou UID/GID
- [ ] Aucun container exécuté sous root
- [ ] Volumes montés avec ownership correcte

### Audit

- [ ] Script d'audit créé et testé
- [ ] Audit automatique configuré (cron hebdomadaire)
- [ ] Aucun fichier avec setuid/setgid inattendu
- [ ] Tous les fichiers appartiennent à lexorbital ou root (selon besoin)

### Actions correctives

Si l'audit révèle des problèmes :

```bash
# Corriger l'ownership
sudo chown -R lexorbital:lexorbital /srv/lexorbital

# Corriger les permissions
sudo find /srv/lexorbital -type f -perm /o+w -exec chmod o-w {} \;
sudo find /srv/lexorbital -type d -perm /o+w -exec chmod o-w {} \;

# Corriger les fichiers sensibles
sudo chmod 600 /srv/lexorbital/.env
sudo chmod 640 /var/log/lexorbital/*.log
```