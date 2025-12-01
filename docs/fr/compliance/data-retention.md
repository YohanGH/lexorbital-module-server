# Rétention des Données

> **Politique de rétention et suppression des données** conforme RGPD.

---

## 🎯 Objectif

Définir les durées de conservation des données et les procédures de suppression pour garantir la conformité RGPD.

---

## 📜 Principes RGPD

### Article 5(1)(e) - Limitation de la Conservation

Les données personnelles doivent être conservées **uniquement le temps nécessaire** aux finalités pour lesquelles elles sont traitées.

### Minimisation

- Collecte minimale de données
- Rétention limitée dans le temps
- Suppression automatique après expiration

---

## 📋 Durées de Rétention

### Logs Système

- **Durée :** 30 jours
- **Rotation :** Automatique (journald)
- **Suppression :** Automatique après expiration

### Logs Nginx

- **Durée :** 30 jours
- **Rotation :** Via logrotate
- **Suppression :** Automatique après expiration

### Logs Application

- **Durée :** Selon configuration application
- **Rotation :** Selon configuration
- **Suppression :** Selon politique application

### Sauvegardes

- **Durée :** 90 jours (rotation)
- **Conservation :** 3 générations
- **Suppression :** Automatique après expiration

---

## 🔄 Procédures de Suppression

### Suppression Automatique

- Logs système : rotation automatique via journald
- Logs Nginx : rotation automatique via logrotate
- Sauvegardes : rotation automatique via scripts

### Suppression Manuelle

En cas de demande d'exercice de droit à l'oubli :

1. Identifier les données concernées
2. Vérifier les obligations légales de conservation
3. Supprimer les données si autorisé
4. Documenter la suppression

---

## 📊 Tableau Récapitulatif

| Type de Données | Durée de Rétention | Méthode de Suppression |
|-----------------|-------------------|------------------------|
| Logs système | 30 jours | Automatique (journald) |
| Logs Nginx | 30 jours | Automatique (logrotate) |
| Logs application | Variable | Selon configuration |
| Sauvegardes DB | 90 jours | Automatique (scripts) |
| Sauvegardes fichiers | 90 jours | Automatique (scripts) |

---

## 🔐 Sécurité de la Suppression

### Méthodes

- Suppression logique : suppression des fichiers
- Suppression sécurisée : écrasement (optionnel)
- Vérification : logs de suppression

### Audit

- Traçabilité des suppressions
- Logs d'audit conservés
- Documentation des procédures

---

## 📖 Voir Aussi

- [Vue d'Ensemble Conformité](./overview.md) - Conformité générale
- [Politique de Journalisation](./logging-policy.md) - Logs et pseudonymisation
- [Mesures Techniques RGPD](./gdpr-technical.md) - Article 32
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

