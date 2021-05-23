#!/usr/bin/perl -w

### parse one or more jellyfish histograms and format for 3d plotting

## Usage bin/histograms2Table.pl <histo1|histo2|....>   1> table.tsv

use strict;
use Carp;
use English;
use Getopt::Long;
use File::Basename;

GetOptions (

            );

## might not scale well;  refactor to readdir /pattern/ to scale;
my @filelist = @ARGV[0..2];
#my @filelist = @ARGV[0..2,-5..-1];


my %histogramsFor;
foreach my $file (@filelist) {
    
    my $thisHistogram = readHistoFile($file);
    my ($genome,$k) = basename($file) =~ /^(.*)\.k(\d+)\..*$/;
    $histogramsFor{$genome} -> {$k} = $thisHistogram;
    print join ("\t", $genome, $k, $file), "\n";
}



foreach my $genome (sort keys %histogramsFor) {
    ## 1. get a list of all n for all k;
    #
    my %allKeys;
    foreach my $hashRef(values($histogramsFor{$genome})){
	map{$allKeys{$_} = 1;} keys(%$hashRef);
    }
    print scalar (keys %allKeys);


}



##########################################################
sub readHistoFile {
    my $file = shift;
    open HISTO, "zcat -f $file|" or
	croak "Can't read file $file";

    my $thisHistogram = {};
    my $maxN = 0;
    while(<HISTO>) {
	chomp;
	my ($n,$count) = split;
	$thisHistogram->{$n} = $count;
	$maxN = $n;
    }
    close HISTO;
    if (wantarray) {
	return ($thisHistogram, $maxN);
    }
    else {
	return $thisHistogram;
    }
}

__END__

 for k in {4..5}; do f=GCA_000001405.28_GRCh38.p13_genomic.k$k.*.gz; echo $f; zcat $f|head -10; done|perl -nale 'if (/^GCA/) {($genome,$k) = /^(.*)\.k(\d+)\..*$/; next}; $h{$genome}->{$k} ->{$F[0]} = $F[1]; END{foreach $genome (sort keys %h){print $genome; %dbW = %{$h{$genome}};print join "\n", keys %dbW;}   }'
GCA_000001405.28_GRCh38.p13_genomic
4
5

