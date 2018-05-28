#!/bin/bash

# Start doing a standard GAP build

./autogen.sh && ./configure && make -j4 && make bootstrap-pkg-full && (cd pkg && ../bin/BuildPackages.sh && ../bin/CygwinPackageHacks.sh)

# Get terminfo things

cnf/cygwin/instcygwinterminfo.sh

# Grab other files

cnf/cygwin/copycygwinfiles.sh
