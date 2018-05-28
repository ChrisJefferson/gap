#!/bin/bash

# Start doing a standard GAP build

./autogen.sh && ./configure && make -j4 && make bootstrap-pkg-full && (cd pkg && ../bin/BuildPackages.sh && ../bin/CygwinPackageHacks.sh)

# Get terminfo things

cnf/cygwin/instcygwinterminfo.sh

# Grab some extra files

BASICS="cygiconv-2.dll cyggmp-10.dll cygintl-8.dll cygreadline7.dll cygwin1.dll" # Basics
BROWSE="cygncursesw-10.dll cygncurses-10.dll cygpanel-10.dll cygpanelw-10.dll" # Browse
CPP="cygstdc++-6.dll" # C++ (json / semigroups)
ZMQ="cygzmg-5.dll cygsodium-23.dll" # ZeroMQ
for i in ${BASICS} ${BROWSE} ${CPP} ${ZMQ}; do
 cp /usr/bin/$i .
done;

# Exception handling (semigroups)
for i in /usr/bin/cyggcc*.dll; do
  cp $i .
done;

for i in bash.exe  cygpath.exe   mintty.exe  sh.exe; do
  cp /usr/bin/$i .
done;