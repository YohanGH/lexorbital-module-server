# Durcissement serveur (Security Hardening LexOrbital)

## 1. SSH

- Désactiver root login  
- Activer fail2ban (inclus par défaut)
- Autoriser uniquement clés SSH (pas de mot de passe)

## 2. Firewall (UFW)

- Ports autorisés : 22, 80, 443 uniquement  
- backend et DB exposés uniquement en réseaux internes Docker

## 3. Updates automatiques

```bash
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```

## 4. Journaux

Utiliser journald ou logrotate
Rétention max recommandée : 30 à 90 jours
Renseigner finalité dans doc RGPD
