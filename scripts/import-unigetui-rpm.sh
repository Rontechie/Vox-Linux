#!/usr/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 VERSION REPO_DIR" >&2
  echo "VERSION is an exact upstream release tag such as 2026.3.4." >&2
  exit 2
fi
version=$1
repo_dir=$(realpath -m "$2")
root=$(cd "$(dirname "$0")/.." && pwd)
work="$root/work/vendor/unigetui-$version"
asset="UniGetUI.linux-x64.rpm"
base="https://github.com/Devolutions/UniGetUI/releases/download/v$version"
mkdir -p "$work" "$repo_dir"

curl --fail --location --retry 3 "$base/$asset" -o "$work/$asset"
curl --fail --location --retry 3 "$base/checksums.txt" -o "$work/checksums.txt"
expected=$(python3 - "$work/checksums.txt" "$asset" <<'PYHASH'
import re, sys
filename = sys.argv[2]
for line in open(sys.argv[1], encoding="utf-8"):
    if filename in line:
        match = re.search(r"\b([0-9a-fA-F]{64})\b", line)
        if match:
            print(match.group(1).lower())
            break
else:
    raise SystemExit("No SHA-256 entry for " + filename)
PYHASH
)
printf '%s  %s\n' "$expected" "$work/$asset" | sha256sum --check --strict
rpm --checksig --verbose "$work/$asset"
name=$(rpm -qp --queryformat '%{NAME}' "$work/$asset")
[[ -n "$name" ]] || { echo "Could not read RPM package Name" >&2; exit 1; }

# Re-sign the unchanged upstream RPM for Vox's DNF repo. Configure the Vox
# signing key in ~/.rpmmacros before running this import script.
rpmsign --addsign "$work/$asset"
rpm --checksig --verbose "$work/$asset"
install -m 0644 "$work/$asset" "$repo_dir/"
createrepo_c --update "$repo_dir"

# Generate a Kickstart copy with the exact Name read from the imported RPM.
ks_out="$root/work/kickstart/vox-live.ks"
mkdir -p "$(dirname "$ks_out")"
python3 - "$root/kickstart/vox-live.ks" "$ks_out" "$name" <<'PY'
from pathlib import Path
import sys
src, dst, name = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]
s = src.read_text()
marker = '# UNIGETUI_PACKAGE_LINE'
if s.count(marker) != 1:
    raise SystemExit('Expected exactly one UniGetUI package marker in Kickstart')
dst.write_text(s.replace(marker, name))
PY
printf 'Imported %s from %s; ISO Kickstart: %s\n' "$name" "$asset" "$ks_out"
