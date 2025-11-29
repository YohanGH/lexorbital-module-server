# 02 — Guide de déploiement LexOrbital

Ce document décrit les différentes stratégies de déploiement de LexOrbital.

> **⚠️ Document PUBLIC-SAFE :** Les commandes utilisent des noms génériques. Adaptez selon votre environnement.

---

## 1. Déploiement via Docker Compose (Mode simple)

### Déploiement initial

```bash
cd docker
docker compose -f docker-compose.prod.yml up -d
```

### Mise à jour de l'application

```bash
# 1. Récupérer les dernières modifications
git pull origin main

# 2. Rebuild les images si nécessaire
docker compose -f docker-compose.prod.yml build

# 3. Redémarrer les services
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d
```

---

## 2. Déploiement via Docker Swarm (Mode avancé)

### Avantages Swarm

- ✅ **Secrets natifs** : Gestion sécurisée des credentials
- ✅ **Rolling updates** : Mises à jour sans interruption
- ✅ **Limites de ressources** : CPU/Mémoire réellement appliquées
- ✅ **Haute disponibilité** : Support multi-nœuds
- ✅ **Orchestration** : Auto-restart et health checks

### Déploiement

```bash
# Initialiser Swarm (une seule fois)
docker swarm init

# Déployer la stack
docker stack deploy -c docker/docker-compose.prod.yml lexorbital-stack
```

### Mise à jour

```bash
# 1. Récupérer les modifications
git pull origin main

# 2. Redéployer (rolling update automatique)
docker stack deploy -c docker/docker-compose.prod.yml lexorbital-stack
```

### Monitoring

```bash
# Voir l'état des services
docker stack services lexorbital-stack

# Voir les logs
docker service logs lexorbital-stack_backend

# Scaler un service
docker service scale lexorbital-stack_backend=3
```

---

## 3. Stratégie de mise à jour recommandée

### Pour les environnements de production

1. **Tester** en environnement de staging
2. **Sauvegarder** la base de données
3. **Créer un tag** Git pour la version
4. **Déployer** avec rolling update (Swarm) ou blue-green
5. **Monitorer** les logs et métriques
6. **Rollback** si nécessaire

### Rollback rapide

```bash
# Docker Compose
git checkout <previous-tag>
docker compose -f docker-compose.prod.yml up -d

# Docker Swarm
docker stack deploy -c docker/docker-compose.prod.yml.backup myapp-stack
```

---

## 4. Checklist avant déploiement

- [ ] Backups à jour
- [ ] Tests passés en staging
- [ ] Variables d'environnement vérifiées
- [ ] Secrets Docker créés
- [ ] Certificats SSL valides
- [ ] Monitoring actif
- [ ] Plan de rollback préparé