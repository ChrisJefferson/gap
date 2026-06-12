
#############################################################################
##
##  Load utilities implemented elsewhere.
##
LoadPackage( "browse" : OnlyNeeded );
LoadPackage( "ctbllib" : OnlyNeeded );
LoadPackage( "atlasrep" : OnlyNeeded ); # because of 'atlasrep/gap/utlmrkup.g'
LoadPackage( "genus" :OnlyNeeded );     # because of 'SizesSimpleGroupsInfo'

if IsPackageMarkedForLoading( "spinsym", "" ) then
  # We do not want to deal with extensions.
  Error( "please start GAP with the option -A" );
fi;


#############################################################################
##
##  Load the list 'DecMatMap' and the functions themselves.
##
ReadPackage( "ctbllib", "ctbltoc/gap/decmap.g" );
ReadPackage( "ctbllib", "ctbltoc/gap/htmltbl.g" );


#############################################################################
##
#E

