Name:           vox-fonts
Version:        0.1.0
Release:        1%{?dist}
Summary:        Fonts used by the Vox Hydro desktop
License:        OFL
BuildArch:      noarch
Source0:        vox-fonts-%{version}.tar.gz

%description
Fonts staged for Vox, together with their upstream notices. Before building,
include only fonts with verified redistribution terms and preserve each
upstream license and copyright notice in the installed license directory.

%prep
%autosetup -n vox-fonts-%{version}

%build

%install
install -d %{buildroot}%{_datadir}/fonts/vox %{buildroot}%{_licensedir}/%{name}
find . -type f \( -iname '*.ttf' -o -iname '*.otf' -o -iname '*.woff2' \) -exec install -m 0644 '{}' %{buildroot}%{_datadir}/fonts/vox/ \;
find . -type f \( -iname 'OFL*' -o -iname 'LICENSE*' -o -iname 'COPYING*' \) -exec install -m 0644 '{}' %{buildroot}%{_licensedir}/%{name}/ \;

%files
%license %{_licensedir}/%{name}/*
%{_datadir}/fonts/vox/*

%changelog
* Tue Nov 24 2026 Vox Project <packages@vox.invalid> - 0.1.0-1
- Initial font collection; source tarball requires license audit
