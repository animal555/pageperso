#!/usr/bin/bash

folders="cs205-2223 cs205-2324 cs205-2425-files cscm12-2223 cscm12-2324 cscm12-2425 cscm41j-22 fdi-1819 talks"

for folder in $folders 
do
  ./mkDirListing.sh $folder
done
