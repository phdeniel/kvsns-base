%define sourcename @CPACK_SOURCE_PACKAGE_FILE_NAME@
%global dev_version %{lua: extraver = string.gsub('@LIBKVSNS_EXTRA_VERSION@', '%-', '.'); print(extraver) }

Name: libkvsns 
Version: @LIBKVSNS_BASE_VERSION@
Release: 0%{dev_version}%{?dist}
Summary: Library to access to a namespace inside a KVS
License: LGPLv3 
Group: Development/Libraries
Url: http://github.com/phdeniel/libkvsns
Source: %{sourcename}.tar.gz
BuildRequires: cmake libini_config-devel
BuildRequires: gcc
Requires: libini_config
Provides: %{name} = %{version}-%{release}

# Remove implicit dep to libkvsns (which prevent from building libkvsns-utils
%global __requires_exclude ^libkvsns\\.so.*$

%define on_off_switch() %%{?with_%1:ON}%%{!?with_%1:OFF}

%description
The libkvsns is a library that allows of a POSIX namespace built on top of
a Key-Value Store.

%package devel
Summary: Development file for the library libkvsns
Group: Development/Libraries
Requires: %{name} = %{version}-%{release} pkgconfig
Provides: %{name}-devel = %{version}-%{release}

%description devel
The libkvsns is a library that allows of a POSIX namespace built on top of
a Key-Value Store.
This package contains tools for libkvsns.

%package utils
Summary: Development file for the library libkvsns
Group: Development/Libraries
Requires: %{name} = %{version}-%{release} pkgconfig
Requires: libkvsns
Provides: %{name}-utils = %{version}-%{release}

%description utils
The libkvsns is a library that allows of a POSIX namespace built on top of
a Key-Value Store.
This package contains the tools for libkvsns.

%prep
%setup -q -n %{sourcename}

%build
cmake -DEXT_BUILD=@EXT_BUILD@ . 


make %{?_smp_mflags} || make %{?_smp_mflags} || make

%install

mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_libdir}
mkdir -p %{buildroot}%{_libdir}/pkgconfig
mkdir -p %{buildroot}%{_includedir}/iosea
mkdir -p %{buildroot}%{_sysconfdir}/iosea.d
install -m 644 include/iosea/kvsns.h  %{buildroot}%{_includedir}/iosea
install -m 644 kvsns/libkvsns.so %{buildroot}%{_libdir}
install -m 644 libkvsns.pc  %{buildroot}%{_libdir}/pkgconfig
install -m 755 kvsns_shell/kvsns_busybox %{buildroot}%{_bindir}
install -m 755 kvsns_shell/kvsns_cp %{buildroot}%{_bindir}
install -m 755 kvsns_hsm/kvsns_hsm %{buildroot}%{_bindir}
install -m 755 kvsns_script/kvsns_script %{buildroot}%{_bindir}
install -m 755 scripts/cp_put.sh %{buildroot}%{_bindir}
install -m 755 scripts/cp_get.sh %{buildroot}%{_bindir}
install -m 755 kvsns_attach/kvsns_attach %{buildroot}%{_bindir}
install -m 644 kvsns.ini %{buildroot}%{_sysconfdir}/iosea.d

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_libdir}/libkvsns.so*
%config(noreplace) %{_sysconfdir}/iosea.d/kvsns.ini

%files devel
%defattr(-,root,root)
%{_libdir}/pkgconfig/libkvsns.pc
%{_includedir}/iosea/kvsns.h

%files utils
%defattr(-,root,root)
%{_bindir}/kvsns_busybox
%{_bindir}/kvsns_cp
%{_bindir}/kvsns_attach
%{_bindir}/kvsns_hsm
%{_bindir}/kvsns_script
%{_bindir}/cp_put.sh
%{_bindir}/cp_get.sh
 
%changelog
* Wed Nov  3 2021 Philippe DENIEL <philippe.deniel@cea.fr> 1.3.0
- Better layering between kvsns, kvsal aand extstore. 

* Mon Jan  4 2021 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.11
- Build libkvsns does not requires redis or hiredis, a special rpm is created

* Fri Dec 18 2020 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.10
- Support for COTRX-MOTR as a backed for both kvsal and extstore

* Tue Aug  4 2020 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.9
- Rename extstore_crud_cache_cmd and add objstore_cmd

* Mon Aug  3 2020 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.8
- Change dependencies so that libkvsns-utils can be built

* Wed Jun 24 2020 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.7
- Use dlopen and dlsym to manage kvsal

* Wed Jun 24 2020 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.6
- Use dlopen and dlsym to manage extstore

* Tue Jun 23 2020 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.5
- More modularity in crud_cache

* Tue Jun 16 2020 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.4
- Add crud_cache feature for object stores that support only put/get/delete

* Tue Oct 24 2017 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.3
- Support RADOS as an object store

* Tue Jun 27 2017 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.2
- Modification of internal API

* Tue Jun 20 2017 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.1
- Some bug fixed

* Tue Jun 13 2017 Philippe DENIEL <philippe.deniel@cea.fr> 1.2.0
- Add support for config file via libini_config

* Fri Jun  2 2017 Philippe DENIEL <philippe.deniel@cea.fr> 1.1.3
- Add kvsns_cp

* Fri Jun  2 2017 Philippe DENIEL <philippe.deniel@cea.fr> 1.1.2
- Add kvsns_attach feature

* Wed Nov 16 2016 Philippe DENIEL <philippe.deniel@cea.fr> 1.0.1
- Release candidate

* Mon Aug  1 2016 Philippe DENIEL <philippe.deniel@cea.fr> 0.9.2
- Source code tree refurbished

* Mon Jul 25 2016 Philippe DENIEL <philippe.deniel@cea.fr> 0.9.1
- First alpha version
