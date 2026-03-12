# AI Agent Instructions

## Project Context

This project builds a Docker image (`kagaston/jupyter`) that provides Jupyter Lab with Python, Scala 3.2.2, and Apache Spark 3.3.1 on Oracle Linux 9 Slim. There is no application source code -- the repo contains only Docker and shell infrastructure.

## Commands

Use the `justfile` for all standard operations:

```bash
just build            # Build Docker image
just push             # Push to Docker Hub
just lint-shell       # Lint shell scripts (shellcheck)
just format-shell     # Format shell scripts (shfmt)
just lint-docker      # Lint Dockerfile (hadolint)
just clean            # Prune dangling images
```

## Code Conventions

### Shell Scripts

- `set -euo pipefail` at the top of every script
- Quote all variable references: `"$VAR"` not `$VAR`
- Use `readonly` for constants, `local` for function variables
- Script header comment with description and usage
- No commented-out code -- use version control
- Lint with shellcheck, format with shfmt (2-space indent)

### Dockerfile

- `LABEL` for metadata (not `MAINTAINER`), include `org.opencontainers.image.source`
- Uppercase `AS` in multi-stage build aliases
- `HEALTHCHECK` on the final stage
- CMD uses JSON array form (exec form)
- Lint with hadolint

### Commits

Follow conventional commits: `type(scope): description`

## Architecture

The Docker image uses a two-stage build:

1. **base** (root): Installs system packages (Java 11, Python 3, curl), creates the `jupyter` user (UID 1000), downloads Coursier, and installs pip packages (JupyterLab, PySpark, spylon-kernel).
2. **jupyter** (non-root): Switches to `jupyter` user, installs Scala via Coursier, removes bootstrap artifacts.

The final image exposes port 8888 and runs `jupyter-lab`.

## Common Tasks

### Updating Spark/Scala Version

1. Edit `ENV SCALA_VERSION` and `ENV SPARK_VERSION` in `Dockerfile`
2. Update the default version in `scripts/build.sh` and `justfile`
3. Rebuild: `just build <new-version>`

### Adding a Python Package

Add `python3 -m pip --no-cache-dir install -U <package>` to the root phase in `scripts/bootstrap.sh` (inside the `if [[ $EUID == 0 ]]` block).

### Adding a System Package

Add the package name to the `microdnf -y install` line in `scripts/bootstrap.sh`.

## Files to Avoid Modifying

- `.github/workflows/` -- CI config; coordinate changes carefully
