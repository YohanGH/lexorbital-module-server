# Scripts utilitaires LexOrbital

Ce dossier contient les scripts utilitaires pour la maintenance et l'audit de LexOrbital.

---

## 📋 Scripts disponibles

### `audit-permissions.sh`

Script d'audit automatique des permissions de sécurité.

**Usage :**

```bash
# Depuis le dépôt
./scripts/audit-permissions.sh

# Ou après installation
/usr/local/bin/lexorbital-audit-permissions.sh
```

**Installation :**

```bash
# Copier le script
sudo cp scripts/audit-permissions.sh /usr/local/bin/lexorbital-audit-permissions.sh

# Rendre exécutable
sudo chmod 755 /usr/local/bin/lexorbital-audit-permissions.sh
```

**Ce que le script vérifie :**

- ✅ Fichiers et répertoires world-writable (CRITIQUE)
- ✅ Fichiers sensibles world-readable (.env, .key, .pem)
- ✅ Ownership incorrecte (fichiers n'appartenant pas à lexorbital)
- ✅ Group ownership incorrecte
- ✅ Fichiers avec setuid/setgid
- ✅ Répertoires avec sticky bit
- ✅ Permissions des logs et backups

**Sortie :**

- Affichage console avec codes couleur (✅/⚠️)
- Log automatique dans `/var/log/lexorbital/audit.log`
- Code de sortie : `0` si OK, `1` si problèmes détectés

**Automatisation (cron) :**

```bash
# Ajouter à la crontab de lexorbital
sudo crontab -u lexorbital -e

# Audit hebdomadaire (dimanche 3h du matin)
0 3 * * 0 /usr/local/bin/lexorbital-audit-permissions.sh
```

---

### `configure-server.sh`

Script de configuration et vérification du serveur. Configure les sources APT, vérifie et installe les outils de sécurité nécessaires.

**Usage :**

```bash
# Depuis le dépôt
sudo ./scripts/configure-server.sh

# Ou après installation
sudo /usr/local/bin/lexorbital-configure-server.sh
```

**Installation :**

```bash
# Copier le script
sudo cp scripts/configure-server.sh /usr/local/bin/lexorbital-configure-server.sh

# Rendre exécutable
sudo chmod 755 /usr/local/bin/lexorbital-configure-server.sh
```

**Ce que le script fait :**

- ✅ Vérifie et ajoute le dépôt backports Debian si absent
- ✅ Vérifie et installe les packages de sécurité (apt-transport-https, gnupg, etc.)
- ✅ Vérifie la configuration des clés GPG APT
- ✅ Vérifie le support HTTPS pour les sources
- ✅ Affiche un résumé des changements effectués

**Configuration :**

Le script peut être configuré via variables d'environnement :

```bash
# Version Debian (par défaut: stretch)
export DEBIAN_RELEASE="stretch"

# Fichier sources.list (par défaut: /etc/apt/sources.list)
export SOURCES_LIST="/etc/apt/sources.list"
```

**Sortie :**

- Affichage console avec codes couleur (✅/⚠️)
- Log automatique dans `/var/log/lexorbital/server-config.log`
- Code de sortie : `0` si OK

**Note :** Ce script doit être exécuté en tant que `root` (avec `sudo`).

---

### `update-server.sh`

Script de mise à jour automatique du serveur. Effectue les mises à jour de sécurité et de distribution, puis nettoie les packages inutilisés.

**Usage :**

```bash
# Depuis le dépôt
sudo ./scripts/update-server.sh

# Mode dry-run (simulation sans modifications)
sudo ./scripts/update-server.sh --dry-run

# Ou après installation
sudo /usr/local/bin/lexorbital-update-server.sh
```

**Installation :**

```bash
# Copier le script
sudo cp scripts/update-server.sh /usr/local/bin/lexorbital-update-server.sh

# Rendre exécutable
sudo chmod 755 /usr/local/bin/lexorbital-update-server.sh
```

**Ce que le script fait :**

- ✅ Met à jour les listes de packages (`apt-get update`)
- ✅ Vérifie les mises à jour disponibles
- ✅ Effectue la mise à jour de distribution (`apt-get dist-upgrade`)
- ✅ Supprime les packages inutilisés (`apt-get purge --autoremove`)
- ✅ Nettoie le cache des packages (`apt-get clean`)

**Sortie :**

- Affichage console avec codes couleur (✅/⚠️)
- Log automatique dans `/var/log/lexorbital/update.log`
- Code de sortie : `0` si OK, `1` si erreurs

**Automatisation (cron) :**

```bash
# Ajouter à la crontab root
sudo crontab -e

# Mise à jour hebdomadaire (dimanche 4h du matin)
0 4 * * 0 /usr/local/bin/lexorbital-update-server.sh >> /var/log/lexorbital/update.log 2>&1
```

**Note :** Ce script doit être exécuté en tant que `root` (avec `sudo`).

---

## 📚 Documentation

Pour plus de détails sur l'utilisation et la configuration, voir :

- `docs/FR/04-utilisateurs-et-autorisations.md` - Gestion des permissions
- `docs/FR/03-renforcement-de-la-securite.md` - Durcissement serveur

---

## 🔒 Sécurité

Tous les scripts doivent être :
- Exécutables uniquement par l'utilisateur `lexorbital` ou `root`
- Permissions : `750` (rwxr-x---)
- Ownership : `lexorbital:lexorbital`

Vérifier les permissions :

```bash
ls -la scripts/
```

