#!/bin/sh

# THIS SHELL SCRIPT IS NOT INTENDED FOR END USERS OR FOR PEOPLE INSTALLING
# THE MODULES, BUT FOR THE AUTHOR'S USE WHEN UPDATING THE DATA FROM OFCOM'S
# AND libphonenumber's PUBLISHED DATA.

# first get OFCOM data
wget -q http://www.ofcom.org.uk/static/numbering/codelist.zip
# if UK/Data.pm doesn't exist, or OFCOM's stuff is newer ...
if test ! -e lib/Number/Phone/UK/Data.pm -o codelist.zip -nt lib/Number/Phone/UK/Data.pm; then
  echo rebuilding lib/Number/Phone/UK/Data.pm
  unzip -q codelist.zip
  perl build-data.uk
  cat Data.pm temp.db > lib/Number/Phone/UK/Data.pm
  rm s[0123456789]*.txt sabc.txt Data.pm temp.db
else
  echo lib/Number/Phone/UK/Data.pm is up-to-date
fi
rm codelist.zip

# now get an up-to-date libphonenumber
(cd libphonenumber && svn -q up) || svn co http://libphonenumber.googlecode.com/svn/trunk libphonenumber

# lib/Number/Phone/NANP/Data.pm doesn't exist, or if libphonenumber/resources/geocoding/en/1.txt is newer ...
if test ! -e lib/Number/Phone/NANP/Data.pm -o libphonenumber/resources/geocoding/en/1.txt -nt lib/Number/Phone/NANP/Data.pm; then
  echo rebuilding lib/Number/Phone/NANP/Data.pm
  perl build-data.nanp
else
  echo lib/Number/Phone/NANP/Data.pm is up-to-date
fi
