#!/usr/bin/perl -w

### parse one or more jellyfish stats output files and format for 3d plotting

## Usage bin/stats2Table.pl <stats1|stats2|....>   1> table.tsv

use strict;
use Carp;
use English;
use Getopt::Long;
use File::Basename;

GetOptions (

            );

## Note: Inputing a list of files on cmd line might not scale well;
##    refactor to readdir /pattern/ to scale;
my @filelist = @ARGV;


my %statsFor;
my %kValues;

my @summaryStat = ();
foreach my $file (@filelist) {
    
    my $theseStats = readStatsFile($file);
    ## After reading the first file, capture the list of stats reported;
    if (@summaryStat == 0) {
	@summaryStat = sort keys %$theseStats;
    } ## if first time
    my ($genome,$k) = basename($file) =~ /^(.*)\.k(\d+)\..*$/;
    $statsFor{$genome} -> {$k} = $theseStats;
    $kValues{$k} = 1;
}

### print header
my @kValues = sort {$a<=>$b} keys %kValues;
my @header = ("Genome", "SummaryStat");
push @header, map{"k_$_"} @kValues;
print join("\t", @header), "\n";

#### print stats, line by line;
foreach my $genome (sort keys %statsFor) {
    foreach my $stat (@summaryStat) {

	my @output = ($genome,$stat);
	map{
	    push @output, $statsFor{$genome}->{$_} -> {$stat};
	} @kValues;
	print join("\t", @output), "\n";
    } ## foreach stat
}

##########################################################
sub readStatsFile {
    my $file = shift;
    open STATS, "zcat -f $file|" or
	croak "Can't read file $file";

    my $theseStats = {};

    while(<STATS>) {
	chomp;
	my ($label,$count) = split;
	$label =~ s/\://;
	$theseStats -> {$label} = $count;
    }
    close STATS;
    return $theseStats;

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

 bin/stats2Table.pl outdir.8905338/GCA_000001405.28_GRCh38.p13_genomic.k*.*stats

