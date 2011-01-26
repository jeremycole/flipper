# Copyright (c) 2007-2010, Proven Scaling LLC
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

%define flipper_version %(grep "\$main::VERSION" flipper | cut -d'"' -f2)

Name: flipper
Version: %{flipper_version}
Release: 0
License: LGPL
URL: http://www.provenscaling.com/
Packager: Proven Scaling <software@provenscaling.com>
Summary: Manages a MySQL-based master-master (single active) failover system
Group: Applications/Databases
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch
Requires: perl-DBD-mysql

%description
Manages a MySQL-based master-master (single active) failover system 

%define _builddir .

%prep
mkdir -p %{buildroot}/usr/bin
install -m 0755 flipper %{buildroot}/usr/bin
install -m 0755 flippersh %{buildroot}/usr/bin

mkdir -p %{buildroot}/usr/lib/perl5/site_perl/Flipper
install -m 0644 lib/Flipper/Metadata.pm %{buildroot}/usr/lib/perl5/site_perl/Flipper/
install -m 0644 lib/Flipper/Quiesce.pm %{buildroot}/usr/lib/perl5/site_perl/Flipper/

mkdir -p %{buildroot}/usr/lib/perl5/site_perl/Flipper/Metadata
install -m 0644 lib/Flipper/Metadata/CSV.pm %{buildroot}/usr/lib/perl5/site_perl/Flipper/Metadata/
install -m 0644 lib/Flipper/Metadata/DBI.pm %{buildroot}/usr/lib/perl5/site_perl/Flipper/Metadata/
install -m 0644 lib/Flipper/Metadata/Dummy.pm %{buildroot}/usr/lib/perl5/site_perl/Flipper/Metadata/

mkdir -p %{buildroot}/usr/lib/perl5/site_perl/Flipper/Quiesce
install -m 0644 lib/Flipper/Quiesce/KillAll.pm %{buildroot}/usr/lib/perl5/site_perl/Flipper/Quiesce/

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
/usr/bin/flipper
/usr/bin/flippersh
/usr/lib/perl5/site_perl/Flipper/Metadata.pm
/usr/lib/perl5/site_perl/Flipper/Metadata/CSV.pm
/usr/lib/perl5/site_perl/Flipper/Metadata/DBI.pm
/usr/lib/perl5/site_perl/Flipper/Metadata/Dummy.pm
/usr/lib/perl5/site_perl/Flipper/Metadata/YAML.pm
/usr/lib/perl5/site_perl/Flipper/Quiesce.pm
/usr/lib/perl5/site_perl/Flipper/Quiesce/KillAll.pm

