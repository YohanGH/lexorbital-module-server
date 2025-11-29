# Documentation LexOrbital Module Server

Documentation complète pour le déploiement et la maintenance du module serveur LexOrbital.

---

## 📚 Documentation en français

### Guide de déploiement

1. **[00 — Préparation du serveur](./FR/00-serveur-prerequis.md)**
   - Prérequis minimaux pour installer un serveur LexOrbital
   - Configuration SSH, firewall, Docker, Nginx
   - À exécuter **avant** de cloner le module

2. **[01 — Installation et configuration](./FR/01-installation-et-configuration.md)**
   - Installation après le clone du dépôt
   - Configuration des secrets Docker
   - Configuration du reverse proxy Nginx

3. **[02 — Guide de déploiement](./FR/02-guide-de-deploiement.md)**
   - Stratégies de déploiement (Docker Compose / Swarm)
   - Mises à jour et rollback
   - Monitoring et vérification

### Sécurité et conformité

4. **[03 — Durcissement serveur](./FR/03-renforcement-de-la-securite.md)**
   - Mesures avancées de sécurité
   - Configuration SSH avancée (fail2ban)
   - Firewall UFW avancé
   - Gestion avancée des logs

5. **[04 — Utilisateurs et autorisations](./FR/04-utilisateurs-et-autorisations.md)**
   - Gestion avancée des permissions
   - Audit de sécurité
   - Isolation des containers Docker

6. **[05 — Configuration webhook](./FR/05-configuration-webhook.md)**
   - Configuration des webhooks pour le déploiement automatique

7. **[06 — RGPD - Mesures techniques](./FR/06-rgpd-mesures-techniques.md)**
   - Mesures techniques de conformité RGPD
   - Pseudonymisation des logs
   - Rétention des données

8. **[07 — DRP (Disaster Recovery Plan)](./FR/07-drp.md)**
   - Plan de reprise après sinistre
   - Stratégie de sauvegarde
   - Tests de restauration

### Références

9. **[08 — Sources et références](./FR/08-sources-et-references.md)**
   - Liste complète des ressources utilisées
   - Documentation officielle des outils
   - Standards et conformité (RGPD, ANSSI, OWASP)

---

## 📚 Documentation en anglais

La documentation en anglais est disponible dans le dossier [`EN/`](./EN/).

---

## 🔗 Liens rapides

- [Guide de préparation serveur](./FR/00-serveur-prerequis.md)
- [Guide de déploiement](./FR/02-guide-de-deploiement.md)
- [Durcissement sécurité](./FR/03-renforcement-de-la-securite.md)
- [Sources et références](./FR/08-sources-et-references.md)

---

## 📖 Structure de la documentation

```
docs/
├── FR/                          # Documentation en français
│   ├── 00-serveur-prerequis.md  # Préparation serveur
│   ├── 01-installation-et-configuration.md
│   ├── 02-guide-de-deploiement.md
│   ├── 03-renforcement-de-la-securite.md
│   ├── 04-utilisateurs-et-autorisations.md
│   ├── 05-configuration-webhook.md
│   ├── 06-rgpd-mesures-techniques.md
│   ├── 07-drp.md
│   ├── 08-sources-et-references.md
│   └── securite/                # Documentation sécurité détaillée
│       ├── journaling.md
│       └── ssh_hardening.md
├── EN/                          # Documentation en anglais
└── README.md                     # Ce fichier
```

---

## 🎯 Ordre de lecture recommandé

Pour un nouveau déploiement :

1. **00 — Préparation du serveur** (obligatoire)
2. **01 — Installation et configuration**
3. **02 — Guide de déploiement**
4. **03 — Durcissement serveur** (après déploiement)
5. **04 — Utilisateurs et autorisations** (après déploiement)
6. **06 — RGPD** (pour la conformité)
7. **07 — DRP** (pour la résilience)

Pour la maintenance :

- **03 — Durcissement serveur** (mises à jour sécurité)
- **04 — Utilisateurs et autorisations** (audit régulier)
- **07 — DRP** (tests de restauration)

---

## 📝 Contribution

Pour contribuer à la documentation :

1. Respecter le format Markdown
2. Utiliser des exemples génériques (`example.com`, `XXXXX` pour ports)
3. Maintenir la cohérence avec les autres documents
4. Référencer les sources dans `08-sources-et-references.md`

---

**Dernière mise à jour :** 2025-11-29

