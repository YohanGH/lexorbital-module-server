# Monitoring

> **Surveillance et alertes** pour LexOrbital Module Server.

---

## 🎯 Objectif

Documenter les outils et procédures de monitoring pour surveiller la santé du système et détecter les anomalies.

---

## 📊 Monitoring Système

### Logs Systemd

**Vérification :**
```bash
sudo journalctl -u docker
sudo journalctl -u nginx
```

**Surveillance continue :**
```bash
sudo journalctl -f
```

### Logs Docker

**Voir logs containers :**
```bash
docker compose logs -f
```

**Logs spécifiques :**
```bash
docker compose logs -f <service-name>
```

---

## 🔍 Health Checks

### Docker Health Checks

Les containers incluent des health checks automatiques :

```bash
# Vérifier statut health
docker ps --format "table {{.Names}}\t{{.Status}}"
```

### Vérification Manuelle

**Nginx :**
```bash
curl -I http://localhost
```

**Containers :**
```bash
docker compose ps
```

---

## 📈 Métriques Système

### CPU et Mémoire

```bash
# Utilisation CPU et mémoire
htop

# Résumé rapide
free -h
df -h
```

### Disque

```bash
# Espace disque
df -h

# Inodes
df -i
```

---

## 🚨 Alertes

### Configuration Alertes (Optionnel)

Pour un monitoring avancé, considérer :
- Prometheus + Grafana
- Alertmanager
- Notifications (email, Slack)

---

## 📋 Checklist Monitoring

### Quotidien

- [ ] Vérifier logs erreurs
- [ ] Vérifier espace disque
- [ ] Vérifier statut containers

### Hebdomadaire

- [ ] Revue logs système
- [ ] Vérification certificats TLS
- [ ] Vérification sauvegardes

---

## 📖 Voir Aussi

- [Maintenance](./maintenance.md) - Maintenance courante
- [Dépannage](../howto/troubleshooting.md) - Résolution problèmes
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

