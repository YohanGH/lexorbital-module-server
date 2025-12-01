# Guide de Style Documentaire LexOrbital

> **Conventions de rédaction et formatage** pour toute la documentation de l'écosystème LexOrbital.

## 🎯 Objectif

Garantir une documentation **cohérente**, **professionnelle** et **maintenable** dans tous les repositories LexOrbital.

---

## 📝 Conventions Markdown

### Titres

```markdown
# Titre de Niveau 1 (un seul par document)

## Titre de Niveau 2

### Titre de Niveau 3

#### Titre de Niveau 4 (éviter si possible)
```

**Règles :**
- ✅ Un seul `#` (H1) par document
- ✅ Hiérarchie logique (pas de saut de niveau)
- ✅ Capitalisation : majuscule en début de phrase uniquement (français)
- ❌ Éviter H5 et H6 (restructurer si nécessaire)

### Code Blocks

```markdown
\`\`\`bash
# Code avec langue spécifiée
sudo apt update
\`\`\`

\`\`\`javascript
// Toujours spécifier la langue
const app = express();
\`\`\`
```

**Langages supportés :** `bash`, `javascript`, `typescript`, `python`, `yaml`, `json`, `nginx`, `dockerfile`

### Liens

```markdown
<!-- Liens internes (relatifs) -->
[Guide d'installation](./operations/installation.md)

<!-- Liens externes -->
[Documentation Ansible](https://docs.ansible.com/)

<!-- Ancres internes -->
[Voir configuration](#configuration)
```

**Règles :**
- ✅ Liens internes : toujours relatifs
- ✅ Liens externes : texte descriptif (pas "cliquez ici")
- ✅ Vérifier validité des liens

### Listes

```markdown
<!-- Liste non ordonnée -->
- Premier élément
- Deuxième élément
  - Sous-élément (2 espaces d'indentation)
- Troisième élément

<!-- Liste ordonnée -->
1. Première étape
2. Deuxième étape
3. Troisième étape
```

### Emphase

```markdown
*Italique* pour emphase légère
**Gras** pour emphase forte
`code inline` pour commandes, fichiers, variables
```

### Citations

```markdown
> Citation ou note importante
> sur plusieurs lignes
```

### Tableaux

```markdown
| Colonne 1 | Colonne 2 | Colonne 3 |
|-----------|-----------|-----------|
| Valeur A  | Valeur B  | Valeur C  |
| Valeur D  | Valeur E  | Valeur F  |
```

---

## 🎨 Emojis Autorisés

Utiliser avec parcimonie pour améliorer la lisibilité :

### Par Catégorie

**Navigation :**
- 🏠 Accueil
- 📚 Documentation
- 🗺️ Navigation
- 🔗 Liens

**Actions :**
- 🚀 Démarrage rapide
- ⚙️ Configuration
- 🔧 Maintenance
- 🔄 Synchronisation

**État :**
- ✅ Validé / Complété
- ❌ Invalide / À éviter
- ⚠️ Attention / Avertissement
- 💡 Conseil / Astuce
- 🎯 Objectif

**Techniques :**
- 🔒 Sécurité
- 📦 Package / Module
- 🐳 Docker
- 🌐 Réseau
- 💾 Base de données

**Rôles :**
- 👨‍💼 Décideur / Recruteur
- 👨‍💻 Développeur
- 🔧 DevOps / SysAdmin
- 🔒 Sécurité / Compliance
- ⚖️ Légal / RGPD

**Éviter :**
- ❌ Emojis fantaisistes (🎉, 🎊, 🥳)
- ❌ Plus de 2 emojis par ligne
- ❌ Emojis dans les titres (sauf cas spéciaux)

---

## 📋 Structure Type d'un Document

```markdown
# Titre du Document

> **Description courte** en une phrase expliquant l'objectif du document.

## 🎯 Objectif

Description détaillée de ce que le lecteur apprendra ou pourra faire.

## 📋 Prérequis

Liste des prérequis nécessaires :
- Prérequis 1
- Prérequis 2

## 🚀 Instructions

### Étape 1 - Titre de l'étape

Description et commandes.

\`\`\`bash
commande exemple
\`\`\`

### Étape 2 - Titre de l'étape

...

## ✅ Vérification

Comment vérifier que tout fonctionne correctement.

## 🔧 Dépannage

Problèmes courants et solutions.

## 📖 Références

- [Lien vers documentation externe](https://example.com)
- [Autre document lié](./autre-doc.md)

---

**Dernière mise à jour :** YYYY-MM-DD
```

---

## 🔐 Exemples PUBLIC-SAFE

**Toujours utiliser des valeurs d'exemple génériques** :

### Domaines

```markdown
❌ myapp.lexorbital.com
✅ example.com
✅ myapp.example.com
```

### Ports

```markdown
❌ 8080
✅ XXXXX (avec note explicative)
✅ <PORT> (avec contexte)
```

### IPs

```markdown
❌ 51.178.45.123
✅ 192.168.1.100 (IP privée)
✅ 203.0.113.0 (plage de documentation RFC 5737)
```

### Secrets

```markdown
❌ sk_live_1234567890abcdef
✅ YOUR_SECRET_KEY
✅ <REPLACE_WITH_YOUR_KEY>
```

### Emails

```markdown
❌ admin@lexorbital.com
✅ admin@example.com
✅ user@example.com
```

---

## 🌍 Langue

### Par Type de Repository

- **lexorbital-core** : Anglais (écosystème international)
- **lexorbital-module-server** : **Français** (contexte légal français)
- **lexorbital-module-ui-kit** : Anglais (standard UI)
- **lexorbital-template-docs** : Français (documentation française)

### Conventions Linguistiques

**Français :**
- ✅ Tutoiement technique (impératif : "Installez", "Configurez")
- ✅ Vouvoiement pour contexte légal/compliance
- ✅ Termes techniques en anglais si standards (Docker, container, endpoint)
- ❌ Franglais excessif

**Anglais :**
- ✅ Professional tone
- ✅ Active voice ("Configure the server" not "The server is configured")
- ✅ Clear and concise

---

## 📊 Métadonnées

### En-tête de Document (optionnel)

```markdown
---
title: Titre du Document
description: Description courte
author: YohanGH
date: 2025-12-01
version: 1.0
tags: [security, docker, ansible]
---
```

### Pied de Document (requis)

```markdown
---

**Dernière mise à jour :** 2025-12-01  
**Version :** 1.0  
**Auteur :** YohanGH
```

---

## ✅ Checklist Qualité Document

Avant de publier un document :

- [ ] Un seul H1 par document
- [ ] Hiérarchie de titres logique
- [ ] Tous les liens internes fonctionnent
- [ ] Code blocks ont une langue spécifiée
- [ ] Exemples PUBLIC-SAFE (pas de secrets)
- [ ] Emojis utilisés avec parcimonie
- [ ] Métadonnées à jour (date, version)
- [ ] Orthographe et grammaire vérifiées
- [ ] Structure claire et logique
- [ ] Testable (instructions reproductibles)

---

## 🔧 Outils de Validation

### Linter Markdown

Utiliser [markdownlint](https://github.com/DavidAnson/markdownlint) :

```bash
# Installation
npm install -g markdownlint-cli

# Validation
markdownlint docs/**/*.md
```

### Validation Liens

Utiliser le script fourni :

```bash
./scripts/validate-docs.sh --check-links
```

---

## 📖 Exemples Complets

Voir le dossier `examples/` pour des exemples de documents bien formatés :

- [Guide d'installation type](../examples/installation-example.md)
- [Documentation API type](../examples/api-reference-example.md)
- [Guide de dépannage type](../examples/troubleshooting-example.md)

---

**Ce guide est évolutif.** Proposez des améliorations via PR sur `lexorbital-template-docs`.

---

**Dernière mise à jour :** 2025-12-01  
**Version :** 1.0.0

