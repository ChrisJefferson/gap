    BindGlobal("AL_EXECUTABLE", Filename(DirectoriesSystemPrograms(), "gp"));
    BindGlobal("AL_EXECUTABLE", "/home/my/pari-2.5.0/gp");
    BindGlobal("AL_EXECUTABLE", "/cygdrive/c/Users/my/Downloads/gp-2-5-0");
    gap> LoadingPackage("alnuth");
    Loading  Alnuth 3.2.1 (Algebraic number theory and an interface to PARI/GP)
    by Bjoern Assmann,
       Andreas Distler (a.distler@tu-bs.de), and
       Bettina Eick (http://www.iaa.tu-bs.de/beick).
    maintained by:
       The GAP Team (support@gap-system.org).
    Homepage: https://gap-packages.github.io/alnuth
    Report issues at https://github.com/gap-packages/alnuth/issues
    true
    gap>
    gap> ReadPackage("Alnuth", "tst/testinstall.g");
    Architecture: aarch64-apple-darwin21.4.0-default64-kv8

    testing: GAPROOT/pkg/alnuth/tst/ALNUTH.tst
          66 ms (33 ms GC) and 11.0MB allocated for GAPROOT/pkg/alnuth/tst/ALNUTH.tst
    testing: GAPROOT/pkg/alnuth/tst/version.tst
          21 ms (21 ms GC) and 29.6KB allocated for GAPROOT/pkg/alnuth/tst/version.tst
    -----------------------------------
    total        87 ms (54 ms GC) and 11.0MB allocated
                  0 failures in 2 files

    #I  No errors detected while testing
    gap>
