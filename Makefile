.DEFAULT_GOAL := help
SHELL         := /usr/bin/env bash

.PHONY: help lint test fmt-check validate plan secrets-scan-staged lefthook-bootstrap lefthook-install hooks setup

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

lint: ## Lint workflow YAML (actionlint) + ktlint on the example
	@command -v actionlint >/dev/null 2>&1 && actionlint || \
	  python3 -c "import glob, yaml; [yaml.safe_load(open(f)) for f in glob.glob('.github/workflows/*.yml')]; print('YAML valid')"
	@if command -v java >/dev/null 2>&1; then \
	  cd examples/hello && ./gradlew --no-daemon --quiet ktlintCheck; \
	else \
	  echo "no JDK; skipping example ktlint"; \
	fi

test: ## Run tests in examples/hello
	@cd examples/hello && ./gradlew --no-daemon --quiet test

fmt-check: lint ## Alias for lint

validate: lint ## Alias for lint

plan: ## Not applicable
	@echo "INFO: not applicable for a workflow-only repo."

secrets-scan-staged: ## Scan staged files for secrets
	@command -v gitleaks >/dev/null 2>&1 || { echo "ERROR: gitleaks not found."; exit 1; }
	gitleaks protect --staged --redact

lefthook-bootstrap: ## Download lefthook binary to .bin/
	LEFTHOOK_VERSION="1.7.10" BIN_DIR=".bin" bash ./scripts/bootstrap_lefthook.sh

lefthook-install: ## Install git hooks via lefthook
	lefthook install

hooks: lefthook-bootstrap lefthook-install ## Bootstrap and install all git hooks

setup: hooks ## Install git hooks and verify required tools
	@echo "Dev environment ready."
