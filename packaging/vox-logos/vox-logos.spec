Name:           vox-logos
Version:        0.1.0
Release:        1%{?dist}
Summary:        Vox logos and boot artwork
License:        LicenseRef-Vox-Logos
BuildArch:      noarch
Source0:        vox-logos-%{version}.tar.gz

%description
Vox-authored logos for the desktop, boot loader, Plymouth and installer. The
source tarball must contain LICENSE and artwork source files.

%prep
%autosetup -n vox-logos-%{version}

%build

%install
install -d %{buildroot}%{_datadir}/pixmaps/vox %{buildroot}%{_datadir}/icons/hicolor/scalable/apps
cp -a icons/* %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/
cp -a pixmaps/* %{buildroot}%{_datadir}/pixmaps/vox/

%files
%license LICENSE
%{_datadir}/pixmaps/vox/*
%{_datadir}/icons/hicolor/scalable/apps/*

%changelog
* Tue Nov 24 2026 Vox Project <packages@vox.invalid> - 0.1.0-1
- Initial Vox artwork package
