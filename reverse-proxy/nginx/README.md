# Configuration Nginx - Reverse Proxy

Ce dossier contient des configurations Nginx sécurisées et conformes RGPD pour un reverse proxy.

---

## 📁 Structure

```
reverse-proxy/nginx/
├── nginx.conf                    # Configuration globale Nginx (RGPD-compliant)
├── sites-available/
│   ├── example.conf             # Template de configuration (PUBLIC-SAFE)
│   └── lexorbital.conf          # Configuration spécifique (à ne pas partager publiquement)
├── sites-enabled/               # Liens symboliques vers les configs actives
└── README.md                    # Ce fichier
```

---

## 🔒 Configurations PUBLIC-SAFE

### Fichiers sûrs à partager publiquement :

- ✅ `nginx.conf` - Configuration globale générique
- ✅ `sites-available/example.conf` - Template d'exemple avec placeholders

### Fichiers à NE PAS partager :

- ❌ `sites-available/lexorbital.conf` ou tout fichier avec :
  - Noms de domaines réels
  - Noms de containers spécifiques
  - Chemins personnalisés
  - Toute configuration de production

---

## 🚀 Utilisation

### 1. Copier le template

```bash
cd /etc/nginx/sites-available/
sudo cp example.conf myapp.conf
```

### 2. Adapter la configuration

Remplacer dans `myapp.conf` :

- `example.com` → votre domaine réel
- `myapp-frontend` → nom de votre container frontend
- `myapp-backend` → nom de votre container backend
- Ports (`:8080`, `:4000`) → ports de vos containers

### 3. Activer la configuration

```bash
sudo ln -s /etc/nginx/sites-available/myapp.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Obtenir un certificat SSL

```bash
sudo certbot --nginx -d example.com -d www.example.com
```

---

## 📋 Fonctionnalités de sécurité incluses

### RGPD / GDPR

- ✅ **Pseudonymisation des logs** : Dernier octet IPv4 tronqué (`192.168.1.0` au lieu de `192.168.1.123`)
- ✅ **Minimisation des logs** : Format minimal conforme
- ✅ **Headers de confidentialité** : `Permissions-Policy` restrictif

### Sécurité (OWASP)

- ✅ **TLS 1.2+ uniquement** : Protocoles obsolètes désactivés
- ✅ **HSTS** : Force HTTPS avec preload
- ✅ **CSP** : Content Security Policy restrictive
- ✅ **Security headers** : X-Frame-Options, X-Content-Type-Options, etc.
- ✅ **Timeouts** : Protection contre les attaques de déni de service
- ✅ **Buffer limits** : Limites de taille de requêtes
- ✅ **Server tokens off** : Cache la version Nginx

### Performance

- ✅ **HTTP/2** : Multiplexage et compression
- ✅ **Gzip** : Compression des réponses
- ✅ **Keepalive** : Réutilisation des connexions

---

## 🔧 Maintenance

### Tester la configuration

```bash
sudo nginx -t
```

### Recharger sans downtime

```bash
sudo systemctl reload nginx
```

### Vérifier les logs

```bash
# Logs d'accès (RGPD-compliant)
sudo tail -f /var/log/nginx/access.log

# Logs d'erreurs
sudo tail -f /var/log/nginx/error.log
```

### Rotation des logs

Les logs sont automatiquement gérés par `logrotate` selon la configuration système.

---

## 📖 Références

- [Nginx Documentation](https://nginx.org/en/docs/)
- [OWASP Secure Headers Project](https://owasp.org/www-project-secure-headers/)
- [CNIL - Recommandations logs](https://www.cnil.fr/)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)

---

## ⚠️ Important

**Avant de commit ou partager :**

1. Vérifier qu'aucun domaine réel n'est présent
2. Vérifier qu'aucune IP publique n'est présente
3. Vérifier qu'aucun nom de container/service spécifique n'est présent
4. Utiliser `example.com` et des placeholders génériques

**Pour la production :**

1. Ne jamais commit les fichiers de configuration réels
2. Utiliser des variables d'environnement ou des secrets managers
3. Maintenir une version locale avec `.gitignore`

