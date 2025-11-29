# Utilisateur système "lexorbital"

- Éviter *strictement* l’exécution sous root
- Tous les services tournent sous compte non-privilégié

Créer l’utilisateur :

```bash
sudo adduser --system --shell /usr/sbin/nologin --home /srv/lexorbital lexorbital
```

---