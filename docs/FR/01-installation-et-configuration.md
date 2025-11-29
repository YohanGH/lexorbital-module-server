
# Installation et configuration (après clone)

## 1. Cloner le module

Connecté en utilisateur non-root :

```bash
cd /srv/lexorbital
git clone https://github.com/.../lexorbital-module-infra-server.git
cd lexorbital-module-infra-server
```

2. Installer Docker + Docker Compose + Docker Swarm (optionnel)
Ajouter le dépôt Docker :

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Installer Docker :

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Activer Docker Swarm (optionnel)

```bash
sudo docker swarm init
```

3. Préparer les secrets (mode Swarm)

```bash
echo "postgres_user" | docker secret create postgres_user -
echo "PASSWORD_SECURISE" | docker secret create postgres_password -
echo "postgresql://postgres_user:PASSWORD_SECURISE@postgres:5432/lexorbital" | docker secret create database_url -
echo "JWTSECRET" | docker secret create jwt_secret -
echo "APIKEY" | docker secret create api_key -
etc
```

4. Installer le webhook (si utilisé)
Voir docs/05-webhook-setup.md.

5. Configuration du reverse proxy
Choisir Nginx (prod)
Copier le fichier :

```bash
sudo cp nginx/lexorbital.conf /etc/nginx/sites-available/lexorbital.conf
sudo ln -s /etc/nginx/sites-available/lexorbital.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

Ou utiliser Caddy (exemple)
Voir caddy/Caddyfile.example.

6. Déploiement initial
Mode Compose

```bash
./scripts/deploy-compose.sh
```
Mode Swarm

```bash
./scripts/deploy-swarm.sh
```