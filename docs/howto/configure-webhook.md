# Configuration Webhook pour Déploiement Automatique

> **Configuration d'un webhook** pour déploiement automatique depuis GitHub/GitLab.

Ce guide décrit comment configurer un webhook pour déclencher automatiquement le déploiement lors d'un push sur la branche principale.

> **⚠️ Document PUBLIC-SAFE :** Les exemples utilisent des valeurs génériques. Adaptez selon votre environnement.

---

## 1. Prérequis

- Serveur avec accès SSH configuré
- Script de déploiement disponible (`deploy/deploy-compose-prod.sh` ou `deploy/deploy-swarm.sh`)
- Accès au repository GitHub/GitLab
- Token d'accès ou clé SSH pour le repository

---

## 2. Configuration du Handler Webhook

Le module fournit un handler webhook dans `deploy/weebhook-handler.js` (note: typo intentionnelle dans le nom du fichier).

### Installation du handler

```bash
# Copier le handler
sudo cp deploy/weebhook-handler.js /usr/local/bin/lexorbital-webhook-handler.js
sudo chmod 755 /usr/local/bin/lexorbital-webhook-handler.js

# Installer les dépendances Node.js si nécessaire
sudo npm install -g express body-parser
```

### Configuration du handler

Éditer le fichier pour adapter :
- Port d'écoute (par défaut : 3000)
- Secret du webhook (pour validation)
- Chemin vers le script de déploiement
- Branche à surveiller (par défaut : `main`)

---

## 3. Service Systemd

Le module fournit un fichier service systemd dans `systemd/weebhook-handler.service`.

### Installation du service

```bash
# Copier le service
sudo cp systemd/weebhook-handler.service /etc/systemd/system/

# Éditer pour adapter les chemins
sudo nano /etc/systemd/system/weebhook-handler.service

# Activer et démarrer
sudo systemctl daemon-reload
sudo systemctl enable weebhook-handler.service
sudo systemctl start weebhook-handler.service
```

### Vérification

```bash
# Vérifier le statut
sudo systemctl status weebhook-handler.service

# Voir les logs
sudo journalctl -u weebhook-handler.service -f
```

---

## 4. Configuration GitHub Webhook

Dans votre repository GitHub :

1. Aller dans **Settings** → **Webhooks** → **Add webhook**
2. **Payload URL** : `https://votre-domaine.com/webhook` (ou IP:port)
3. **Content type** : `application/json`
4. **Secret** : Utiliser le même secret que dans le handler
5. **Events** : Sélectionner `Just the push event`
6. **Active** : Cocher

---

## 5. Configuration GitLab Webhook

Dans votre repository GitLab :

1. Aller dans **Settings** → **Webhooks**
2. **URL** : `https://votre-domaine.com/webhook`
3. **Secret token** : Utiliser le même secret que dans le handler
4. **Trigger** : Sélectionner `Push events`
5. **Branch filter** : `main` (ou votre branche principale)

---

## 6. Sécurité

### Protection du webhook

- ✅ Utiliser HTTPS pour le webhook
- ✅ Valider le secret dans le handler
- ✅ Limiter l'accès par IP (firewall)
- ✅ Valider la signature du webhook (GitHub/GitLab)

### Configuration Nginx (reverse proxy)

Ajouter une configuration pour protéger le webhook :

```nginx
location /webhook {
    # Limiter l'accès par IP (optionnel)
    # allow 192.0.2.0/24;
    # deny all;

    proxy_pass http://localhost:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

---

## 7. Test du webhook

### Test manuel

```bash
# Tester avec curl
curl -X POST https://votre-domaine.com/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: push" \
  -d '{"ref":"refs/heads/main"}'
```

### Vérifier les logs

```bash
# Logs du service
sudo journalctl -u weebhook-handler.service -f

# Logs du déploiement
tail -f /var/log/lexorbital/deploy.log
```

---

## 8. Dépannage

### Le webhook ne se déclenche pas

- Vérifier que le service est actif : `sudo systemctl status weebhook-handler.service`
- Vérifier les logs : `sudo journalctl -u weebhook-handler.service`
- Vérifier le firewall : `sudo ufw status`
- Vérifier la configuration Nginx

### Erreur de permissions

- Vérifier que l'utilisateur `lexorbital` peut exécuter le script de déploiement
- Vérifier les permissions sur le répertoire de déploiement
- Voir [Audit Permissions](../security/permissions-audit.md)

---

## Voir aussi

- [Guide de Déploiement](../operations/deployment.md)
- [Durcissement Sécurité](../security/hardening.md)
- [Configuration Reverse Proxy](../operations/reverse-proxy.md)

---

**Dernière mise à jour :** 2025-12-01
