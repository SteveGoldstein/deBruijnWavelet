#!/bin/bash

## Usage:  bin/computeQuantiles.sh <fraction> 
###########
## For each k,  "integrate" area under histogram curve stopping when the total >= total mers * fraction
###################################
fraction=$1 

### human
for i in {2..98}; do zcat results/2021-05-25/histogramTable.tsv.gz |perl -nale 'BEGIN{$col = shift; $fraction = shift;} if ($.==1){printf "%s\t", $F[$col];$max =  3110700000*$fraction; next}; last unless ($F[0] eq "GCA_000001405.28_GRCh38.p13_genomic");  $n+=$F[1]*$F[$col];if ($n >= $max) {print $F[1]; last}' $i $fraction; done > quantile_$fraction.human &

### mouse
for i in {2..98}; do zcat results/2021-05-25/histogramTable.tsv.gz |perl -nale 'BEGIN{$col = shift;$fraction = shift} if ($.==1){printf "%s\t", $F[$col];$max =  2654600000*$fraction; next}; next if ($F[0] eq "GCA_000001405.28_GRCh38.p13_genomic");  $n+=$F[1]*$F[$col];if ($n >= $max) {print $F[1]; last}' $i $fraction; done > quantile_$fraction.mouse &

#####################################
# original version:  same as above with fraction = .5
#for i in {2..98}; do zcat results/2021-05-25/histogramTable.tsv.gz |perl -nale 'BEGIN{$col = shift} if ($.==1){printf "%s\t", $F[$col];$max =  3110700000/2; next}; last unless ($F[0] eq "GCA_000001405.28_GRCh38.p13_genomic");  $n+=$F[1]*$F[$col];if ($n >= $max) {print $F[1]; last}' $i; done > median.human &

#for i in {2..98}; do zcat results/2021-05-25/histogramTable.tsv.gz |perl -nale 'BEGIN{$col = shift} if ($.==1){printf "%s\t", $F[$col];$max =  2654600000/2; next}; next if ($F[0] eq "GCA_000001405.28_GRCh38.p13_genomic");  $n+=$F[1]*$F[$col];if ($n >= $max) {print $F[1]; last}' $i; done > median.mouse &



