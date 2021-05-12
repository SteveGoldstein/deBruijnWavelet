#!/bin/bash

fastaFile=$1;  shift
outDir=$1;  shift
merSize=$1; shift
CPUS=$1;    shift
CLUSTER=$1;  shift
PROCESS=$1;  shift

jfArgs=$@


merFile=${fastaFile/.fna.gz}
merFile=$outDir/$merFile.k$merSize.$CLUSTER.$PROCESS.jf
histoFile=${merFile/.jf/.histo}
statsFile=${merFile/.jf/.stats}

mkdir $outDir
echo "Running jellyfish count $jfArgs -o $merFile"
./jellyfish count $jfArgs -o $merFile  <(/bin/zcat $fastaFile)


echo "Running jellyfish histo and stats"
./jellyfish histo --high 1000000 -t $CPUS -o $histoFile $merFile
/bin/gzip $histoFile

./jellyfish stats -o $statsFile $merFile


## copy jf output file to /staging 
#mv $merFile $merDir/
rm $merFile
