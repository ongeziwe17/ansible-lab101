SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

PYTHON ?= python3

INVENTORIES := ansible-playbooks/inventories/qa/hosts.yml ansible-playbooks/inventories/prod/hosts.yml

PLAYBOOK := ansible-playbooks/site.yml

.PHONY: install-ci lint validate-inventory syntax-check resolve validate-compose shellcheck validate-static validate

install-ci:
	$(PYTHON) -m pip install -r requirements-ci.txt
	@echo "PASS: CI dependencies installed"

lint:
	yamllint .
	ansible-lint ansible-playbooks/
	@echo "PASS: YAML and Ansible linting"

validate-inventory:
	$(PYTHON) scripts/validate-inventories.py
	@for inventory in $(INVENTORIES); do \
		echo "Validating inventory: $$inventory"; \
		ansible-inventory -i "$$inventory" --list >/dev/null; \
		ansible-inventory -i "$$inventory" --graph; \
	done
	@echo "PASS: Inventory validation"

syntax-check:
	@for inventory in $(INVENTORIES); do \
		echo "Checking playbook syntax with: $$inventory"; \
		ansible-playbook \
			-i "$$inventory" \
			$(PLAYBOOK) \
			--syntax-check; \
	done
	@echo "PASS: Playbook syntax"

resolve:
	@for inventory in $(INVENTORIES); do \
		echo "Resolving hosts and tasks with: $$inventory"; \
		ansible-playbook \
			-i "$$inventory" \
			$(PLAYBOOK) \
			--list-hosts; \
		ansible-playbook \
			-i "$$inventory" \
			$(PLAYBOOK) \
			--list-tasks; \
	done
	@echo "PASS: Playbook resolution"

validate-compose:
	docker compose -f compose.yml config --quiet
	@echo "PASS: Compose configuration"

shellcheck:
	@git ls-files \
		--cached \
		--others \
		--exclude-standard \
		-z \
		-- '*.sh' | \
	xargs -0 --no-run-if-empty shellcheck
	@echo "PASS: Shell scripts"

validate-static: lint validate-inventory syntax-check resolve shellcheck
	@echo "PASS: All static validation"

validate: validate-static validate-compose
	@echo "PASS: All repository validation"
