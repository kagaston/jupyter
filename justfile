[private]
default:
    @just --list --unsorted

build version="3.3.1":
    docker build -t kagaston/jupyter:{{version}} -t kagaston/jupyter:latest .

push version="3.3.1":
    docker push --all-tags kagaston/jupyter

lint-shell:
    shellcheck scripts/*.sh

format-shell:
    shfmt -i 2 -ci -w scripts/

lint-docker:
    hadolint Dockerfile

clean:
    docker image prune -f
