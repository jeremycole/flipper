Name: flipper
Version: 0.1.9
Release: 0
License: LGPL
URL: http://www.provenscaling.com/
Packager: Proven Scaling <software@provenscaling.com>
Summary: Manages a MySQL-based master-master (single active) failover system
Group: Applications/Databases
Buildroot: /tmp/flipper_buildroot
BuildArch: noarch

%description
Manages a MySQL-based master-master (single active) failover system 

%files
%defattr(-,root,root,-)
/usr/bin/flipper
/usr/lib/perl5/site_perl/Flipper/Metadata.pm
/usr/lib/perl5/site_perl/Flipper/Metadata/DBI.pm
/usr/lib/perl5/site_perl/Flipper/Metadata/Dummy.pm

