# Backup & Recovery (Plan de Reprise)

> **Stratégie de sauvegarde et plan de reprise après sinistre** pour LexOrbital Module Server.

Ce document décrit la stratégie de sauvegarde, les procédures de restauration et le plan de reprise après sinistre (DRP).

> **⚠️ Document PUBLIC-SAFE :** Les exemples utilisent des valeurs génériques. Adaptez selon votre environnement.

---

## 1. Objectifs du Plan de Reprise

### RTO (Recovery Time Objective)

- **Objectif** : Rétablissement du service en moins de 4 heures
- **Critique** : Services essentiels en moins de 2 heures

### RPO (Recovery Point Objective)

- **Objectif** : Perte de données maximale de 24 heures
- **Critique** : Perte de données maximale de 1 heure

---

## 2. Stratégie de Sauvegarde

### Types de Sauvegardes

#### Sauvegardes Quotidiennes

- **Base de données** : Dump PostgreSQL quotidien
- **Horaires** : 2h du matin (faible charge)
- **Rétention** : 7 jours

#### Sauvegardes Hebdomadaires

- **Base de données** : Dump complet
- **Fichiers** : Répertoires applicatifs
- **Configuration** : Fichiers de configuration
- **Rétention** : 4 semaines

#### Sauvegardes Mensuelles

- **Archive complète** : Base de données + fichiers + configuration
- **Rétention** : 12 mois
- **Stockage** : Archivage externe (optionnel)

---

## 3. Scripts de Sauvegarde

Le module fournit des scripts de sauvegarde dans le répertoire `backup/`.

### Sauvegarde Base de Données

```bash
# Script de sauvegarde DB
./backup/backup-db.sh

# Options disponibles
./backup/backup-db.sh --daily    # Sauvegarde quotidienne
./backup/backup-db.sh --weekly   # Sauvegarde hebdomadaire
./backup/backup-db.sh --monthly   # Sauvegarde mensuelle
```

### Sauvegarde Fichiers

```bash
# Script de sauvegarde fichiers
./backup/backup-files.sh

# Sauvegarde des répertoires importants
./backup/backup-files.sh /srv/lexorbital
./backup/backup-files.sh /etc/nginx
```

### Vérification des Sauvegardes

```bash
# Script de vérification
./backup/verify-restore.sh

# Vérifier une sauvegarde spécifique
./backup/verify-restore.sh /var/backups/lexorbital/db-2025-12-01.sql.gz
```

---

## 4. Automatisation (Cron)

### Configuration Crontab

```bash
# Éditer la crontab de l'utilisateur lexorbital
sudo crontab -u lexorbital -e
```

### Tâches Programmées

```cron
# Sauvegarde quotidienne DB (2h du matin)
0 2 * * * /srv/lexorbital/lexorbital-module-server/backup/backup-db.sh --daily

# Sauvegarde hebdomadaire complète (dimanche 3h du matin)
0 3 * * 0 /srv/lexorbital/lexorbital-module-server/backup/backup-db.sh --weekly
0 3 * * 0 /srv/lexorbital/lexorbital-module-server/backup/backup-files.sh

# Sauvegarde mensuelle (1er du mois, 4h du matin)
0 4 1 * * /srv/lexorbital/lexorbital-module-server/backup/backup-db.sh --monthly
0 4 1 * * /srv/lexorbital/lexorbital-module-server/backup/backup-files.sh

# Vérification hebdomadaire (dimanche 5h du matin)
0 5 * * 0 /srv/lexorbital/lexorbital-module-server/backup/verify-restore.sh
```

---

## 5. Stockage des Sauvegardes

### Localisation

- **Répertoire principal** : `/var/backups/lexorbital/`
- **Permissions** : 750 (owner: lexorbital, group: lexorbital)
- **Espace disque** : Surveiller régulièrement

### Chiffrement

Les sauvegardes doivent être chiffrées avant stockage externe :

```bash
# Chiffrer une sauvegarde
gpg --encrypt --recipient backup@example.com backup.sql.gz

# Décrypter une sauvegarde
gpg --decrypt backup.sql.gz.gpg > backup.sql.gz
```

### Stockage Externe (Recommandé)

- **Cloud** : AWS S3, Google Cloud Storage, Backblaze B2
- **Serveur distant** : rsync vers serveur de sauvegarde
- **Rotation** : Supprimer les anciennes sauvegardes automatiquement

---

## 6. Procédures de Restauration

### Restauration Base de Données

```bash
# 1. Arrêter l'application
docker compose down

# 2. Restaurer la sauvegarde
gunzip < /var/backups/lexorbital/db-2025-12-01.sql.gz | \
  docker compose exec -T postgres psql -U postgres -d myapp_db

# 3. Vérifier la restauration
docker compose exec postgres psql -U postgres -d myapp_db -c "SELECT COUNT(*) FROM users;"

# 4. Redémarrer l'application
docker compose up -d
```

### Restauration Fichiers

```bash
# 1. Arrêter l'application
docker compose down

# 2. Restaurer les fichiers
tar -xzf /var/backups/lexorbital/files-2025-12-01.tar.gz -C /

# 3. Vérifier les permissions
sudo chown -R lexorbital:lexorbital /srv/lexorbital

# 4. Redémarrer l'application
docker compose up -d
```

### Restauration Complète

```bash
# 1. Arrêter tous les services
docker compose down

# 2. Restaurer la base de données
gunzip < /var/backups/lexorbital/db-2025-12-01.sql.gz | \
  docker compose exec -T postgres psql -U postgres -d myapp_db

# 3. Restaurer les fichiers
tar -xzf /var/backups/lexorbital/files-2025-12-01.tar.gz -C /

# 4. Vérifier la configuration
cat /srv/lexorbital/.env

# 5. Redémarrer les services
docker compose up -d

# 6. Vérifier la santé des services
curl https://example.com/health
```

---

## 7. Tests de Restauration

### Fréquence

- **Tests mensuels** : Restauration sur environnement de test
- **Tests trimestriels** : Restauration complète
- **Tests annuels** : Simulation de sinistre complet

### Procédure de Test

```bash
# 1. Créer un environnement de test
docker compose -f docker-compose.test.yml up -d

# 2. Restaurer la sauvegarde de test
./backup/verify-restore.sh --test

# 3. Vérifier l'intégrité
docker compose -f docker-compose.test.yml exec backend npm test

# 4. Nettoyer l'environnement de test
docker compose -f docker-compose.test.yml down -v
```

---

## 8. Plan de Reprise Après Sinistre (DRP)

### Scénarios de Sinistre

#### Perte de Données (Base de Données)

1. **Identifier** la dernière sauvegarde valide
2. **Arrêter** l'application pour éviter corruption
3. **Restaurer** la base de données depuis sauvegarde
4. **Vérifier** l'intégrité des données
5. **Redémarrer** l'application
6. **Documenter** l'incident

#### Perte de Serveur Complet

1. **Provisionner** un nouveau serveur (voir [Prérequis](../operations/prerequisites.md))
2. **Installer** Docker et dépendances
3. **Restaurer** les fichiers de configuration
4. **Restaurer** la base de données depuis sauvegarde externe
5. **Configurer** le reverse proxy
6. **Redémarrer** les services
7. **Vérifier** la santé des services

#### Corruption de Données

1. **Arrêter** l'application immédiatement
2. **Identifier** la cause de la corruption
3. **Restaurer** depuis la dernière sauvegarde valide
4. **Vérifier** l'intégrité
5. **Redémarrer** l'application
6. **Documenter** et corriger la cause

---

## 9. Monitoring et Alertes

### Surveillance des Sauvegardes

- ✅ Vérifier quotidiennement que les sauvegardes se sont exécutées
- ✅ Vérifier l'espace disque disponible
- ✅ Vérifier l'intégrité des sauvegardes (tests automatiques)

### Alertes

Configurer des alertes pour :
- Échec de sauvegarde
- Espace disque < 20%
- Sauvegarde non exécutée depuis 25 heures
- Erreur lors de la vérification

---

## 10. Documentation et Traçabilité

### Registre des Sauvegardes

Maintenir un registre avec :
- Date et heure de chaque sauvegarde
- Type de sauvegarde (quotidienne/hebdomadaire/mensuelle)
- Taille de la sauvegarde
- Résultat (succès/échec)
- Emplacement de stockage

### Registre des Restaurations

Documenter chaque restauration :
- Date et heure
- Raison de la restauration
- Sauvegarde utilisée
- Durée de la restauration
- Résultat et vérifications

---

## Voir aussi

- [Installation & Configuration](./installation.md)
- [Durcissement Sécurité](../security/hardening.md)
- [Mesures Techniques RGPD](../compliance/gdpr-technical.md)

---

**Dernière mise à jour :** 2025-12-01  
**Version :** 1.0.0

