# Server Infrastructure Module – Production Deployment

This module provides a reusable **server infrastructure foundation** for deploying applications on production servers:

- Reverse proxy (Nginx in production),
- Caddy example (optional),
- Docker Compose / Swarm,
- Security & GDPR best practices (CNIL/ANSSI),

---

## 1. Philosophy

- **Nginx** = official reverse proxy for production environments.
- **Caddy** = modern educational example, usable if the team prefers it.
- The module applies the principles:

  - *security-by-design* (TLS, headers, network isolation),
  - *privacy-by-design* (log minimization, IP pseudonymization, limited retention).

---

## 2. Directory Structure

```text
server-infrastructure/
  /reverse-proxy/
    nginx/
        nginx.conf                    # Production Nginx configuration
        sites-available/
            example.conf              # Template configuration (PUBLIC-SAFE)
    caddy/
        Caddyfile.example            # Caddy alternative (GDPR-friendly example)
  docker/
    docker-compose.prod.yml.example  # Stack front + back + DB + reverse proxy
  deploy/
    deploy-compose-prod.sh
    deploy-swarm.sh
  docs/
    FR/
        06-rgpd-mesures-techniques.md
        07-drp.md
```

5.1. "Simple" deployment (Compose)
```bash
cd docker
./../scripts/deploy-compose.sh
```

5.2. "Advanced" deployment (Swarm)
```bash
docker swarm init
cd docker
./../scripts/deploy-swarm.sh
```

## 3. Nginx (official stack)

### 3.1. Configuration file

The `nginx/nginx.conf` file:

- enforces **HTTPS (TLS 1.2+)**,  
- enables **HSTS**,  
- adds **security headers** (X-Frame-Options, CSP, etc.),  
- **pseudonymizes IPs** in logs via truncation (IPv4 /24),  
- logs all HTTP access in a **minimal** way,  
- disables superfluous logs (`/health`, hidden files).

👉 **To adapt:**

- `server_name` (replace `example.com` with your domain),  
- paths to SSL certificates (Let's Encrypt paths or custom),  
- upstream names (`myapp-frontend`, `myapp-backend`) according to your Docker services.

---

### 3.2. GDPR Objective

Logs contain only:

- **truncated** IP,  
- timestamp,  
- request,  
- HTTP code,  
- bytes sent.

Retention period is managed via **logrotate / journald** and documented in  
`docs/RGPD-mesures-techniques.md`.

🎯 **Purpose: security** (attack detection, incident diagnosis), in accordance with GDPR Article 32.

---

## 4. Caddy (alternative example)

The `caddy/Caddyfile.example` file illustrates:

- a Caddy configuration with:
  - **TLS 1.2+**,  
  - **HSTS**,  
  - **security headers**,  
  - **CSP**,  
  - **logging** with built-in rotation.

⚠️ **By default, Caddy logs the full IP.**

GDPR compliance then relies on:

- **limited retention** (e.g. 30 days),  
- a **documented** purpose (security),  
- possibly **anonymization** of logs in the processing chain if necessary.

📌 **This file is provided as an example:**  
a team can choose to use Caddy instead of Nginx, provided they maintain the guarantees described in `docs/RGPD-mesures-techniques.md`.

---

## 5. Docker Compose / Swarm

The `docker/docker-compose.prod.yml.example` file defines:

- `myapp-frontend` (frontend application),  
- `myapp-backend` (API backend),  
- `postgres` (database),  
- Optional: `reverse-proxy` service (Nginx in container).

### Applied principles:

- separate networks (`frontend-network`, `backend-network`, `database-network`),  
- `database-network` set to `internal: true`,  
- **no ports exposed** directly for backend and DB,  
- **Docker secrets** (in Swarm mode) for DB credentials, JWT, API keys,  
- **healthchecks** for each service,  
- **CPU/Memory** limitations (Swarm `deploy.resources`).  


## 6. GDPR Documentation (docs/RGPD-mesures-techniques.md)

This document describes:
- encryption measures (TLS, encrypted storage),
- log policy (logged data, retention period, access),
- network isolation,
- backups & restore tests (referenced with DRP.md),
- link with GDPR Article 32 (processing security).

It serves as technical support for your GDPR compliance documentation.

## 7. TODO / Future Hardening

- Harden CSP (remove unsafe-inline when frontend is adapted),
- Add a rate limiting mechanism (Nginx, fail2ban, firewall),
- Develop a log anonymization script if the full IP must be stored longer in certain environments.