#!/bin/bash

fastaFile=$1;  shift
merDir=$1;  shift
merSize=$1; shift
CPUS=$1;    shift
CLUSTER=$1;  shift
PROCESS=$1;  shift

jfArgs=$@


merFile=${fastaFile/.fna.gz}
merFile=$merFile.k$merSize.$CLUSTER.$PROCESS.jf
histoFile=${merFile/.jf/.histo}
statsFile=${merFile/.jf/.stats}

echo "Running jellyfish count $jfArgs -o $merFile"
./jellyfish count $jfArgs -o $merFile  <(/bin/zcat $fastaFile)


echo "Running jellyfish histo and stats"
./jellyfish histo --high 1000000 -t $CPUS -o $histoFile $merFile
./jellyfish stats -t $CPUS -o $statsFile $merFile

/bin/gzip $histoFile
## copy jf output file to /staging 
#mv $merFile $merDir/
rm $merFile
