#!/bin/bash

fastaFilePrefix=$1;  shift
merDir=$1;  shift
outDir=$1; shift
merSize=$1; shift
CPUS=$1; shift
CLUSTER=$1;  shift
PROCESS=$1;  shift
jfArgs=$@


### Set up environment
/bin/mkdir -p $outDir

cp $merDir/${fastaFilePrefix}* .
merFile=$outDir/$fastaFilePrefix.merged.k$merSize.$CLUSTER.$PROCESS.jf

histoFile=${merFile/.jf/.histo}
statsFile=${merFile/.jf/.stats}

#### Merge two files
./jellyfish merge $jfArgs -o $merFile  $fastaFilePrefix*.jf

### Compute histo and stats of merged file
./jellyfish histo --high 1000000000 -t $CPUS -o $histoFile $merFile
/bin/gzip $histoFile
./jellyfish stats -o $statsFile $merFile

## copy jf output file to /staging if you want
#mv $merFile $merDir/

## clean up
rm $merFile
rm $fastaFilePrefix*

exit
