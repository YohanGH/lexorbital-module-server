# Règles Firewall

> **Configuration firewall UFW** pour LexOrbital Module Server.

---

## 🎯 Objectif

Documenter la configuration du pare-feu UFW avec les règles de base et avancées.

---

## 🔥 Configuration de Base

### Activer UFW

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### Règles Essentielles

```bash
# SSH (remplacer XXXXX par votre port)
sudo ufw allow XXXXX/tcp

# HTTP
sudo ufw allow 80/tcp

# HTTPS
sudo ufw allow 443/tcp
```

### Activer Firewall

```bash
sudo ufw enable
sudo ufw status
```

---

## 🛡️ Règles Avancées

### Rate Limiting SSH

```bash
sudo ufw limit XXXXX/tcp
```

### Règles Spécifiques par IP

```bash
# Autoriser IP spécifique
sudo ufw allow from 192.168.1.100 to any port XXXXX

# Bloquer IP spécifique
sudo ufw deny from 192.168.1.200
```

### Règles par Interface

```bash
# Autoriser sur interface spécifique
sudo ufw allow in on eth0 to any port 443
```

---

## 📊 Vérification

### Statut Firewall

```bash
sudo ufw status verbose
```

### Logs

```bash
sudo tail -f /var/log/ufw.log
```

---

## 🔧 Gestion

### Désactiver Temporairement

```bash
sudo ufw disable
```

### Réinitialiser

```bash
sudo ufw reset
```

---

## 📋 Checklist Firewall

- [ ] UFW activé
- [ ] Règles SSH configurées
- [ ] HTTP/HTTPS autorisés
- [ ] Rate limiting SSH activé
- [ ] Logs activés
- [ ] Règles testées

---

## 📖 Voir Aussi

- [Configuration SSH](./ssh-configuration.md) - Sécurité SSH
- [Durcissement Sécurité](./hardening.md) - Hardening complet
- [Prérequis](../operations/prerequisites.md) - Configuration initiale
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

