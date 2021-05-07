#!/bin/bash

fastaFile=$1;  shift
merDir=$1;  shift
merSize=$1; shift
CLUSTER=$1;  shift
PROCESS=$1;  shift
jfArgs=$@


merFile=${fastaFile/.fna.gz}
merFile=$merFile.k$merSize.$CLUSTER.$PROCESS.jf
    
echo "Running jellyfish count $jfArgs -o $merFile"
./jellyfish count $jfArgs -o $merFile  <(/bin/zcat $fastaFile)

## copy jf output file to /staging 
mv $merFile $merDir/
