# Fedora 44 package audit

The following Fedora 44 names are confirmed in official Fedora package metadata at the time of writing: `quickshell` (0.2.1^git20260209.dacfa9d-5.fc44), `niri`, `matugen` (RPM is named `matugen`, source package `rust-matugen`), `qt6-qt5compat`, `qt6-qtpositioning`, `qt6-qtwayland`, `kf6-kirigami` (verify exact subpackage), `python3-opencv`, and Qt 6 base/declarative/SVG. Fedora's Quickshell build declares `qt6qml(Quickshell.Hyprland)`, Bluetooth, MPRIS, notifications, PAM, PipeWire, Polkit, SystemTray, UPower, Wayland, and `PolicyKit-authentication-agent` provides.

A search result did not confirm Fedora 44 Hyprland; Fedora package pages exposed only older Fedora branches. Treat `hyprland` as external until `dnf repoquery --available hyprland` succeeds in a real Fedora 44 environment. Use a maintained Fedora 44 COPR or build it in Vox's repo; pin and rebuild the full Hyprland ecosystem together. Do not assume COPR packages are ABI-compatible with Fedora's Qt stack.

## Verify every requested dependency on the actual builder

```sh
sudo dnf clean metadata
for p in qt6-qtbase qt6-qtdeclarative qt6-qt5compat qt6-qtsvg qt6-qtimageformats qt6-qtwayland qt6-qtpositioning qt6-qtshadertools kf6-kirigami quickshell hyprland niri pipewire wireplumber NetworkManager bluez upower libnotify jq curl python3 python3-pillow python3-numpy polkit matugen cliphist wl-clipboard grim slurp swappy ImageMagick brightnessctl ddcutil playerctl cava hyprsunset ydotool songrec libsecret gnome-keyring libqalculate rsms-inter-fonts ffmpeg-free
 do
   echo "===== $p ====="
   dnf repoquery --available --qf '%{name} %{evr} %{repoid}' "$p" || true
   dnf info "$p" || true
done
```

For a command/file capability:

```sh
dnf provides '*/hyprctl'
dnf provides '*/qs'
dnf provides '*/matugen'
dnf provides '*/grim'
dnf provides '*/ffmpeg'
```

Do not use only `dnf search`: verify that the package resolves from enabled `fedora`/`updates` repositories. Save output as the release's package audit artifact.

## Availability boundary

- Fedora-confirmed: Quickshell, niri, matugen, Qt packages above, Python OpenCV bindings. Package names `python3-pillow` and `python3-numpy` are standard Fedora package names; still repoquery on the target arch.
- `hyprland`: not confirmed by the official Fedora 44 package pages found in this audit; use a maintained COPR or Vox repo only after testing exact Fedora 44 builds.
- RPM Fusion: full `ffmpeg` is not Fedora's `ffmpeg-free`; enable RPM Fusion Free only if Hydro actually needs codecs excluded from ffmpeg-free. Prefer `ffmpeg-free` and inspect `ffmpeg -codecs` for the exact features Hydro uses. Do not add full ffmpeg as an unconditional shell dependency.
- Font family names are not dependable RPM names. `JetBrains Mono Nerd`, Readex Pro, Space Grotesk, and Material Symbols Rounded should be packaged by Vox only after sourcing official files and including each upstream license/notice. Nerd Font-patched JetBrains Mono is a separate derivative from regular JetBrains Mono. Fedora's `rsms-inter-fonts` availability must be checked with repoquery.
- `songrec` was found as a COPR build, not verified in Fedora 44 official repositories. Treat it as optional external package; do not make it a core dependency.
- COPR or bundled: any name for which the loop returns no package. For fonts, use `vox-fonts`; for matugen Python scripts, prefer Fedora RPM Python modules if present, otherwise ship a locked venv generated at first login (see below).

`dnf provides` for each runtime QML module can be checked with `dnf provides '*/qt6/qml/Quickshell/Hyprland/qmldir'` and `rpm -q --whatprovides 'qt6qml(Quickshell.Hyprland)'` after installation.

For the exact package names above, on the Fedora 44 builder run these three checks (save the output with the build manifest):

    while read -r p; do
      echo "===== $p ====="
      dnf search "$p" || true
      dnf info "$p" || true
      dnf provides "$p" || true
    done < package-audit.txt

`dnf provides` reports a file/capability provider; for runtime QML capabilities use `dnf repoquery --whatprovides 'qt6qml(Quickshell.Hyprland)'` as well. The official package-site search confirms the specific versions listed in this document, but cannot substitute for a target repo transaction test.


UniGetUI is not listed in the Fedora 44 package search performed for this plan. Upstream distributes official Linux RPMs for x64 and ARM64; Vox targets x86_64 and imports the exact upstream RPM into its repo. Upstream says Linux supports DNF and other managers and needs glibc 2.27+. Package-manager selection must be reviewed for Vox: DNF is the supported system package path; do not enable unrelated managers by default. UniGetUI is MIT-licensed. Its optional Agent Skills extension is off by default; leave it disabled to keep AI features out of Hydro/Vox.
