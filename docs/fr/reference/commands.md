# Référence Commandes

> **Référence des commandes** utiles pour LexOrbital Module Server.

---

## 🎯 Objectif

Référence rapide des commandes les plus utilisées.

---

## 🐳 Docker

### Containers

```bash
# Lister containers
docker ps

# Voir logs
docker compose logs -f

# Redémarrer
docker compose restart

# Arrêter
docker compose down

# Démarrer
docker compose up -d
```

### Images

```bash
# Lister images
docker images

# Nettoyer
docker system prune -a
```

---

## 🤖 Ansible

```bash
# Tester connexion
ansible all -i inventories/prod.ini -m ping

# Exécuter playbook
ansible-playbook -i inventories/prod.ini playbooks/site.yml

# Mode dry-run
ansible-playbook -i inventories/prod.ini playbooks/site.yml --check
```

---

## 🌐 Nginx

```bash
# Tester configuration
sudo nginx -t

# Recharger configuration
sudo systemctl reload nginx

# Voir logs
sudo tail -f /var/log/nginx/error.log
```

---

## 🔐 Certificats

```bash
# Vérifier certificats
sudo certbot certificates

# Renouveler
sudo certbot renew

# Tester renouvellement
sudo certbot renew --dry-run
```

---

## 🔒 Sécurité

```bash
# Statut firewall
sudo ufw status

# Statut fail2ban
sudo fail2ban-client status sshd

# Voir logs SSH
sudo journalctl -u sshd -f
```

---

## 📖 Voir Aussi

- [Scripts](./scripts.md) - Scripts utilitaires
- [Configuration](./configuration.md) - Référence configuration
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

