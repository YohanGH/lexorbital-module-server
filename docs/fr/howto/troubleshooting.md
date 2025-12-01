# Dépannage

> **Guide de résolution des problèmes courants** pour LexOrbital Module Server.

---

## 🎯 Objectif

Résoudre les problèmes courants rencontrés lors du déploiement et de la maintenance.

---

## 🔍 Problèmes Courants

### Erreur SSH

**Symptôme :** Impossible de se connecter en SSH

**Solutions :**
- Vérifier port SSH : `sudo ufw status`
- Vérifier service SSH : `sudo systemctl status sshd`
- Vérifier clés SSH : `cat ~/.ssh/authorized_keys`

---

### Erreur Docker

**Symptôme :** Containers ne démarrent pas

**Solutions :**
```bash
# Voir logs
docker compose logs

# Vérifier statut
docker compose ps

# Redémarrer
docker compose restart
```

---

### Erreur Nginx

**Symptôme :** Nginx ne démarre pas ou erreur de configuration

**Solutions :**
```bash
# Tester configuration
sudo nginx -t

# Voir logs
sudo tail -f /var/log/nginx/error.log

# Redémarrer
sudo systemctl restart nginx
```

---

### Erreur Certificat TLS

**Symptôme :** Certificat expiré ou erreur de renouvellement

**Solutions :**
```bash
# Vérifier certificats
sudo certbot certificates

# Renouveler manuellement
sudo certbot renew

# Tester renouvellement
sudo certbot renew --dry-run
```

---

### Problème de Permissions

**Symptôme :** Erreurs de permissions Docker ou fichiers

**Solutions :**
```bash
# Vérifier groupe docker
groups

# Ajouter utilisateur au groupe docker
sudo usermod -aG docker $USER
newgrp docker
```

---

## 📋 Checklist de Dépannage

1. [ ] Vérifier logs système
2. [ ] Vérifier statut services
3. [ ] Vérifier espace disque
4. [ ] Vérifier connexions réseau
5. [ ] Vérifier configurations

---

## 📖 Voir Aussi

- [Monitoring](../operations/monitoring.md) - Surveillance système
- [Maintenance](../operations/maintenance.md) - Maintenance courante
- [Configuration SSH](../security/ssh-configuration.md) - SSH
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

