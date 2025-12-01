# Notes de Migration Documentation

> **Guide de migration** de l'ancienne structure vers la nouvelle structure documentaire LexOrbital.

### Commandes de Validation

```bash
# Vérifier liens cassés
cd /Users/yohangh/Documents/Dev/lexorbital/lexorbital-template-docs
./scripts/validate-docs.sh --target /Users/yohangh/Documents/Dev/lexorbital/lexorbital-module-server
```

---

## 📝 Changements à Faire Manuellement

### 2. Mettre à Jour lexorbital.module.json

```json
{
  "documentation": {
    "readme": "https://github.com/YohanGH/lexorbital-module-server#readme",
    "docs_index": "./docs/index.md",
    "architecture": "./docs/architecture/system-design.md",
    "compliance": "./docs/compliance/overview.md"
  }
}
```

## 🎯 Ordre d'Exécution Recommandé

### Étape 2 - Valider Nouvelle Structure

```bash
cd /Users/yohangh/Documents/Dev/lexorbital/lexorbital-template-docs
./scripts/validate-docs.sh --target /Users/yohangh/Documents/Dev/lexorbital/lexorbital-module-server
```

## 📊 Statistiques Migration

### Fichiers Migrés ✅

- ✅ `docs/howto/pre-commit-setup.md`
- ✅ `docs/reference/resources.md`
- ✅ `docs/operations/reverse-proxy.md`
- ✅ `docs/reference/scripts.md`

**Migration complète :** Tous les fichiers ont été migrés vers la nouvelle structure documentaire.
