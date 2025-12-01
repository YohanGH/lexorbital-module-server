# robots.txt - Guide d'utilisation

Ce fichier `robots.txt` contrôle l'accès des robots d'indexation (moteurs de recherche) à votre site.

---

## 📍 Emplacement

**Dans le repo** : `assets/robots.txt`  
**Sur le serveur** : `/var/www/assets/robots.txt`

---

## 🔧 Configuration Nginx

Le fichier est servi via Nginx avec cette configuration :

```nginx
location = /robots.txt {
    alias /var/www/assets/robots.txt;
    access_log off;        # GDPR: pas de logs pour robots.txt
    expires 7d;            # Cache 7 jours
}
```

**Accès** : `https://example.com/robots.txt`

---

## 📝 Personnalisation

### 1. Autoriser/Interdire des chemins

**Autoriser tout** :
```
User-agent: *
Allow: /
```

**Interdire des chemins spécifiques** :
```
Disallow: /api/
Disallow: /admin/
Disallow: /private/
```

### 2. Ajouter votre sitemap

Décommentez et modifiez cette ligne :
```
Sitemap: https://example.com/sitemap.xml
```

### 3. Règles spécifiques par moteur

Le fichier inclut déjà des règles pour Google et Bing. Vous pouvez ajouter d'autres moteurs :

```
User-agent: DuckDuckBot
Allow: /
Disallow: /api/
```

---

## 🎯 Exemples de configurations

### Configuration permissive (site public)
```
User-agent: *
Allow: /
Disallow: /api/
Disallow: /admin/
Sitemap: https://example.com/sitemap.xml
```

### Configuration restrictive (site privé)
```
User-agent: *
Disallow: /
```

### Configuration mixte (certaines pages publiques)
```
User-agent: *
Allow: /public/
Allow: /blog/
Disallow: /
Sitemap: https://example.com/sitemap.xml
```

---

## ✅ Bonnes pratiques

### 1. RGPD et confidentialité
- ✅ Ne pas exposer de données personnelles dans les pages crawlables
- ✅ Interdire l'indexation des zones privées (`/admin/`, `/api/`)
- ✅ Vérifier que les pages publiques ne contiennent pas de PII

### 2. SEO
- ✅ Inclure votre sitemap (`Sitemap: https://example.com/sitemap.xml`)
- ✅ Autoriser l'indexation des pages importantes
- ✅ Interdire les pages sans valeur SEO (erreurs, admin)

### 3. Performance
- ✅ Interdire les chemins qui génèrent beaucoup de trafic inutile
- ✅ Utiliser `Crawl-delay` si nécessaire (attention : pas tous les moteurs le respectent)

---

## 🧪 Tests

### Vérifier que le fichier est accessible

```bash
curl https://example.com/robots.txt
```

**Résultat attendu** : Le contenu du fichier `robots.txt`

### Tester avec Google Search Console

1. Allez sur [Google Search Console](https://search.google.com/search-console)
2. Utilisez l'outil "Tester le fichier robots.txt"
3. Vérifiez que les règles sont correctement interprétées

### Valider la syntaxe

Utilisez un validateur en ligne :
- [Google Search Console Robots.txt Tester](https://www.google.com/webmasters/tools/robots-txt)
- [Robots.txt Checker](https://www.seoptimer.com/robots-txt-checker)

---

## 📚 Ressources

### Documentation officielle
- [Google - robots.txt](https://developers.google.com/search/docs/crawling-indexing/robots/robots_txt)
- [RFC 9309 - robots.txt](https://www.rfc-editor.org/rfc/rfc9309.html)

### Outils
- [Google Search Console](https://search.google.com/search-console)
- [Bing Webmaster Tools](https://www.bing.com/webmasters)

---

## ⚠️ Notes importantes

1. **Le fichier est public** : N'importe qui peut voir votre `robots.txt` en visitant `https://example.com/robots.txt`

2. **Pas de sécurité** : `robots.txt` est une suggestion, pas une protection. Les robots malveillants peuvent l'ignorer.

3. **Mise à jour** : Après modification, attendez quelques jours pour que les moteurs de recherche prennent en compte les changements.

4. **Cache** : Les moteurs de recherche mettent en cache le fichier. Les changements ne sont pas immédiats.

---

**Dernière mise à jour** : 2025-11-30  
**Version** : 1.0.0

