# Standards de Sécurité

> **Standards de sécurité OWASP et ANSSI** appliqués dans LexOrbital Module Server.

---

## 🎯 Objectif

Documenter l'application des standards de sécurité OWASP Top 10 et recommandations ANSSI.

---

## 🛡️ OWASP Top 10 (2021)

### A01 - Broken Access Control

**Mesures Implémentées :**
- Isolation réseau Docker
- Principe de moindre privilège
- Containers non-root

**Documentation :** [Durcissement Sécurité](../security/hardening.md)

---

### A02 - Cryptographic Failures

**Mesures Implémentées :**
- TLS 1.2+ obligatoire
- HSTS activé
- Docker secrets pour credentials

**Documentation :** [Reverse Proxy](../operations/reverse-proxy.md)

---

### A03 - Injection

**Mesures Implémentées :**
- Validation des inputs
- Containers isolés
- Pas d'exécution SQL directe

**Documentation :** [Architecture Système](../architecture/system-design.md)

---

### A04 - Insecure Design

**Mesures Implémentées :**
- Architecture sécurisée par défaut
- Defense in depth
- Privacy by design

**Documentation :** [Architecture Système](../architecture/system-design.md)

---

### A05 - Security Misconfiguration

**Mesures Implémentées :**
- Configuration sécurisée par défaut
- Hardening automatique via Ansible
- Documentation complète

**Documentation :** [Prérequis](../operations/prerequisites.md)

---

### A06 - Vulnerable Components

**Mesures Implémentées :**
- Mises à jour automatiques
- Monitoring CVE
- Images Docker officielles

**Documentation :** [Maintenance](../operations/maintenance.md)

---

### A07 - Identification Failures

**Mesures Implémentées :**
- SSH par clés uniquement
- Fail2ban contre brute force
- MFA recommandé

**Documentation :** [Configuration SSH](../security/ssh-configuration.md)

---

### A08 - Software Integrity Failures

**Mesures Implémentées :**
- Checksums et signatures
- Images officielles uniquement
- Validation avant déploiement

**Documentation :** [Déploiement](../operations/deployment.md)

---

### A09 - Logging Failures

**Mesures Implémentées :**
- Journalisation complète
- Logs pseudonymisés (RGPD)
- SIEM-ready

**Documentation :** [Politique de Journalisation](./logging-policy.md)

---

### A10 - SSRF

**Mesures Implémentées :**
- Isolation réseau stricte
- Firewall UFW configuré
- Pas d'accès direct aux ressources internes

**Documentation :** [Règles Firewall](../security/firewall-rules.md)

---

## 🇫🇷 Recommandations ANSSI

### Cloisonnement Système

**Mesures Implémentées :**
- Isolation réseau par fonction
- Séparation utilisateurs système
- Containers non-root

---

### Authentification

**Mesures Implémentées :**
- SSH par clés uniquement
- Clés ED25519 (cryptographie moderne)
- Fail2ban contre brute force

**Documentation :** [Configuration SSH](../security/ssh-configuration.md)

---

### Journalisation

**Mesures Implémentées :**
- Logs centralisés (journald)
- Rétention limitée (30 jours)
- Protection contre altération

**Documentation :** [Politique de Journalisation](./logging-policy.md)

---

## 📊 Tableau Récapitulatif

| Standard | Mesure | Statut | Documentation |
|----------|--------|--------|---------------|
| OWASP A01 | Isolation réseau | ✅ | [Hardening](../security/hardening.md) |
| OWASP A02 | TLS 1.2+ | ✅ | [Reverse Proxy](../operations/reverse-proxy.md) |
| OWASP A03 | Validation inputs | ✅ | [Architecture](../architecture/system-design.md) |
| ANSSI | Cloisonnement | ✅ | [Architecture](../architecture/system-design.md) |
| ANSSI | SSH clés | ✅ | [SSH Config](../security/ssh-configuration.md) |

---

## 📖 Voir Aussi

- [Vue d'Ensemble Conformité](./overview.md) - Conformité générale
- [Mesures Techniques RGPD](./gdpr-technical.md) - Article 32
- [Durcissement Sécurité](../security/hardening.md) - Hardening complet
- [← Retour à l'index](../index.md)

---

**Dernière mise à jour :** 2025-01-15  
**Version :** 1.0.0

