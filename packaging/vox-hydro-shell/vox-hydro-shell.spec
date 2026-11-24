Name:           vox-hydro-shell
Version:        0.1.0
Release:        1%{?dist}
Summary:        Hydro Quickshell desktop shell configuration for Vox
License:        GPL-3.0-only
BuildArch:      noarch
Source0:        hydro-%{version}.tar.gz
Source1:        vox-hydro-integration-%{version}.tar.gz
Requires:       quickshell >= 0.2.1
Requires:       qt6-qtbase
Requires:       qt6-qtbase-gui
Requires:       qt6-qtdeclarative
Requires:       qt6-qtsvg
Requires:       qt6-qt5compat
Requires:       qt6-qtimageformats
Requires:       qt6-qtwayland
Requires:       qt6-qtpositioning
Requires:       qt6-qtshadertools
Requires:       kf6-kirigami
Requires:       pipewire
Requires:       wireplumber
Requires:       NetworkManager
Requires:       bluez
Requires:       upower
Requires:       libnotify
Requires:       jq
Requires:       curl
Requires:       python3
Requires:       python3-pillow
Requires:       python3-numpy
Requires:       polkit
Requires:       libsecret
Requires:       gnome-keyring
Requires:       ffmpeg-free
Requires:       hyprland
Requires:       vox-fonts
Requires:       vox-backgrounds
Requires:       matugen
Requires:       qt6qml(Quickshell.Hyprland)
Requires:       qt6qml(Quickshell.Services.Pipewire)
Requires:       qt6qml(Quickshell.Services.Mpris)
Requires:       qt6qml(Quickshell.Services.Polkit)
Requires:       qt6qml(Quickshell.Services.Notifications)
Requires:       qt6qml(Quickshell.Services.SystemTray)
Requires:       qt6qml(Quickshell.Services.UPower)
Requires:       wl-clipboard
Recommends:     playerctl
Recommends:     cliphist
Recommends:     grim
Recommends:     slurp
Recommends:     swappy
Recommends:     brightnessctl
Recommends:     ddcutil
Recommends:     ImageMagick
Recommends:     qt6-qtpositioning
Recommends:     qt6-qtshadertools
Recommends:     kf6-kirigami
Recommends:     hyprsunset
Recommends:     ydotool
Recommends:     songrec
Recommends:     cava
# Hyprland must resolve from the Vox repo/COPR. Optional desktop tools below
# remain Recommends until Fedora 44 availability and Hydro usage are verified.

%description
Installs the Hydro QML shell under /usr/share/hydro. This package includes the
Vox-patched Hydro source tree but does not include optional niri support. The
first-run profile symlinks the system tree into ~/.local/share/hydro.

%prep
%autosetup -n hydro-%{version}
mkdir -p integration
tar -xf %{SOURCE1} -C integration

%build
# QML is interpreted by Quickshell; no compiled build step.

%install
install -d %{buildroot}%{_datadir}/hydro
cp -a . %{buildroot}%{_datadir}/hydro/
install -d %{buildroot}%{_libexecdir} %{buildroot}%{_libdir}/systemd/user %{buildroot}%{_datadir}/wayland-sessions %{buildroot}%{_sysconfdir}/skel/.config/hypr
install -m 0755 integration/scripts/vox-hydro-first-login.sh %{buildroot}%{_libexecdir}/vox-hydro-first-login
install -m 0755 integration/scripts/vox-hydro-python-setup.sh %{buildroot}%{_libexecdir}/vox-hydro-python-setup
install -m 0644 integration/systemd/user/*.service integration/systemd/user/*.target %{buildroot}%{_libdir}/systemd/user/
install -m 0644 integration/session.desktop %{buildroot}%{_datadir}/wayland-sessions/vox-hyprland.desktop
install -m 0644 integration/hyprland.lua integration/appearance.lua %{buildroot}%{_sysconfdir}/skel/.config/hypr/
rm -f %{buildroot}%{_datadir}/hydro/.gitignore
find %{buildroot}%{_datadir}/hydro -type f \( -name '*.bak*' -o -name '*.pre*' -o -name '*.before*' -o -name '*.pyc' \) -delete
find %{buildroot}%{_datadir}/hydro -type d -name __pycache__ -prune -exec rm -rf {} +

%files
%license LICENSE
%dir %{_datadir}/hydro
%{_datadir}/hydro/*
%{_libexecdir}/vox-hydro-first-login
%{_libexecdir}/vox-hydro-python-setup
%{_libdir}/systemd/user/vox-hydro-session.target
%{_libdir}/systemd/user/vox-hydro-shell.service
%{_libdir}/systemd/user/vox-hydro-python-setup.service
%{_datadir}/wayland-sessions/vox-hyprland.desktop
%config(noreplace) %{_sysconfdir}/skel/.config/hypr/hyprland.lua\n%config(noreplace) %{_sysconfdir}/skel/.config/hypr/appearance.lua

%changelog
* Tue Nov 24 2026 Vox Project <packages@vox.invalid> - 0.1.0-1
- Initial Vox Hydro shell package
