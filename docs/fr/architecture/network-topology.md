# Topologie Réseau

> **Architecture réseau et sécurité** de LexOrbital Module Server.

---

## 🎯 Objectif

Documenter la topologie réseau Docker, l'isolation des zones de sécurité et les flux de communication.

---

## 🌐 Réseaux Docker

### Réseaux Créés

- **frontend-network** : Containers frontend
- **backend-network** : Containers backend
- **database-network** : Containers base de données

### Isolation

Chaque réseau est isolé pour :
- Séparer les zones de sécurité
- Limiter la surface d'attaque
- Respecter le principe de moindre privilège

---

## 🔄 Flux de Communication

### Requête HTTP/HTTPS

```
Internet → Nginx (Hôte) → frontend-network → Container Frontend
```

### Communication Backend

```
Container Frontend → backend-network → Container Backend
```

### Accès Base de Données

```
Container Backend → database-network → Container Database
```

---

## 🔒 Sécurité Réseau

### Pare-feu UFW

- Ports ouverts : SSH, HTTP (80), HTTPS (443)
- Tous les autres ports fermés par défaut
- Règles spécifiques selon besoins

### Isolation Containers

- Pas d'exposition directe des ports sensibles
- Communication inter-containers uniquement via réseaux Docker
- Reverse proxy comme seul point d'entrée

---

## 📊 Schémas

Voir les diagrammes dans [diagrams/](./diagrams/README.md) pour des représentations visuelles.

---

## 📖 Voir Aussi

- [Architecture Système](./system-design.md) - Vue d'ensemble
- [Infrastructure](./infrastructure.md) - Stack technique
- [Configuration SSH](../security/ssh-configuration.md) - Sécurité SSH
- [Règles Firewall](../security/firewall-rules.md) - Configuration UFW
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

