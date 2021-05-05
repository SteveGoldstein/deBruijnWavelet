#!/bin/bash

tarFile=$1;  shift
jfMerDir=$1; shift
CLUSTER=$1;  shift
PROCESS=$1;  shift
jfArgs=$@

localCopy=$(basename $tarFile)
/bin/cp $tarFile $localCopy
#/bin/scp transfer.chtc.wisc.edu:$tarFile $localCopy
tar zxf $localCopy
rm $localCopy
mkdir mers

for sampleFile in samples/*.fq.gz
do
    merFile=$(basename $sampleFile)
    merFile=${merFile/.fq.gz/.jf}
    
    echo "bin/jellyfish count $jfArgs -o mers/$merFile"
    bin/jellyfish count $jfArgs -o mers/$merFile  <(/bin/zcat $sampleFile)

done

merTarFile=${localCopy/samples.*/jfMers.$CLUSTER.$PROCESS.tgz}

echo "tar zcf $merTarFile mers/*"
tar zcf $merTarFile mers/*

echo "cp $merTarFile $jfMerDir"
mv $merTarFile $jfMerDir/

###  bin/runJellyfishOnEachSample.sh $f /mnt/gluster/sgoldstein/Projects/IdentifyGBSSamples/jellyfish/jf-21 "-C -m 21 -t 4 -s 10G" 2 3
