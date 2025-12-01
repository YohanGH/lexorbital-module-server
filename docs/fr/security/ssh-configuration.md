# Configuration SSH

> **Configuration SSH avancée** pour sécuriser l'accès au serveur.

---

## 🎯 Objectif

Documenter la configuration SSH sécurisée avec clés, fail2ban et durcissement avancé.

---

## 🔐 Configuration SSH de Base

### Fichier de Configuration

**Éditer :**
```bash
sudo nano /etc/ssh/sshd_config
```

### Paramètres Recommandés

```ssh
Port XXXXX  # Port personnalisé (49152-65535)
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
PubkeyAcceptedKeyTypes ssh-ed25519
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
```

**Redémarrer SSH :**
```bash
sudo systemctl restart sshd
```

---

## 🔑 Gestion des Clés SSH

### Génération Clé ED25519

**Sur machine locale :**
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### Copie Clé sur Serveur

```bash
ssh-copy-id -p XXXXX user@server-ip
```

### Vérification

```bash
ssh -p XXXXX user@server-ip
```

---

## 🛡️ Fail2ban

### Installation

```bash
sudo apt install -y fail2ban
```

### Configuration SSH

**Fichier :** `/etc/fail2ban/jail.local`

```ini
[sshd]
enabled = true
port = XXXXX
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

**Redémarrer :**
```bash
sudo systemctl restart fail2ban
```

### Vérification

```bash
sudo fail2ban-client status sshd
```

---

## 🔒 Durcissement Avancé

### Désactiver Options Inutiles

```ssh
X11Forwarding no
AllowTcpForwarding no
PermitTunnel no
```

### Limiter Utilisateurs

```ssh
AllowUsers user1 user2
```

---

## 📋 Checklist Sécurité SSH

- [ ] Port SSH personnalisé
- [ ] Root login désactivé
- [ ] Authentification par mot de passe désactivée
- [ ] Clés ED25519 uniquement
- [ ] Fail2ban configuré
- [ ] Timeouts configurés
- [ ] Options inutiles désactivées

---

## 📖 Voir Aussi

- [Durcissement Sécurité](./hardening.md) - Hardening complet
- [Règles Firewall](./firewall-rules.md) - Configuration UFW
- [Prérequis](../operations/prerequisites.md) - Configuration initiale
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0
