echo "Building mysql-backup"

echo "Recreating buildroot"
BUILDROOT=/tmp/flipper_buildroot

rm -fr $BUILDROOT

mkdir -p \
  $BUILDROOT/usr/bin \
  $BUILDROOT/usr/lib/perl5/site_perl/Flipper \
  $BUILDROOT/usr/lib/perl5/site_perl/Flipper/Metadata

echo "Copying files"
cp flipper $BUILDROOT/usr/bin
cp -R lib/Flipper $BUILDROOT/usr/lib/perl5/site_perl
find $BUILDROOT -name ".svn" | xargs rm -rf

echo "Building rpm"
sudo rpmbuild -bb ./flipper.spec

