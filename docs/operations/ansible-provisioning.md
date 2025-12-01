# Provisionnement Ansible

> **Automatisation du provisionnement serveur** avec Ansible pour LexOrbital.

Ce document explique comment utiliser **Ansible** pour le provisionnement automatisé du serveur LexOrbital.

---

## 🎯 Objectif

Automatiser la configuration initiale du serveur avec Ansible :
- ✅ Mise à jour système
- ✅ Installation paquets essentiels
- ✅ Configuration pare-feu UFW
- ✅ Configuration timezone
- ✅ Idempotence garantie

---

## 📋 Qu'est-ce qu'Ansible ?

Ansible est un outil d'automatisation permettant de provisionner, configurer et gérer des serveurs de manière déclarative et idempotente.

**Avantages :**
- ✅ Sans agent (nécessite uniquement SSH et Python)
- ✅ Idempotent (sûr d'exécuter plusieurs fois)
- ✅ Syntaxe YAML lisible
- ✅ Pas de courbe d'apprentissage pour usage basique

---

## 🚀 Prérequis

- Ansible >= 2.14 installé sur votre **machine locale**
- Accès SSH au serveur cible
- Python 3 installé sur le serveur cible
- Utilisateur avec privilèges sudo sur le serveur cible

---

## 1. Installation d'Ansible

### Sur Votre Machine Locale (pas sur le serveur)

**Debian/Ubuntu :**

```bash
sudo apt update
sudo apt install ansible
```

**macOS :**

```bash
brew install ansible
```

**Vérification :**

```bash
ansible --version
# Attendu: ansible [core 2.14+]
```

---

## 2. Configuration de l'Inventaire

### 2.1. Éditer le Fichier d'Inventaire

```bash
cd ansible
nano inventories/prod.ini
```

### 2.2. Remplacer les Valeurs d'Exemple

```ini
[servers]
lexorbital-prod ansible_host=192.168.1.100 ansible_user=deploy ansible_port=22
```

**Paramètres :**
- `ansible_host` : Adresse IP ou nom de domaine du serveur
- `ansible_user` : Utilisateur SSH (doit avoir privilèges sudo)
- `ansible_port` : Port SSH (défaut: 22)

---

## 3. Test de Connexion

Vérifier que vous pouvez vous connecter au serveur :

```bash
ansible servers -m ping
```

**Résultat attendu :**

```
lexorbital-prod | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Dépannage

#### Erreur : "Permission denied (publickey)"

**Solution :** Ajouter votre clé SSH au serveur :

```bash
ssh-copy-id deploy@192.168.1.100
```

#### Erreur : "sudo: a password is required"

**Solution :** Utiliser `--ask-become-pass` :

```bash
ansible-playbook playbooks/site.yml --ask-become-pass
```

---

## 4. Exécution du Playbook de Provisionnement

### 4.1. Lancer le Playbook Principal

```bash
ansible-playbook playbooks/site.yml
```

**Ce playbook effectue :**
- Mise à jour complète du système (`apt update && apt upgrade`)
- Installation paquets essentiels (vim, curl, git, ufw, htop, net-tools, python3-pip)
- Configuration pare-feu UFW (activé, politique par défaut: deny)
- Ouverture port SSH (22)
- Configuration timezone UTC

**Résultat attendu :**

```
PLAY RECAP *********************************************************************
lexorbital-prod : ok=5    changed=3    unreachable=0    failed=0    skipped=0
```

---

## 5. Commandes Utiles

### 5.1. Dry-Run (Simulation)

Tester sans appliquer les changements :

```bash
ansible-playbook playbooks/site.yml --check
```

### 5.2. Lister Toutes les Tâches

```bash
ansible-playbook playbooks/site.yml --list-tasks
```

### 5.3. Exécuter Uniquement Certains Tags

```bash
ansible-playbook playbooks/site.yml --tags "firewall"
```

### 5.4. Cibler Un Seul Serveur

```bash
ansible-playbook playbooks/site.yml --limit lexorbital-prod
```

### 5.5. Mode Verbeux (Débogage)

```bash
ansible-playbook playbooks/site.yml -vvv
```

---

## 6. Structure Ansible

```
ansible/
├── ansible.cfg           # Configuration globale Ansible
├── inventories/          # Inventaires serveurs
│   └── prod.ini         # Serveurs de production
├── playbooks/           # Playbooks (scripts d'automatisation)
│   └── site.yml        # Playbook principal
├── roles/              # Rôles réutilisables
│   └── base/           # Rôle de provisionnement de base
│       ├── tasks/      # Tâches à exécuter
│       └── vars/       # Variables
└── README.md           # Documentation Ansible
```

---

## 7. Rôles Disponibles

### Rôle `base`

Provisionnement système minimal :
- Mises à jour système
- Installation paquets essentiels
- Configuration pare-feu UFW
- Configuration timezone

**Tags disponibles :** `base`, `updates`, `packages`, `firewall`, `system`

**Exemple d'utilisation par tags :**

```bash
# Uniquement mises à jour
ansible-playbook playbooks/site.yml --tags updates

# Uniquement pare-feu
ansible-playbook playbooks/site.yml --tags firewall
```

---

## 8. Vérification Post-Provisionnement

Après provisionnement, vérifier la configuration :

```bash
# Se connecter au serveur
ssh deploy@192.168.1.100

# Vérifier statut UFW
sudo ufw status

# Vérifier paquets installés
which vim git curl htop

# Vérifier timezone
timedatectl
```

---

## 9. Best Practices

1. **Toujours tester avec `--check` d'abord** avant d'appliquer des changements
2. **Utiliser les tags** pour exécuter des parties spécifiques des playbooks
3. **Documenter vos rôles** avec des commentaires clairs
4. **Versionner vos inventaires** mais **ne jamais committer de secrets**
5. **Utiliser ansible-vault** pour les données sensibles

---

## 10. Prochaines Étapes

Rôles Ansible futurs à ajouter :

- [ ] `docker` - Installation Docker et Docker Compose
- [ ] `reverse-proxy` - Configuration Nginx/Caddy
- [ ] `security-hardening` - fail2ban, SSH hardening, etc.
- [ ] `backup` - Sauvegardes automatisées

---

## 📖 Ressources

- [Documentation officielle Ansible](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Rôles communautaires
- [Best Practices Ansible](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

---

## 📖 Voir Aussi

- [Prérequis](./prerequisites.md) - Préparation serveur
- [Installation](./installation.md) - Installation post-clone
- [Déploiement](./deployment.md) - Déploiement applications
- [Dépannage](../howto/troubleshooting.md) - Résolution problèmes
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-12-01  
**Version :** 1.0.0

