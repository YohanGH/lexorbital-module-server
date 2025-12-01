# Déployer une Application

> **Guide pour déployer une application** avec LexOrbital Module Server.

---

## 🎯 Objectif

Apprendre à déployer une application en utilisant Docker Compose ou Docker Swarm.

---

## 📋 Prérequis

- Serveur configuré selon [Prérequis](../operations/prerequisites.md)
- Application conteneurisée
- Accès au serveur

---

## 🐳 Docker Compose

### 1. Préparer docker-compose.yml

Créer ou adapter le fichier `docker-compose.yml` :

```yaml
version: '3.8'

services:
  app:
    image: your-app:latest
    networks:
      - frontend-network
    restart: unless-stopped
```

### 2. Déployer

```bash
docker compose up -d
```

### 3. Vérifier

```bash
docker compose ps
docker compose logs -f
```

---

## 🐝 Docker Swarm

### 1. Initialiser Swarm

```bash
docker swarm init
```

### 2. Déployer Stack

```bash
docker stack deploy -c docker-compose.yml myapp
```

### 3. Vérifier

```bash
docker stack services myapp
docker stack ps myapp
```

---

## 🔄 Mise à Jour

### Docker Compose

```bash
docker compose pull
docker compose up -d
```

### Docker Swarm

```bash
docker service update --image your-app:new-version myapp_app
```

---

## 📖 Voir Aussi

- [Déploiement](../operations/deployment.md) - Documentation complète
- [Reverse Proxy](../operations/reverse-proxy.md) - Configuration Nginx
- [Dépannage](./troubleshooting.md) - Résolution problèmes
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

