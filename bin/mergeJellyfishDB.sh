#!/bin/bash

fastaFilePrefix=$1;  shift
merDir=$1;  shift
outDir=$1; shift
merSize=$1; shift
CPUS=$1; shift
CLUSTER=$1;  shift
PROCESS=$1;  shift
jfArgs=$@

cp $merDir/$fastFilePrefix* .
merFile=$fastaFilePrefix.merged
merFile=$merFile.k$merSize.$CLUSTER.$PROCESS.jf
    
#echo "Running jellyfish count $jfArgs -o $merFile"
./jellyfish merge $jfArgs -o $merFile  $fastaFilePrefix*.jf

## copy jf output file to /staging
mv $merFile $merDir/
rm $fastaFilePrefix*

