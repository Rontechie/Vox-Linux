# Vox Linux 44 x86_64 Live/Install image. Build only from Fedora 44 repositories.
lang en_US.UTF-8
keyboard --xlayouts=us
timezone Etc/UTC --utc
rootpw --lock
firewall --enabled
selinux --enforcing
firstboot --disable
services --enabled=NetworkManager,bluetooth,firewalld --disabled=sshd
network --bootproto=dhcp --device=link --activate
bootloader --timeout=3 --append="rhgb quiet"
zerombr
clearpart --all --initlabel
reqpart --add-boot
autopart --type=btrfs

# liveuser autologin is confined to the live media by lorax/livemedia-creator.
user --name=liveuser --groups=wheel --lock

%packages --exclude-weakdeps
@core
anaconda
anaconda-gui
anaconda-install-env-deps
anaconda-live
firefox
sddm
hyprland
quickshell
vox-release
vox-logos
vox-backgrounds
vox-fonts
vox-hydro-shell
# UNIGETUI_PACKAGE_LINE
pipewire
pipewire-pulseaudio
wireplumber
NetworkManager
NetworkManager-wifi
bluez
bluez-tools
upower
polkit
xdg-desktop-portal
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
kitty
thunar
pavucontrol
nm-connection-editor
%end

%post --erroronfail
# Enable the live image services. The live autologin helper only creates a volatile
# SDDM drop-in while /run/initramfs/live exists; installed systems remain interactive.
systemctl enable NetworkManager bluetooth firewalld sddm vox-live-autologin.service
install -d -m 0755 /etc/skel/.config/hypr
install -d -m 0755 /etc/skel/.config/gtk-3.0
%end

%post --nochroot --erroronfail
# Provide an installation report with the Vox identity in Anaconda's logs.
echo "Vox Linux 44 / Hydro Desktop" > /tmp/vox-installer-product
%end
