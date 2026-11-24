Name:           vox-backgrounds
Version:        0.1.0
Release:        1%{?dist}
Summary:        Default wallpapers for Vox Linux
License:        LicenseRef-Vox-Backgrounds
BuildArch:      noarch
Source0:        vox-backgrounds-%{version}.tar.gz

%description
Vox wallpapers. Every image must have a documented source and redistribution
license in LICENSES.md before release.

%prep
%autosetup -n vox-backgrounds-%{version}

%build

%install
install -d %{buildroot}%{_datadir}/backgrounds/vox
cp -a wallpapers/* %{buildroot}%{_datadir}/backgrounds/vox/

%files
%license LICENSES.md
%{_datadir}/backgrounds/vox/*

%changelog
* Tue Nov 24 2026 Vox Project <packages@vox.invalid> - 0.1.0-1
- Initial Vox backgrounds package
