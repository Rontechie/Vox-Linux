Name:           vox-repos
Version:        44
Release:        1%{?dist}
Summary:        DNF repository definitions for Vox Linux 44
License:        MIT
BuildArch:      noarch
Source0:        vox-repos-44.tar.gz
Requires:       ca-certificates

%description
Vox DNF repository definition and the Vox repository public signing key.
The repository is disabled in this scaffold until the owner publishes its HTTPS
base URL and matching key. Enable it for release after those values are set.

%prep
%autosetup -n vox-repos-%{version}

%build

%install
install -d %{buildroot}%{_sysconfdir}/yum.repos.d %{buildroot}%{_sysconfdir}/pki/rpm-gpg
install -m 0644 vox.repo %{buildroot}%{_sysconfdir}/yum.repos.d/vox.repo
install -m 0644 RPM-GPG-KEY-vox %{buildroot}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-vox

%files
%config(noreplace) %{_sysconfdir}/yum.repos.d/vox.repo
%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-vox

%changelog
* Tue Nov 24 2026 Vox Project <packages@vox.invalid> - 44-1
- Initial Vox repository package
