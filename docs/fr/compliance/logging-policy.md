# Politique de Journalisation

> **Politique de journalisation et pseudonymisation** conforme RGPD.

---

## 🎯 Objectif

Définir les règles de journalisation pour garantir la conformité RGPD tout en conservant les capacités de monitoring et de sécurité.

---

## 📜 Principes RGPD

### Minimisation des Données

- Collecte uniquement des données nécessaires
- Pas de tracking inutile
- Logs minimaux par défaut

### Pseudonymisation

- Masquage des IPs dans logs Nginx
- Identifiants anonymisés
- Séparation données personnelles/opérationnelles

### Rétention Limitée

- Rétention par défaut : 30 jours
- Rotation automatique des logs
- Suppression après expiration

---

## 📋 Configuration Logs

### Systemd Journald

**Fichier :** `/etc/systemd/journald.conf`

```ini
SystemMaxUse=200M
SystemMaxFileSize=20M
MaxRetentionSec=2592000  # 30 jours
```

### Nginx Logs

**Masquage IP :** Configuration dans `nginx.conf`

```nginx
log_format masked '$remote_addr_masked - $remote_user [$time_local] '
                  '"$request" $status $body_bytes_sent '
                  '"$http_referer" "$http_user_agent"';
```

**Rotation :** Via logrotate

---

## 🔍 Types de Logs

### Logs Système

- Journald : logs système et services
- Rétention : 30 jours
- Rotation automatique

### Logs Application

- Logs Docker : via `docker compose logs`
- Rétention : selon configuration application
- Pas de données personnelles dans logs

### Logs Nginx

- Accès : format pseudonymisé
- Erreurs : minimales
- Rétention : 30 jours

---

## 🔐 Protection des Logs

### Intégrité

- Logs en lecture seule après écriture
- Protection contre altération
- Audit trail des accès

### Confidentialité

- Accès restreint aux logs
- Chiffrement recommandé pour logs sensibles
- Pas de logs de secrets ou mots de passe

---

## 📊 Monitoring

### Surveillance

- Monitoring des logs pour anomalies
- Alertes sur erreurs critiques
- Pas de tracking utilisateur

### Analyse

- Analyse agrégée uniquement
- Pas de profilage individuel
- Statistiques anonymisées

---

## 📖 Voir Aussi

- [Vue d'Ensemble Conformité](./overview.md) - Conformité générale
- [Mesures Techniques RGPD](./gdpr-technical.md) - Article 32
- [Rétention des Données](./data-retention.md) - Politiques de rétention
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

