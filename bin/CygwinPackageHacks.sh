#!/bin/bash

# Some special hacks to support packages in Cygwin

# CARAT has a function named 'itoa'
(
    cd carat*
    find . -type f -name "*.c" -print0 | xargs -0 sed -i '' -e 's/itoa/carat_ITOA/g'
    find . -type f -name "*.h" -print0 | xargs -0 sed -i '' -e 's/itoa/carat_ITOA/g'
    make
    # The name 'Con' upsets windows.

    rm carat/bin/*/Con.exe carat/src/con.c
    # Rename Con.html to ConCarat.html
    find . -type f -name "*.html" -print0 | xargs -0 sed -i '' -e 's/Con.html/ConCarat.html/g'
    mv carat/tex/progs/Con.html carat/tex/progs/ConCarat.html
)

# nauty22's configure doesn't understand cygwin
( 
    cd grape &&
    sed -i -e 's/configure;/configure -host=cygwin;/g' Makefile.in &&
    ./configure && make 
)

# Two problems, need to put the cygsemigroups where we can find it
# And need to compile with gnu++11 to line up with GAP.
(
    # semigroups
    cd semigroups* &&
    for i in Makefile.* src/libsemigroups/Makefile.*; do
        sed -i -e 's/-std=c++11/-std=gnu++11/g' $i
    done &&
    ./autogen.sh &&
    ./configure &&
    make &&
    cp bin/lib/cyg* ../../.libs 
)
