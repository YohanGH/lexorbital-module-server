# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Ansible provisioning infrastructure** : Complete Ansible setup with base role for automated server provisioning
  - `ansible/` directory with playbooks, roles, and inventory structure
  - Base role for system updates, essential packages, UFW firewall, and timezone configuration
  - Comprehensive Ansible documentation in `ansible/README.md`
- **Module manifest** : `lexorbital.module.json` defining module type as "infra" with tooling specifications
- **pre-commit configuration** : `.pre-commit-config.yaml` with shellcheck, shfmt, ansible-lint, and yamllint
- **Enhanced documentation** : Ansible provisioning guide in French documentation (`docs/FR/01-installation-et-configuration.md`)
- `.gitignore` adapted for infrastructure module (Ansible, secrets, backups)

### Changed

- **Module type transformation** : Converted from applicative module (Node/TypeScript) to infrastructure module (Bash/Ansible)
- **Documentation updates** : README.md, CONTRIBUTING.md, and docs/README.md updated to reflect infrastructure module nature
- Removed all Node.js/Husky/commitlint tooling (replaced by pre-commit for infrastructure modules)

### Removed

- `package.json`, `pnpm-lock.yaml` : Node.js dependency management (not needed for infra module)
- `commitlint.config.ts` and `config/commitlint/` : Commitlint configuration (replaced by pre-commit)
- Husky configuration and related scripts

### Migration Notes

This release transforms the module from an **applicative module** to an **infrastructure module**.

**Breaking changes:**
- No more Node.js tooling (Husky, commitlint, npm scripts)
- Git hooks now managed by `pre-commit` instead of Husky
- New dependency: Ansible >= 2.14 required for provisioning

**Migration path:**
1. Install Ansible: `sudo apt install ansible` (Debian/Ubuntu) or `brew install ansible` (macOS)
2. Install pre-commit: `pip install pre-commit && pre-commit install`
3. Configure your inventory in `ansible/inventories/prod.ini`
4. Run initial provisioning: `cd ansible && ansible-playbook playbooks/site.yml`
