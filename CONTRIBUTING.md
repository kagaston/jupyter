# Contributing to jupyter

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [just](https://github.com/casey/just) task runner
- [shellcheck](https://www.shellcheck.net/) for shell linting
- [shfmt](https://github.com/mvdan/sh) for shell formatting
- [hadolint](https://github.com/hadolint/hadolint) for Dockerfile linting

## Setup

```bash
git clone https://github.com/kagaston/jupyter.git
cd jupyter
just build
```

## Development Commands

| Command | Purpose |
|---------|---------|
| `just build` | Build the Docker image |
| `just push` | Push all tags to Docker Hub |
| `just lint-shell` | Lint shell scripts with shellcheck |
| `just format-shell` | Format shell scripts with shfmt |
| `just lint-docker` | Lint Dockerfile with hadolint |
| `just clean` | Prune dangling Docker images |

## Code Style

### Shell Scripts

- Always start with `set -euo pipefail`
- Quote all variable references
- Use `readonly` for constants
- Use `local` for function variables
- Run `just lint-shell` and `just format-shell` before committing

### Dockerfile

- Use `LABEL` instead of deprecated `MAINTAINER`
- Use uppercase `AS` for multi-stage build aliases
- Run `just lint-docker` before committing

## Workflow

1. Create a branch: `git checkout -b feat/description`
2. Make changes with conventional commits
3. Run linters before pushing:
   ```bash
   just lint-shell
   just lint-docker
   ```
4. Open a PR using the project template
5. Address review feedback
6. Squash-merge after approval

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(docker): add GPU support
fix(bootstrap): quote variable in curl command
docs(readme): update getting started section
chore(ci): add hadolint to workflow
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `build`, `ci`, `chore`
