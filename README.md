# deBruijnWavelet
Experiments with a wavelet-motivated representation of genomic DNA sequence data
SplitFastA branch:  jelllyfish count -m 100 for human requires 100G of RAM.  To scale,
split the FastA file into m chunks, using 100/m G of RAM and m files of size 100/m GB.
Then apply jellyfish merge.

This branch is working out those details.
