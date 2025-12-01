# Configuration Reverse Proxy

> **Configuration du reverse proxy** (Nginx) pour LexOrbital Module Server.

Ce module fournit une configuration de reverse proxy production-ready avec sécurité et conformité RGPD intégrées.

> **⚠️ Document PUBLIC-SAFE :** Les exemples utilisent `example.com` comme domaine. Remplacez par vos valeurs réelles.

---

## 1. Philosophie

- **Nginx** = reverse proxy officiel pour environnements de production
- **Caddy** = exemple moderne éducatif, utilisable si l'équipe le préfère
- Le module applique les principes :
  - *security-by-design* (TLS, headers, isolation réseau)
  - *privacy-by-design* (minimisation des logs, pseudonymisation IP, rétention limitée)

---

## 2. Structure des Répertoires

```text
reverse-proxy/
├── nginx/
│   ├── nginx.conf                    # Configuration Nginx production
│   └── sites-available/
│       └── example.conf              # Template configuration (PUBLIC-SAFE)
└── caddy/
    └── Caddyfile.example             # Alternative Caddy (exemple GDPR-friendly)
```

---

## 3. Nginx (Stack Officiel)

### 3.1. Configuration Globale

Le fichier `nginx/nginx.conf` :

- ✅ Force **HTTPS (TLS 1.2+)**
- ✅ Active **HSTS**
- ✅ Ajoute **headers de sécurité** (X-Frame-Options, CSP, etc.)
- ✅ **Pseudonymise les IPs** dans les logs via troncature (IPv4 /24)
- ✅ Logs HTTP access **minimaux**
- ✅ Désactive les logs superflus (`/health`, fichiers cachés)

👉 **À adapter :**

- `server_name` (remplacer `example.com` par votre domaine)
- Chemins vers certificats SSL (chemins Let's Encrypt ou personnalisés)
- Noms upstream (`myapp-frontend`, `myapp-backend`) selon vos services Docker

### 3.2. Configuration Site

Copier et adapter le template :

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

### 3.3. Objectif RGPD

Les logs contiennent uniquement :

- **IP tronquée** (IPv4 /24, IPv6 /64)
- Timestamp
- Requête
- Code HTTP
- Bytes envoyés

La durée de rétention est gérée via **logrotate / journald** et documentée dans [Mesures Techniques RGPD](../compliance/gdpr-technical.md).

🎯 **Finalité : sécurité** (détection d'attaques, diagnostic d'incidents), conformément à l'article 32 RGPD.

### 3.4. Pseudonymisation des IPs

Configuration pour tronquer les IPs dans les logs :

```nginx
# Format de log avec IP pseudonymisée
log_format pseudonymized '$remote_addr_masked $time_local "$request" $status $body_bytes_sent';

# Mapping pour masquer les 8 derniers bits (IPv4)
map $remote_addr $remote_addr_masked {
    ~^(\d+\.\d+\.\d+)\. $1.0;
    default 0.0.0.0;
}

# Utilisation dans la configuration du site
access_log /var/log/nginx/access.log pseudonymized;
```

---

## 4. Caddy (Alternative Exemple)

Le fichier `caddy/Caddyfile.example` illustre :

- Configuration Caddy avec :
  - **TLS 1.2+**
  - **HSTS**
  - **Headers de sécurité**
  - **CSP**
  - **Logging** avec rotation intégrée

⚠️ **Par défaut, Caddy log la IP complète.**

La conformité RGPD repose alors sur :

- **Rétention limitée** (ex. 30 jours)
- **Finalité documentée** (sécurité)
- Éventuellement **anonymisation** des logs dans la chaîne de traitement si nécessaire

📌 **Ce fichier est fourni à titre d'exemple :**  
Une équipe peut choisir d'utiliser Caddy au lieu de Nginx, à condition de maintenir les garanties décrites dans [Mesures Techniques RGPD](../compliance/gdpr-technical.md).

---

## 5. Docker Compose / Swarm

Le fichier `docker/docker-compose.prod.yml.example` définit :

- `myapp-frontend` (application frontend)
- `myapp-backend` (API backend)
- `postgres` (base de données)
- Optionnel : service `reverse-proxy` (Nginx en container)

### Principes Appliqués

- Réseaux séparés (`frontend-network`, `backend-network`, `database-network`)
- `database-network` configuré avec `internal: true`
- **Aucun port exposé** directement pour backend et DB
- **Docker secrets** (en mode Swarm) pour credentials DB, JWT, API keys
- **Healthchecks** pour chaque service
- **Limitations CPU/Mémoire** (Swarm `deploy.resources`)

---

## 6. Certificats TLS

### Let's Encrypt (Recommandé)

```bash
# Installation Certbot
sudo apt install certbot python3-certbot-nginx -y

# Génération certificat
sudo certbot --nginx -d example.com -d www.example.com

# Renouvellement automatique
sudo certbot renew --dry-run
```

### Configuration Renouvellement Automatique

```bash
# Ajouter à la crontab
sudo crontab -e

# Renouvellement deux fois par jour (Let's Encrypt recommande)
0 0,12 * * * certbot renew --quiet --deploy-hook "systemctl reload nginx"
```

---

## 7. Headers de Sécurité

### Headers Configurés

- ✅ **Strict-Transport-Security (HSTS)** : Force HTTPS
- ✅ **X-Frame-Options** : Protection contre clickjacking
- ✅ **X-Content-Type-Options** : Protection MIME sniffing
- ✅ **Content-Security-Policy** : Protection XSS
- ✅ **Referrer-Policy** : Contrôle des informations de référent
- ✅ **Permissions-Policy** : Contrôle des fonctionnalités du navigateur

### Exemple de Configuration

```nginx
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
```

---

## 8. Rate Limiting

### Protection DDoS Basique

```nginx
# Limiter les requêtes par IP
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=general_limit:10m rate=30r/s;

# Application dans la configuration
location /api/ {
    limit_req zone=api_limit burst=20 nodelay;
    proxy_pass http://lexorbital-backend;
}

location / {
    limit_req zone=general_limit burst=50 nodelay;
    proxy_pass http://lexorbital-frontend;
}
```

---

## 9. Monitoring et Logs

### Logs d'Accès

```nginx
# Logs avec IP pseudonymisée
access_log /var/log/nginx/access.log pseudonymized;
error_log /var/log/nginx/error.log warn;
```

### Rotation des Logs

Voir [Durcissement Sécurité](../security/hardening.md) pour la configuration logrotate.

---

## 10. Dépannage

### Tester la Configuration

```bash
# Vérifier la syntaxe
sudo nginx -t

# Voir la configuration chargée
sudo nginx -T

# Recharger la configuration
sudo systemctl reload nginx
```

### Vérifier les Logs

```bash
# Logs d'accès
sudo tail -f /var/log/nginx/access.log

# Logs d'erreur
sudo tail -f /var/log/nginx/error.log

# Logs système
sudo journalctl -u nginx -f
```

---

## Voir aussi

- [Installation & Configuration](./installation.md)
- [Durcissement Sécurité](../security/hardening.md)
- [Mesures Techniques RGPD](../compliance/gdpr-technical.md)

---

**Dernière mise à jour :** 2025-12-01
