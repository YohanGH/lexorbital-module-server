# Configuration pre-commit pour module d'infrastructure

Ce document explique comment configurer et utiliser **pre-commit** pour ce module d'infrastructure LexOrbital.

---

## Pourquoi pre-commit ?

Dans l'écosystème LexOrbital, il existe deux familles de modules :

### Modules applicatifs (TypeScript/Node)
- Utilisent **Husky** pour les hooks Git
- Utilisent **commitlint** pour valider les messages de commit
- Stack : Node.js / TypeScript / ESLint / Prettier

### Modules d'infrastructure (Bash/Ansible) ← Ce module
- Utilisent **pre-commit** pour les hooks Git
- Linting : **shellcheck**, **shfmt**, **ansible-lint**, **yamllint**
- Stack : Bash / Ansible / shell scripts

---

## Installation de pre-commit

### Prérequis

Python 3 doit être installé sur votre machine.

### Installation

> **⚠️ Note importante :** Les systèmes modernes (Debian 12+, Ubuntu 23.04+) protègent l'environnement Python système (PEP 668). Utilisez **pipx** (recommandé) ou un environnement virtuel pour éviter l'erreur "externally-managed-environment".

#### Méthode recommandée : pipx (isolation automatique)

**Sur Linux (Debian/Ubuntu) :**
```bash
# Installer pipx si nécessaire
sudo apt update
sudo apt install pipx
pipx ensurepath

# Installer pre-commit avec pipx
pipx install pre-commit
```

#### Alternative : Environnement virtuel

Si vous préférez un environnement virtuel explicite :
```bash
# Créer un environnement virtuel dédié
python3 -m venv ~/.venv/pre-commit

# Activer l'environnement
source ~/.venv/pre-commit/bin/activate

# Installer pre-commit
pip install pre-commit

# Note : vous devrez activer cet environnement avant d'utiliser pre-commit
```

#### Alternative : Paquet système (version peut être ancienne)

**Via apt (Ubuntu/Debian) :**
```bash
sudo apt install pre-commit
```

> **Note :** Le paquet système peut être une version plus ancienne. Pour avoir la dernière version, utilisez pipx.

#### Alternative : Homebrew (macOS)

```bash
brew install pre-commit
```

### Vérification
```bash
pre-commit --version
# Exemple de sortie : pre-commit 3.5.0
```

---

## Configuration initiale

Une fois pre-commit installé, activez-le dans le dépôt :

```bash
cd /path/to/lexorbital-module-server
pre-commit install
```

Résultat attendu :
```
pre-commit installed at .git/hooks/pre-commit
```

---

## Utilisation

### Automatique (à chaque commit)

Une fois installé, pre-commit s'exécute **automatiquement** avant chaque commit :

```bash
git add .
git commit -m "feat(ansible): add docker provisioning role"
```

Si un hook échoue (erreur de lint), le commit sera **bloqué** jusqu'à correction.

### Manuelle (sans commit)

Pour tester les hooks sur tous les fichiers :

```bash
pre-commit run --all-files
```

Pour tester un hook spécifique :

```bash
pre-commit run shellcheck --all-files
pre-commit run ansible-lint --all-files
```

---

## Hooks configurés

Le fichier `.pre-commit-config.yaml` définit les hooks suivants :

| Hook | Description | Fichiers ciblés |
|------|-------------|-----------------|
| **trailing-whitespace** | Supprime les espaces en fin de ligne | Tous |
| **end-of-file-fixer** | Ajoute une ligne vide en fin de fichier | Tous |
| **check-yaml** | Valide la syntaxe YAML | `*.yaml`, `*.yml` |
| **shellcheck** | Linter pour scripts Bash | `*.sh` |
| **shfmt** | Formateur pour scripts Bash | `*.sh` |
| **ansible-lint** | Linter pour Ansible | Fichiers dans `ansible/` |
| **yamllint** | Linter YAML (config personnalisée) | `*.yaml`, `*.yml` |

---

## Résoudre les erreurs

### Exemple : shellcheck détecte une erreur

```bash
$ git commit -m "fix: update backup script"

shellcheck............................................................Failed
- hook id: shellcheck
- exit code: 1

backup/backup-db.sh:15:12: warning: Use "$(...)" instead of legacy backticks [SC2006]
```

**Solution :** Corrigez le fichier selon les recommandations de shellcheck.

### Exemple : shfmt reformate automatiquement

```bash
shfmt..................................................................Failed
- hook id: shfmt
- files were modified by this hook
```

**Solution :** Les fichiers ont été reformatés automatiquement. Ajoutez-les et re-commitez :
```bash
git add .
git commit -m "fix: update backup script"
```

### Exemple : ansible-lint détecte un problème

```bash
ansible-lint............................................................Failed
- hook id: ansible-lint

ansible/roles/base/tasks/main.yml:12: [yaml] trailing spaces
```

**Solution :** Corrigez le fichier YAML en supprimant les espaces en fin de ligne.

---

## Ignorer temporairement les hooks

**⚠️ À utiliser avec précaution** (uniquement dans des cas exceptionnels) :

```bash
git commit --no-verify -m "WIP: work in progress"
```

---

## Mettre à jour les hooks

Pour mettre à jour les versions des hooks :

```bash
pre-commit autoupdate
```

---

## Désinstaller pre-commit

Pour désactiver pre-commit (déconseillé) :

```bash
pre-commit uninstall
```

---

## Ressources

- [Documentation officielle pre-commit](https://pre-commit.com/)
- [shellcheck documentation](https://www.shellcheck.net/)
- [ansible-lint documentation](https://ansible-lint.readthedocs.io/)
- [yamllint documentation](https://yamllint.readthedocs.io/)

---

**Date de dernière mise à jour :** 2025-11-30

