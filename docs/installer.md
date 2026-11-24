# Anaconda installation and branding

Keep Anaconda for Vox 0.1: it handles Fedora storage, UEFI/BIOS, encryption, networking, and Kickstart. Calamares would add a second installer stack and its own partition integration. The supplied Kickstart is an initial live-image recipe, not a fully unattended install recipe. Btrfs autopart is the default; leave Anaconda storage choices available for optional full-disk encryption. Do not add a preset user password.

The live-only autologin command is intended for live media. Never add an SDDM User/Session autologin configuration to the installed system. Verify the Kickstart directive on the Fedora 44 builder with ksvalidator and livemedia-creator; command support varies by release.

The ISO must replace Fedora release identity packages and artwork with Vox equivalents (or generic release/logo packages), including fedora-release, fedora-logos, and fedora-release-notes. Check exact subpackages and file ownership on Fedora 44 using dnf repoquery and rpm -qf. vox-release owns /usr/lib/os-release and /etc/issue; vox-logos supplies Plymouth, GRUB, desktop, and installer artwork; vox-backgrounds supplies the default wallpaper; vox-repos owns the repo and public key.

The Kickstart does not yet include a Vox Anaconda product image, so the GUI may still show Fedora branding. Properly brand the installer with product metadata/install class, Vox artwork, and product.img. Inspect Fedora 44's Anaconda files instead of copying paths from old RHEL documentation. Test the live installer and installed /usr/lib/os-release before describing Anaconda as Vox-branded.
