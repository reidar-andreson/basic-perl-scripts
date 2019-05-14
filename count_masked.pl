#!/usr/bin/perl
#
# A Perl script for counting masked nucleotides in FASTA file
# 
# Copyright (C) Reidar Andreson and University of Tartu
# You can modify and distribute this script and derivateive works freely
#

use strict;
use Getopt::Long;

# parse args
my $file;
my $sym = 'N';
my $line;
my $length = 0;
my $count = 0;
my $version = "1.0";

GetOptions('in=s'    => \$file,
           'c=s'     => \$sym,
           'h|help'       => sub { usage() });

if(!defined($file)){
    print STDERR "    ERROR: Missing input file!\n";
    &usage;
}

open (F, "<", $file)  or die ("Cannot open input file: $file!\n");

while(my $line = <F>){
    chomp($line);
    next if($line =~ /^\s+$/);
    next if($line =~ /^>/);
    $sym =~ s/\s+//;
    $length += length($line);
    $count += $line =~ s/$sym/1/g;
}
close F;

printf STDERR ("Input file: %s\n",$file);
printf STDERR ("Masking character: %s\n",$sym);
printf STDERR ("Masked nucleotides: %d of %d (%.2f%%)\n",$count,$length,($count*100/$length));

sub usage{
    
    my ($cmd) = $0 =~ /([^\\\/]+)$/;        
    
    print STDERR <<EndOfUsage;    
                    
    $cmd (version: $version)
                                    
    Usage: perl $cmd [options]
                                                    
    Options:
    -in    input file in FASTA format [required]
    -c     masking character, case sensitive! (default: N)
    -h     print help menu
    
EndOfUsage
      
    exit;
}