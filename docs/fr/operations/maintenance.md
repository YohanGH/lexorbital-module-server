# Maintenance

> **Procédures de maintenance courante** pour LexOrbital Module Server.

---

## 🎯 Objectif

Documenter les tâches de maintenance régulières pour maintenir le système à jour et sécurisé.

---

## 🔄 Mises à Jour

### Système

**Mise à jour système :**
```bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
```

**Redémarrage si nécessaire :**
```bash
sudo reboot
```

### Docker

**Mise à jour images :**
```bash
docker compose pull
docker compose up -d
```

**Nettoyage :**
```bash
docker system prune -a
```

---

## 🔐 Certificats TLS

### Vérification Renouvellement

**Tester renouvellement :**
```bash
sudo certbot renew --dry-run
```

**Renouvellement manuel :**
```bash
sudo certbot renew
```

**Vérifier expiration :**
```bash
sudo certbot certificates
```

---

## 🧹 Nettoyage

### Logs

**Nettoyage logs système :**
```bash
sudo journalctl --vacuum-time=30d
```

**Nettoyage logs Docker :**
```bash
docker system prune
```

### Disque

**Vérifier espace :**
```bash
df -h
du -sh /var/log/*
```

---

## 🔍 Vérifications Régulières

### Quotidien

- [ ] Vérifier logs erreurs
- [ ] Vérifier statut containers
- [ ] Vérifier espace disque

### Hebdomadaire

- [ ] Revue logs système
- [ ] Vérification certificats
- [ ] Vérification sauvegardes

### Mensuel

- [ ] Mise à jour système
- [ ] Audit sécurité
- [ ] Revue configurations

---

## 📊 Sauvegardes

### Vérification

**Vérifier sauvegardes récentes :**
```bash
ls -lh /backup/db/
ls -lh /backup/files/
```

**Tester restauration :**
Voir [Backup & Recovery](./backup-recovery.md)

---

## 📖 Voir Aussi

- [Monitoring](./monitoring.md) - Surveillance système
- [Backup & Recovery](./backup-recovery.md) - Sauvegardes
- [Dépannage](../howto/troubleshooting.md) - Résolution problèmes
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

