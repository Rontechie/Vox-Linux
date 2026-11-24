#!/usr/bin/env bash
set -uo pipefail

packages_file=${1:-package-audit.txt}
output_file=${2:-package-audit-results.txt}

if [[ ! -r "$packages_file" ]]; then
  echo "Cannot read package list: $packages_file" >&2
  exit 2
fi
command -v dnf5 >/dev/null || { echo "dnf5 is required" >&2; exit 2; }

{
  echo "Vox Fedora 44 repository package audit"
  echo "Host: $(cat /etc/fedora-release 2>/dev/null || true)"
  echo "Repositories:"
  dnf5 repolist --enabled || true

  while IFS= read -r package || [[ -n "$package" ]]; do
    [[ -z "$package" || "$package" == \#* ]] && continue
    echo
    echo "===== $package ====="

    echo "--- Exact package candidates (fedora, updates) ---"
    exact=$(dnf5 repoquery --available --repo fedora --repo updates \
      --qf '%{name} %{evr} %{repoid}' "$package" 2>&1 || true)
    if [[ -n "$exact" ]]; then
      printf '%s\n' "$exact"
    else
      echo "NO EXACT PACKAGE MATCH"
    fi

    echo "--- dnf5 search ---"
    dnf5 search --available "$package" 2>&1 || true
    echo "--- dnf5 info ---"
    dnf5 info --available "$package" 2>&1 || true
    echo "--- dnf5 provides ---"
    dnf5 provides "$package" 2>&1 || true
  done < "$packages_file"
} | tee "$output_file"
