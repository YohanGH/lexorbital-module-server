# Exécuter un Playbook Ansible

> **Guide pour exécuter les playbooks Ansible** de LexOrbital Module Server.

---

## 🎯 Objectif

Apprendre à exécuter les playbooks Ansible pour provisionner un serveur.

---

## 📋 Prérequis

- Ansible 2.14+ installé
- Accès SSH au serveur cible
- Inventaire Ansible configuré

---

## 🚀 Exécution

### 1. Préparer l'Inventaire

**Éditer l'inventaire :**
```bash
cd ansible
nano inventories/prod.ini
```

**Exemple :**
```ini
[servers]
server1 ansible_host=192.168.1.100 ansible_user=admin
```

### 2. Vérifier la Connexion

```bash
ansible all -i inventories/prod.ini -m ping
```

### 3. Exécuter le Playbook

**Mode dry-run (test) :**
```bash
ansible-playbook -i inventories/prod.ini playbooks/site.yml --check
```

**Exécution réelle :**
```bash
ansible-playbook -i inventories/prod.ini playbooks/site.yml
```

---

## 🔧 Options Utiles

### Limiter à un Hôte

```bash
ansible-playbook -i inventories/prod.ini playbooks/site.yml --limit server1
```

### Exécuter un Rôle Spécifique

```bash
ansible-playbook -i inventories/prod.ini playbooks/site.yml --tags docker
```

### Mode Verbose

```bash
ansible-playbook -i inventories/prod.ini playbooks/site.yml -v
```

---

## ✅ Vérification

**Vérifier résultat :**
```bash
ansible all -i inventories/prod.ini -m shell -a "docker --version"
```

---

## 📖 Voir Aussi

- [Provisionnement Ansible](../operations/ansible-provisioning.md) - Documentation complète
- [Dépannage](./troubleshooting.md) - Résolution problèmes
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

