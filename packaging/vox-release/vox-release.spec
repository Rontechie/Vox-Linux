Name:           vox-release
Version:        44
Release:        1%{?dist}
Summary:        Vox Linux release identity and package repository configuration
License:        MIT
BuildArch:      noarch
Source0:        vox-release-44.tar.gz
Requires:       vox-repos
Provides:       system-release = 44
Provides:       system-release(releasever) = 44
Conflicts:      fedora-release
Obsoletes:      fedora-release < 44

%description
Vox release identity, issue banner and DNF repository configuration. Replace
Vox repo URL and signing key with the project's real HTTPS endpoint and public
key before building a public release.

%prep
%autosetup -n vox-release-%{version}

%build

%install
install -d %{buildroot}%{_prefix}/lib %{buildroot}%{_sysconfdir}/pki/rpm-gpg %{buildroot}%{_libexecdir} %{buildroot}/usr/lib/systemd/system
install -m 0644 os-release %{buildroot}%{_prefix}/lib/os-release
install -m 0644 issue %{buildroot}%{_sysconfdir}/issue
install -m 0755 vox-enable-live-autologin.sh %{buildroot}%{_libexecdir}/vox-enable-live-autologin
install -m 0644 vox-live-autologin.service %{buildroot}/usr/lib/systemd/system/vox-live-autologin.service

%files
%{_prefix}/lib/os-release
%config(noreplace) %{_sysconfdir}/issue
%{_libexecdir}/vox-enable-live-autologin
/usr/lib/systemd/system/vox-live-autologin.service

%changelog
* Tue Nov 24 2026 Vox Project <packages@vox.invalid> - 44-1
- Initial Vox release identity
