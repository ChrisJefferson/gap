#!/bin/bash

set -ex
# Start doing a standard GAP build

./autogen.sh && ./configure && make -j4 && make bootstrap-pkg-full && cd pkg && ../bin/BuildPackages.sh

# Grab some extra files

for i in cyggcc_s-seh-1.dll cygiconv-2.dll cygncursesw-10.dll cygstdc++-6.dll cyggmp-10.dll cygintl-8.dll cygreadline7.dll cygwin1.dll; do
 cp /usr/bin/$i .
done;

for i in bash.exe  cygpath.exe  gap.exe  mintty.exe  sh.exe; do
  cp /usr/bin/$i .
done;