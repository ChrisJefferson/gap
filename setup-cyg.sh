#!/bin/bash

set -ex
# Start doing a standard GAP build

./autogen.sh && ./configure && make -j4 && make bootstrap-pkg-full && cd pkg && ../bin/BuildPackages.sh

# Grab some extra files

for i in
cygiconv-2.dll cyggmp-10.dll cygintl-8.dll cygreadline7.dll cygwin1.dll # Basics
 cygncursesw-10.dll cygncurses-10.dll cygpanel-10.dll cygpanelw-10.dll # Browse
 cygstdc++-6.dll # C++ (json / semigroups)
  cyggcc*.dll # Exception handling (semigroups)
; do
 cp /usr/bin/$i .
done;

for i in bash.exe  cygpath.exe   mintty.exe  sh.exe; do
  cp /usr/bin/$i .
done;