# Pipeline Project - API Express

## Description

API REST Express.js avec une chaîne d'intégration continue complète.

## Architecture CI/CD

### Validation locale (Git Hooks)

Avant chaque commit, les hooks Husky exécutent automatiquement :
- **ESLint** : vérification du code
- **Prettier** : vérification du formatage

Le commit est bloqué si l'une de ces vérifications échoue.

### Pipeline CI (GitHub Actions)

Le pipeline se déclenche sur chaque push sur la branche `development`.

### Jobs et dépendances

| Job | Dépend de | Description |
|-----|-----------|-------------|
| `build-test` | - | Install, lint, format, tests unitaires |
| `sonar-analysis` | build-test | Analyse SonarCloud + Quality Gate |
| `docker-build` | sonar-analysis | Construction image Docker |
| `security-scan` | docker-build | Scan Trivy (vulnérabilités) |
| `publish-ghcr` | security-scan | Publication sur GHCR |

### Sécurité

- Les secrets (`SONAR_TOKEN`) sont stockés dans GitHub Secrets
- L'image Docker utilise un utilisateur non-root
- Le scan Trivy bloque le déploiement en cas de vulnérabilités critiques
- Le `.dockerignore` empêche la copie de fichiers sensibles

## Outils utilisés

- **Husky** : Git hooks
- **lint-staged** : Lint sur fichiers stagés uniquement
- **ESLint** : Linter JavaScript
- **Prettier** : Formateur de code
- **Jest** : Tests unitaires
- **SonarCloud** : Analyse qualité continue
- **Docker** : Conteneurisation
- **Trivy** : Scan de vulnérabilités
- **GHCR** : Registry d'images Docker

## Liens

- [SonarCloud](https://sonarcloud.io/project/overview?id=clement-jonckheere_td-pipeline-project)
- [Image GHCR](https://github.com/clement-jonckheere/td-pipeline-project/pkgs/container/td-pipeline-project)