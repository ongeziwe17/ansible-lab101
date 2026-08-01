#!/usr/bin/env python3
"""Validate the environment inventory group contract without contacting hosts."""

from pathlib import Path
import sys

import yaml


INVENTORY_ROOT = Path("ansible-playbooks/inventories")
REQUIRED_ENVIRONMENTS = ("qa", "prod")
LEAF_GROUPS = ("webservers", "appservers", "monitoring")


def mapping(value: object) -> bool:
    """Return whether a value is a YAML mapping."""
    return isinstance(value, dict)


def validate(path: Path) -> list[str]:
    """Return contract errors found in one inventory."""
    try:
        document = yaml.safe_load(path.read_text(encoding="utf-8"))
    except (OSError, yaml.YAMLError) as error:
        return [f"cannot read valid YAML: {error}"]

    errors: list[str] = []
    if not mapping(document):
        return ["inventory root must be a mapping"]

    all_group = document.get("all")
    if not mapping(all_group):
        return ["'all' must be a mapping"]
    all_children = all_group.get("children")
    if not mapping(all_children):
        return ["'all.children' must be a mapping"]
    linux_servers = all_children.get("linux_servers")
    if not mapping(linux_servers):
        return ["missing or incorrectly structured 'all.children.linux_servers' group"]
    children = linux_servers.get("children")
    if not mapping(children):
        return ["'all.children.linux_servers.children' must be a mapping"]

    for group in LEAF_GROUPS:
        group_data = children.get(group)
        location = f"all.children.linux_servers.children.{group}"
        if not mapping(group_data):
            errors.append(f"missing or incorrectly structured '{location}' group")
        elif "hosts" not in group_data or not mapping(group_data["hosts"]):
            errors.append(f"'{location}.hosts' must be a mapping (an empty mapping is valid)")
    return errors


def main() -> int:
    """Validate every environment inventory and report CI-friendly results."""
    failed = False
    inventories = sorted(INVENTORY_ROOT.glob("*/hosts.yml"))
    discovered = {inventory.parent.name for inventory in inventories}
    for environment in REQUIRED_ENVIRONMENTS:
        if environment not in discovered:
            failed = True
            expected = INVENTORY_ROOT / environment / "hosts.yml"
            print(f"::error file={expected}::required {environment} inventory is missing")

    for inventory in inventories:
        errors = validate(inventory)
        if errors:
            failed = True
            for error in errors:
                print(f"::error file={inventory}::{error}")
            print(f"FAIL: {inventory}")
        else:
            print(f"PASS: {inventory}")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
