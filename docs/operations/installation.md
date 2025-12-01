# Installation et Configuration

> **Installation de LexOrbital Module Server** après préparation du serveur selon les prérequis.

Ce document décrit l'installation de LexOrbital après avoir préparé le serveur selon le document [Prérequis Serveur](./prerequisites.md).

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

## 2. Provisionnement avec Ansible (recommandé)

Ce module inclut une configuration Ansible pour automatiser le provisionnement de base du serveur.

### 2.1. Installation d'Ansible (sur votre machine locale)

**Debian/Ubuntu :**
```bash
sudo apt update
sudo apt install ansible
```

### 2.2. Configuration de l'inventaire

Éditez le fichier d'inventaire pour pointer vers votre serveur :

```bash
cd ansible
nano inventories/prod.ini
```

Remplacez les valeurs d'exemple :
- `ansible_host` : adresse IP ou nom de domaine de votre serveur
- `ansible_user` : utilisateur SSH (root ou utilisateur avec sudo)
- `ansible_port` : port SSH (par défaut 22)

Exemple :
```ini
[servers]
lexorbital-prod ansible_host=192.168.1.100 ansible_user=deploy ansible_port=22
```

### 2.3. Test de connexion

Vérifiez que vous pouvez vous connecter à votre serveur :

```bash
ansible servers -m ping
```

Résultat attendu :
```
lexorbital-prod | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 2.4. Exécution du playbook de provisionnement

Lancez le playbook principal pour provisionner votre serveur :

```bash
ansible-playbook playbooks/site.yml
```

**Ce playbook effectue les actions suivantes :**
- Mise à jour complète du système (`apt upgrade`)
- Installation des paquets essentiels (vim, curl, git, ufw, htop, etc.)
- Configuration du pare-feu UFW (activé, politique par défaut : deny)
- Ouverture du port SSH (22)
- Configuration du fuseau horaire (UTC)

**Résultat attendu :**
```
PLAY RECAP *********************************************************************
lexorbital-prod : ok=5    changed=3    unreachable=0    failed=0    skipped=0
```

### 2.5. Vérification du provisionnement

Connectez-vous au serveur et vérifiez l'état :

```bash
ssh deploy@192.168.1.100

# Vérifier UFW
sudo ufw status

# Vérifier les paquets installés
which vim git curl htop
```

> **Note :** Pour provisionner en mode dry-run (sans appliquer les changements), ajoutez `--check` :
> ```bash
> ansible-playbook playbooks/site.yml --check
> ```

Pour plus de détails sur le provisionnement Ansible, voir [Provisionnement Ansible](./ansible-provisioning.md).

---

## 3. Configuration des secrets Docker (si utilisation de Swarm)

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

## 4. Configuration du reverse proxy Nginx

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

Pour plus de détails sur la configuration du reverse proxy, voir [Configuration Reverse Proxy](./reverse-proxy.md).

---

## 5. Déploiement initial

### Mode Docker Compose (simple)

```bash
docker compose -f docker/docker-compose.prod.yml up -d
```

### Mode Docker Swarm (avancé)

```bash
docker stack deploy -c docker/docker-compose.prod.yml myapp-stack
```

Pour plus de détails sur les stratégies de déploiement, voir [Guide de Déploiement](./deployment.md).

---

## 6. Vérification du déploiement

```bash
# Vérifier les containers
docker ps

# Vérifier les logs
docker compose logs -f

# Tester les endpoints
curl https://example.com/health
curl https://api.example.com/health
```

---

## Prochaines Étapes

Après l'installation de base :

1. **Durcissement sécurité** → [Durcissement Sécurité](../security/hardening.md)
2. **Audit des permissions** → [Audit Permissions](../security/permissions-audit.md)
3. **Configuration webhook** → [Configuration Webhook](../howto/configure-webhook.md)
4. **Plan de reprise** → [Backup & Recovery](./backup-recovery.md)

---

**Dernière mise à jour :** 2025-12-01
