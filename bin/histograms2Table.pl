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
my @filelist = @ARGV;


my %histogramsFor;
my %kValues; 
foreach my $file (@filelist) {
    
    my $thisHistogram = readHistoFile($file);
    my ($genome,$k) = basename($file) =~ /^(.*)\.k(\d+)\..*$/;
    $histogramsFor{$genome} -> {$k} = $thisHistogram;
    $kValues{$k} = 1;
    #print join ("\t", $genome, $k, $file), "\n";
}

## print header
my @kValues = sort {$a<=>$b} keys %kValues;
my @header = ("Genome", "x");
push @header, map{"k_$_"} @kValues;
print join("\t", @header), "\n";

foreach my $genome (sort keys %histogramsFor) {
    ############################################
    ## 1. get a list of repeat counts (the x-axis of the histogram)
    ##     for all k
    my %repeatCounts;  #
    my %histogramsForThisGenome = %{$histogramsFor{$genome}};
    foreach my $hashRef(values(%histogramsForThisGenome)) {
	map{$repeatCounts{$_} = 1;} keys(%$hashRef);
    }
    my @repeatCounts = sort {$a<=>$b} keys %repeatCounts;

    ############################################
    # 2.
    foreach my $repeatCnt (@repeatCounts) {
	my @numOccurences;
	foreach my $k (@kValues) {
	    my $val = $histogramsForThisGenome{$k}->{$repeatCnt} // 0;
	    push @numOccurences, $val;
	} ## foreach $k
	print join("\t", $genome, $repeatCnt,@numOccurences), "\n";
    } ## foreach repeatCnt
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

 bin/histograms2Table.pl outdir.8905338/GCA_000001405.28_GRCh38.p13_genomic.k*.hist*
5

