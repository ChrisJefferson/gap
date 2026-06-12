#############################################################################
##
#W  testinst.g          GAP 4 package AtlasRep                  Thomas Breuer
##
##  This file contains those tests for the AtlasRep package that are
##  recommended for being executed after the package has been installed.
##  Currently just a few file transfers are tried in the case that
##  <C>AtlasOfGroupRepresentationsInfo.remote</C> is <K>true</K>,
##  and <C>AtlasOfGroupRepresentationsTestTableOfContentsRemoteUpdates</C> is
##  called.
##
##  <#GAPDoc Label="[1]{testinst.g}">
##  For checking the installation of the package, you should start &GAP;
##  and call
##  <P/>
##  <Log><![CDATA[
##  gap> ReadPackage( "atlasrep", "tst/testinst.g" );
##  ]]></Log>
##  <P/>
##  If the installation is o.k.&nbsp;then the &GAP; prompt appears without
##  anything else being printed;
##  otherwise the output lines tell you what should be changed.
##  <#/GAPDoc>
##

if LoadPackage( "atlasrep" ) <> true then
  Print( "#I  Package `atlasrep' cannot be loaded, no checks are possible.\n",
         "#I  Perhaps look at the output of ",
         "'DisplayPackageLoadingLog( PACKAGE_DEBUG )'.\n" );
else
  # Avoid binding global variables.
  AGR.TestInst:= function()
    local pref, bad, dir, filename, io, wgetpath, wget, msg, filenames, dirs,
          id, oldfiles, file, newid, i, upd;

    if UserPreference( "AtlasRep", "AtlasRepAccessRemoteFiles" ) <> true then
      Print( "#I  Package `atlasrep':  ",
             "Access to remote files is switched off,\n",
             "#I  (see the user preference 'AtlasRepAccessRemoteFiles'),\n",
             "#I  nothing is to check.\n" );
      return;
    fi;

    pref:= UserPreference( "AtlasRep", "AtlasRepDataDirectory" );
    if not IsEmpty( pref ) then
      # Test whether the data directories are writable.
      bad:= [];
      for dir in [ "dataext", "dataword", "datagens" ] do
        filename:= Concatenation( pref, dir );
        if not IsWritableFile( filename ) then
          Add( bad, dir );
        fi;
      od;
      if not IsEmpty( bad ) then
        Print( "#I  Package `atlasrep':  The subdirectories `", bad, "'\n",
               "#I  of `", pref, "' are not writable.\n" );
        return;
      fi;

      # Test transferring group generators in MeatAxe text format.
      # (Remove some files if necessary and access them again.)
      filenames:= [];
      dirs:= [ Directory( filename ) ];
      id:= OneAtlasGeneratingSet( "A5", Characteristic, 2 );
      if id <> fail then
        Append( filenames,
                List( id.identifier[2], name -> Filename( dirs, name ) ) );
      fi;
      filenames:= Filtered( filenames, x -> x <> fail );
      if IsEmpty( filenames ) then
        Print( "#I  Package `atlasrep':  ",
               "Transferring data files seems not to work.\n",
               "#I  Perhaps call\n",
               "#I  `SetUserPreference( \"AtlasRep\", ",
               "\"AtlasRepAccessRemoteFiles\", false )'\n" );
      else
        oldfiles:= List( filenames, StringFile );
        for file in filenames do
          RemoveFile( file );
        od;
        newid:= OneAtlasGeneratingSet( "A5", Characteristic, 2 );
        if newid = fail or id <> newid then
          # Restore the files.
          for i in [ 1 .. Length( filenames ) ] do
            FileString( filenames[i], oldfiles[i] );
          od;
          Print( "#I  Package `atlasrep':  ",
                 "Transferring data files does not work.\n",
                 "#I  Perhaps call\n",
                 "#I  `SetUserPreference( \"AtlasRep\", ",
                 "\"AtlasRepAccessRemoteFiles\", false )'\n" );
        else
          # Print information about data files to be removed/updated.
          # (This is for those who had installed an earlier package version.)
          # Note that calling this function requires access to a remote file.
          upd:= AtlasOfGroupRepresentationsTestTableOfContentsRemoteUpdates();
          if upd <> fail and not IsEmpty( upd ) then
            Print( "#I  Remove the following files:\n", upd, "\n" );
          fi;
        fi;
      fi;
    fi;
  end;

  AGR.TestInst();
fi;


#############################################################################
##
#E

