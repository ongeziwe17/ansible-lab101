# Summary

<!-- What changed? -->

## Reason for the change

<!-- Why is this change needed? -->

## Scope

- **Files or components affected:**
- **Ansible environment affected:** QA / production / both / none
- **Inventory groups affected:** linux_servers / webservers / appservers / monitoring / none

## Local validation performed

### Static validation

- [ ] `make validate` completed, or exceptions are explained below

### Manual Docker Desktop runtime validation (when applicable)

These checks run locally; GitHub Actions does **not** start the lab or contact managed nodes.

- [ ] Docker Compose lab started successfully
- [ ] Ansible inventory parsed successfully
- [ ] Managed nodes responded to Ansible ping
- [ ] Playbook completed successfully
- [ ] Playbook was executed twice for idempotence
- [ ] Change was tested against the QA inventory
- [ ] Not applicable; this change does not affect runtime behavior

**Validation notes or exceptions:**

## Risk

<!-- State the impact and likelihood of failure. -->

## Rollback approach

<!-- Usually: revert the squash commit, then re-run relevant QA checks. -->
