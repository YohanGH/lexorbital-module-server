# Mesures Techniques RGPD

> **Mesures techniques de sécurité** conformes à l'article 32 du RGPD.

Ce document décrit les mesures techniques mises en place pour garantir la sécurité des données personnelles conformément à l'article 32 du RGPD.

> **⚠️ Document PUBLIC-SAFE :** Les exemples utilisent des valeurs génériques. Adaptez selon votre contexte.

---

## 1. Contexte Réglementaire

L'article 32 du RGPD impose la mise en place de **mesures techniques et organisationnelles appropriées** pour garantir la sécurité des données personnelles.

**Objectifs :**
- Protection contre la perte, la destruction ou l'altération accidentelle
- Protection contre l'accès non autorisé
- Confidentialité, intégrité et disponibilité des données

---

## 2. Chiffrement des Données

### Chiffrement en Transit (TLS)

- ✅ **TLS 1.2+** obligatoire pour toutes les communications
- ✅ **HSTS** activé pour forcer HTTPS
- ✅ Certificats Let's Encrypt avec renouvellement automatique
- ✅ Configuration stricte des ciphers (désactivation des protocoles obsolètes)

Voir [Configuration Reverse Proxy](../operations/reverse-proxy.md) pour les détails de configuration.

### Chiffrement au Repos

- ✅ **Base de données** : Chiffrement des volumes Docker
- ✅ **Backups** : Chiffrement des sauvegardes avant stockage
- ✅ **Secrets** : Utilisation de Docker Secrets (Swarm) ou variables d'environnement sécurisées

---

## 3. Politique de Journalisation

### Données Loggées

Les logs contiennent uniquement :
- **IP tronquée** (IPv4 /24, IPv6 /64) - pseudonymisation
- Timestamp
- Requête HTTP
- Code de réponse HTTP
- Bytes envoyés

### Pseudonymisation des IPs

Configuration Nginx pour tronquer les IPs :

```nginx
# Troncature IPv4 (masquer les 8 derniers bits)
log_format pseudonymized '$remote_addr_masked $time_local "$request" $status $body_bytes_sent';

# Script de masquage (à intégrer dans la configuration)
map $remote_addr $remote_addr_masked {
    ~^(\d+\.\d+\.\d+)\. $1.0;
    default 0.0.0.0;
}
```

### Durée de Rétention

- **Logs de sécurité** (auth.log, fail2ban) : 30 à 90 jours
- **Logs d'application** (Nginx access, app logs) : 30 jours
- **Logs de debugging** : 7 jours maximum
- **Logs Docker** : 7 jours (rotation automatique)

Voir [Durcissement Sécurité](../security/hardening.md) pour la configuration logrotate.

### Finalité des Logs

**Finalité documentée :**
- Détection d'incidents de sécurité
- Diagnostic technique
- Conformité légale (Article 32 RGPD)

**Accès aux logs :**
- Accès restreint à l'utilisateur système `lexorbital`
- Permissions : 640 (owner: lexorbital, group: lexorbital)
- Audit régulier des accès

---

## 4. Isolation Réseau

### Architecture Réseau Docker

- ✅ **Réseaux séparés** : `frontend-network`, `backend-network`, `database-network`
- ✅ **Réseau database** : `internal: true` (pas d'accès Internet)
- ✅ **Backend** : Accessible uniquement via reverse proxy
- ✅ **Base de données** : Accessible uniquement depuis le backend

### Pare-feu Système (UFW)

- ✅ Politique par défaut : DENY
- ✅ Ports ouverts uniquement pour services essentiels (SSH, HTTPS)
- ✅ Aucun port backend/database exposé directement

Voir [Durcissement Sécurité](../security/hardening.md) pour les détails.

---

## 5. Sauvegardes et Restauration

### Stratégie de Sauvegarde

- ✅ **Sauvegardes quotidiennes** de la base de données
- ✅ **Sauvegardes hebdomadaires** des fichiers
- ✅ **Chiffrement** des sauvegardes avant stockage
- ✅ **Tests de restauration** mensuels

Voir [Backup & Recovery](../operations/backup-recovery.md) pour les détails.

### Rétention des Sauvegardes

- **Sauvegardes quotidiennes** : 7 jours
- **Sauvegardes hebdomadaires** : 4 semaines
- **Sauvegardes mensuelles** : 12 mois

---

## 6. Gestion des Accès

### Principe de Moindre Privilège

- ✅ **Utilisateur système** : `lexorbital` (non-root)
- ✅ **Containers Docker** : Exécution sous utilisateur non-privilégié
- ✅ **Permissions fichiers** : Mode 600 pour secrets, 640 pour configs
- ✅ **Audit régulier** des permissions

Voir [Audit Permissions](../security/permissions-audit.md) pour les détails.

### Authentification et Autorisation

- ✅ **SSH** : Clés publiques uniquement (pas de mots de passe)
- ✅ **Fail2Ban** : Protection contre les attaques par force brute
- ✅ **Secrets Docker** : Gestion sécurisée via Docker Swarm

---

## 7. Documentation et Traçabilité

### Registre des Traitements

Documenter dans votre registre RGPD :
- **Finalité** : Hébergement et traitement des données
- **Base légale** : Consentement / Exécution contrat
- **Durée de conservation** : Conforme aux politiques de rétention
- **Mesures techniques** : Référence à ce document

### Audit et Contrôles

- ✅ **Audit mensuel** des permissions
- ✅ **Audit trimestriel** des logs
- ✅ **Tests de restauration** mensuels
- ✅ **Revue annuelle** de la conformité

---

## 8. Mesures Organisationnelles

### Formation et Sensibilisation

- Formation de l'équipe sur les bonnes pratiques RGPD
- Documentation accessible à tous les membres de l'équipe
- Procédures d'incident documentées

### Gestion des Incidents

- Procédure de notification en cas de violation de données
- Plan de réponse aux incidents
- Documentation des incidents et mesures correctives

---

## 9. Conformité avec les Standards

### Standards Appliqués

- ✅ **OWASP Top 10** : Protection contre les vulnérabilités courantes
- ✅ **Recommandations ANSSI** : Durcissement serveur
- ✅ **CNIL** : Privacy by design et by default

Voir [Standards de Sécurité](./security-standards.md) pour les détails.

---

## 10. Révision et Mise à Jour

Ce document doit être révisé :
- **Annuellement** : Révision complète
- **Lors de changements** : Mise à jour lors de modifications techniques
- **Après incidents** : Mise à jour suite à un incident de sécurité

---

## Voir aussi

- [Vue d'ensemble Conformité](./overview.md)
- [Standards de Sécurité](./security-standards.md)
- [Durcissement Sécurité](../security/hardening.md)
- [Backup & Recovery](../operations/backup-recovery.md)

---

**Dernière mise à jour :** 2025-12-01
**Version :** 1.0.0
