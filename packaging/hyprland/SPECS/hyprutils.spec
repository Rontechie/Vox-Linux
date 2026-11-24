%global forgeurl https://github.com/hyprwm/hyprutils

Name:           hyprutils
Version:        0.14.3
Release:        1%{?dist}
Summary:        Small C++ utility library used by the Hypr ecosystem
License:        BSD-3-Clause
URL:            %{forgeurl}
Source0:        %{forgeurl}/archive/refs/tags/v%{version}/%{name}-%{version}.tar.gz

BuildRequires:  cmake
BuildRequires:  gcc-c++
BuildRequires:  ninja-build
BuildRequires:  pkgconfig
BuildRequires:  pkgconfig(pixman-1)

%description
Hyprutils is a small C++ library providing utilities used across the Hypr
ecosystem.

%package devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description devel
Headers and pkg-config metadata for building software against Hyprutils.

%prep
%autosetup -n %{name}-%{version}

%build
%cmake -GNinja -DBUILD_TESTING=OFF
%cmake_build

%install
%cmake_install

%files
%license LICENSE
%{_libdir}/libhyprutils.so.13
%{_libdir}/libhyprutils.so.13.*

%files devel
%{_includedir}/hyprutils/
%{_libdir}/libhyprutils.so
%{_libdir}/pkgconfig/hyprutils.pc

%changelog
* Tue Nov 24 2026 RonTech <packages@rontech.example> - 0.14.3-1
- Initial Vox Fedora 44 build of upstream Hyprutils
