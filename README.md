# Vox Linux (Fedora 44)

Vox is an independent Fedora remix. First target: x86_64 live/install ISO, Hyprland + Hydro, SDDM, NetworkManager, PipeWire, SELinux enforcing, firewalld enabled. niri is a later upgrade and is intentionally not included in the first image.

## Source inputs

The provided ZIP is imported under `hydro/`. The user confirms Hydro is GPL-3.0; see `LICENSE`. Backup variants and AI-provider artwork/helpers were excluded. Welcome text is changed to Vox and the included Hyprland shortcuts are based on your Lua files. No niri support is enabled in 0.1. Preserve the separate notices bundled with fonts and assets; `docs/source-audit.md` records items still needing provenance review.

## Build host and Fedora package checks

Use a Fedora 44 x86_64 build host with the Fedora 44 repos enabled. Do not build from a later Fedora release. Check exact package solvability with the commands in `docs/packages.md`. Fedora 44 package metadata confirms Quickshell 0.2.1 git snapshot and the listed Quickshell QML integrations; it does not guarantee the source requirements of Hydro.

The concrete remote build procedure, Dockerfile, gcloud commands, RPM signing, and QEMU/virt-manager launch command are in `docs/build.md`. UniGetUI is imported as an upstream RPM with `scripts/import-unigetui-rpm.sh`; it is not a Fedora package. Do package resolution on Fedora 44 before building; the `.invalid` repo URL and absent public key are intentional placeholders. GitHub Actions currently checks RPM spec parsing only; it does not build or publish an ISO.
## Release checklist

1. Build RPMs in a clean Fedora 44 mock root; sign with a dedicated Vox RPM signing key.
2. Publish RPMs, `repodata/`, and detached `repomd.xml` signature over HTTPS.
3. Build ISO in a clean Fedora 44 VM; run the checklist in `docs/qa.md`.
4. Sign ISO with `gpg --detach-sign --armor vox-44.0.0-x86_64.iso`; publish checksum and signature.
5. Publish source RPMs, source tarballs, licenses, build manifest, and package NEVRAs beside the ISO.

## Licenses
Under the license of GPL-3.0(2007) 
© 2026 RonTech. All rights reserved.
