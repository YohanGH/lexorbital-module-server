# Guide de déploiement LexOrbital

## 1. Déploiement via Docker Compose

```bash
cd docker
./../scripts/deploy-compose.sh
```
Ce script :
arrête les containers existants,
pull les nouvelles images,
relance les services.

## 2. Déploiement via Docker Swarm

```bash
cd docker
./../scripts/deploy-swarm.sh
```

Avantages Swarm :
secrets natifs,
rolling updates,
limites CPU/Mémoire réellement appliquées,
haute disponibilité si plusieurs nodes.

3. Mise à jour
Mettre à jour le repo :
```bash
git pull
```
Puis relancer le script :
```bash
./scripts/deploy-compose.sh
```
ou
```bash
./scripts/deploy-swarm.sh
```