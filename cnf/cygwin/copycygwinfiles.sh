BASICS="/usr/bin/cygiconv*.dll /usr/bin/cyggmp*.dll /usr/bin/cygintl*.dll /usr/bin/cygreadline*.dll /usr/bin/cygwin1.dll" # Basics
BROWSE="/usr/bin/cygncurses*.dll  /usr/bin/cygpanel*.dll" # Browse
CPP="/usr/bin/cygstdc++*.dll /usr/bin/cyggcc*.dll" # C++ (json / semigroups)
ZMQ="/usr/bin/cygzmq*.dll /usr/bin/cygsodium*.dll" # ZeroMQ
for i in ${BASICS} ${BROWSE} ${CPP} ${ZMQ}; do
 cp $i .
done;

for i in bash.exe  cygpath.exe   mintty.exe  sh.exe gzip.exe gunzip; do
  cp /usr/bin/$i .
done;