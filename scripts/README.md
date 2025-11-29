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

