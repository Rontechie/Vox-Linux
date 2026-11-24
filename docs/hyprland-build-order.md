# Vox Hyprland RPM build order

Status: source planning for Fedora 44 x86_64, checked 2026-11-24. This is not a claim that Hyprland RPMs or an ISO have been built.

## Pin target

Target Hyprland **0.57.2** from the upstream release tag. Its CMake configuration requires these minimum library versions:

| Component | Hyprland 0.57.2 minimum | Fedora 44 audit result | Vox action |
|---|---:|---|---|
| aquamarine | 0.15.0 | No exact Fedora package candidate | Build Vox RPM |
| hyprlang | 0.6.7 | 0.6.4-4.fc44 | Build newer Vox RPM |
| hyprutils | 0.14.3 | 0.7.1-4.fc43 reported; too old | Build newer Vox RPM |
| hyprgraphics | 0.5.1 | 0.1.5-3.fc44 | Build newer Vox RPM |
| hyprcursor | 0.1.7 | 0.1.11-4.fc44 | Fedora package meets minimum; use it unless the source build proves incompatible |
| hyprwire | Not expressed as a CMake minimum | No exact Fedora package candidate | Build only if required by the pinned Hyprland source |
| hyprland-protocols | Verify from pinned source | runtime candidate absent; -devel 0.4.0-4.fc44 | Check its source minimum before choosing Fedora or Vox build |
| hyprwayland-scanner | Verify from pinned source | -devel 0.4.2-4.fc44 | Check its source minimum before choosing Fedora or Vox build |
| glaze-v7 | CMake has bundled fallback v7.2.0 | No exact Fedora package candidate | Prefer the upstream bundled fallback; do not invent a Fedora RPM dependency |

Release pages checked for the matching stack show aquamarine 0.16.0, hyprlang 0.6.8, hyprutils 0.14.3, hyprgraphics 0.6.0, hyprcursor 0.1.13, hyprwire 0.3.1, and hyprwayland-scanner 0.4.6. These are candidate pins, not yet a verified compatibility lock: verify every release tag against the Hyprland 0.57.2 subproject requirements, then record source URL, tag, and SHA-256 in the source manifest before building.

The Fedora package audit is in the successful GitHub Actions artifact `fedora-44-package-audit`; the audit checks Fedora repositories, not COPR or RPM Fusion.

## Build order

1. **hyprland-protocols and hyprwayland-scanner**: inspect the Hyprland tag's CMake/subproject declarations and build requirements; use Fedora's versions only if they meet the declared minimum.
2. **hyprutils 0.14.3**.
3. **hyprlang 0.6.8**.
4. **hyprcursor**: prefer Fedora 0.1.11 if it satisfies the pinned sources' ABI/API requirements; otherwise build 0.1.13.
5. **hyprgraphics 0.6.0**.
6. **aquamarine 0.16.0**.
7. **hyprwire 0.3.1**, if the pinned Hyprland source requires it as a separate dependency.
8. **Hyprland 0.57.2**.

Build each RPM in a clean Fedora 44 Mock root, publish dependency RPMs into the Vox staging repository, and resolve dependencies by installing the built RPMs into the next clean root. Keep Fedora-provided dependencies as Fedora dependencies; package only missing or too-old components in Vox. Do not use `--nodeps` or replace an installed Fedora library in place during development.

## Fedora 44 build commands

On a Fedora 44 x86_64 builder, install the build tools:

```sh
sudo dnf install -y mock rpm-build rpmdevtools spectool createrepo_c gnupg2
sudo usermod -aG mock "$USER"
```

Log out and back in after adding the user to the mock group. For each verified source package, prepare its SRPM and build it:

```sh
rpmdev-setuptree
spectool -g -R packaging/hyprland/SPECS/hyprutils.spec
rpmbuild -bs packaging/hyprland/SPECS/hyprutils.spec
mock -r fedora-44-x86_64 --rebuild ~/rpmbuild/SRPMS/hyprutils-*.src.rpm
```

Repeat per component in the order above, updating the spec path and SRPM name. Require a clean Mock success before promoting each RPM. Then create and sign the staging repo metadata:

```sh
createrepo_c --update repo/44/x86_64
gpg --armor --detach-sign --yes repo/44/x86_64/repodata/repomd.xml
```

Keep the signing key private; publish only the public key. Before this can run as written, add the verified specs and source manifest under `packaging/hyprland/`.

## Evidence and next gate

The Actions audit run succeeding means its Fedora 44 package queries completed; it does not mean the missing Hyprland stack has built. The next gate is to check the pinned Hyprland source's subproject versions and each component's Fedora build requirements, add checksum-pinned source entries and RPM specs, then build the dependency RPMs in Mock. Only after clean dependency resolution should the Hyprland RPM and desktop session be assembled.
