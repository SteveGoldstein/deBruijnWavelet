#!/bin/bash

fastaFilePrefix=$1;  shift
merDir=$1;  shift
outDir=$1; shift
merSize=$1; shift
CPUS=$1; shift
CLUSTER=$1;  shift
PROCESS=$1;  shift
jfArgs=$@


/bin/mkdir -p --verbose $outDir
echo $fastaFilePrefix
ls -l $merDir/$fastaFilePrefix*

echo "cp $merDir/${fastaFilePrefix}* ."



cp $merDir/${fastaFilePrefix}* .
merFile=$outDir/$fastaFilePrefix.merged.k$merSize.$CLUSTER.$PROCESS.jf

histoFile=${merFile/.jf/.histo}
statsFile=${merFile/.jf/.stats}

echo "Running jellyfish merge  -o $merFile $fastaFilePrefix*.jf"
echo "output files: $histoFile $statsFile"

./jellyfish merge $jfArgs -o $merFile  $fastaFilePrefix*.jf

./jellyfish histo --high 1000000000 -t $CPUS -o $histoFile $merFile
/bin/gzip $histoFile

./jellyfish stats -o $statsFile $merFile



## copy jf output file to /staging

#mv $merFile $merDir/

rm $fastaFilePrefix*

