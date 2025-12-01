# Setup Environnement de Développement

> **Guide pour configurer un environnement de développement** pour LexOrbital Module Server.

---

## 🎯 Objectif

Configurer un environnement de développement local pour contribuer au module.

---

## 📋 Prérequis

- Git installé
- Docker et Docker Compose installés
- Éditeur de texte ou IDE
- Accès SSH au serveur de test (optionnel)

---

## 🚀 Installation

### 1. Cloner le Repository

```bash
git clone https://github.com/YohanGH/lexorbital-module-server
cd lexorbital-module-server
```

### 2. Configuration Ansible (Optionnel)

**Pour tester Ansible localement :**
```bash
cd ansible
cp inventories/prod.ini.example inventories/local.ini
# Éditer local.ini avec vos paramètres
```

### 3. Configuration Docker

**Vérifier Docker :**
```bash
docker --version
docker compose version
```

---

## 🔧 Configuration

### Variables d'Environnement

Créer un fichier `.env` si nécessaire :
```bash
cp .env.example .env
# Éditer .env avec vos valeurs
```

### Pré-commit Hooks

**Installer hooks :**
```bash
pre-commit install
```

---

## ✅ Vérification

### Tests Locaux

**Vérifier syntaxe Ansible :**
```bash
ansible-playbook --syntax-check playbooks/site.yml
```

**Tester Docker Compose :**
```bash
docker compose config
```

---

## 📖 Voir Aussi

- [Guide de Contribution](./contribute.md) - Comment contribuer
- [Dépannage](./troubleshooting.md) - Résolution problèmes
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

