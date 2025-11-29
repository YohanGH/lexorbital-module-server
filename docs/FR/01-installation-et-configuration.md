# 01 — Installation et configuration (après clone)

Ce document décrit l'installation de LexOrbital après avoir préparé le serveur selon le document `00-serveur-prerequis.md`.

> **⚠️ Document PUBLIC-SAFE :** Les domaines et URLs utilisent `example.com` comme exemple. Remplacez par vos valeurs réelles.

---

## 1. Cloner le module

Connecté en utilisateur non-root :

```bash
cd /srv/lexorbital
git clone https://github.com/your-org/lexorbital-module-server.git
cd lexorbital-module-server
```

---

## 2. Configuration des secrets Docker (si utilisation de Swarm)

Si vous utilisez Docker Swarm pour gérer les secrets de manière sécurisée :

```bash
# Initialiser Swarm (une seule fois)
sudo docker swarm init

# Créer les secrets
echo "db_username" | docker secret create postgres_user -
echo "SECURE_PASSWORD_HERE" | docker secret create postgres_password -
echo "postgresql://db_username:SECURE_PASSWORD_HERE@postgres:5432/myapp_db" | docker secret create database_url -
echo "YOUR_JWT_SECRET_HERE" | docker secret create jwt_secret -
echo "YOUR_API_KEY_HERE" | docker secret create api_key -
```

> **Important :** Remplacez toutes les valeurs d'exemple par vos propres credentials sécurisés.

---

## 3. Configuration du reverse proxy Nginx

Copier la configuration template et l'adapter :

```bash
sudo cp reverse-proxy/nginx/sites-available/example.conf /etc/nginx/sites-available/lexorbital.conf
sudo nano /etc/nginx/sites-available/lexorbital.conf
```

Dans le fichier, remplacer :
- `example.com` → votre domaine réel
- `lexorbital-frontend` / `lexorbital-backend` → noms de vos containers Docker

Activer la configuration :

```bash
sudo ln -s /etc/nginx/sites-available/lexorbital.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## 4. Déploiement initial

### Mode Docker Compose (simple)

```bash
docker compose -f docker/docker-compose.prod.yml up -d
```

### Mode Docker Swarm (avancé)

```bash
docker stack deploy -c docker/docker-compose.prod.yml myapp-stack
```

---

## 5. Vérification du déploiement

```bash
# Vérifier les containers
docker ps

# Vérifier les logs
docker compose logs -f

# Tester les endpoints
curl https://example.com/health
curl https://api.example.com/health
```