#!/usr/bin/perl
# vim : set ts=4 sw=4 et ft=perl

use Data::Dumper qw/Dumper/;

use POSIX qw/localtime/;
use strict;
use warnings;
use vars qw/%schema/;

die "Usage $0 <schema.pl>\n" unless @ARGV;

sub import {
    eval {
      foreach my $f ( @_ ) {
        require($f);
        die "Error importing $f: $@\n" if $@;
      }
    };
}

# Use a closure
{
 my %ids;
 sub dataForAutoIncrement {
   my ($options, $tableName) = @_;
   $ids{$tableName}++;
 }
}

sub dataForTimestamp {
    my ($options) = @_;
    my $range = $options->{'range'};
    my $rounding = $options->{'rounding'} || 1;
    # round to the nearest interval
    int(time - int(rand($range)) / $rounding) * $rounding;
}

sub dataForNode {
    my ($options) = @_;
    my $range = $options->{'range'};
    my $set = $options->{'set'};
    sprintf("SWOLT%07d", int(rand($range->[1] - $range->[0]) + $range->[0]));
}
sub dataForPort {
    my ($options) = @_;
    #print "Generating instance of port: ", Dumper($options);
    my $range = $options->{'range'};
    my $set = $options->{'set'};
    sprintf("%d/%d/%d",
      int(rand($range->[1] - $range->[0]) + $range->[0]),
      int(rand($range->[1] - $range->[0]) + $range->[0]),
      int(rand($range->[1] - $range->[0]) + $range->[0]),
    );
}

sub dataForSet {
    my ($options) = @_;
    my $range= $options->{'range'};
    $range->[ int(rand(scalar(@$range))) ]; # randomly pick an element from the range
}

sub dataForReading {
    my ($options) = @_;
    my $range = $options->{'range'};
    my $set = $options->{'set'};
    int(rand($range->[1] - $range->[0]) + $range->[0]);
}

sub dataForInt {
    my ($options) = @_;
    my $range = $options->{'range'};
    my $set = $options->{'set'};
    int(rand($range->[1] - $range->[0]) + $range->[0]);
}

sub generateDataForType {
    my ($type, $tableName, $options) = @_;
    #print "Generating data for $type\n";
    my %dispatch = (
        'auto'      => \&dataForAutoIncrement,
        'int'       => \&dataForInt,
        'node'      => \&dataForNode,
        'port'      => \&dataForPort,
        'queue'     => \&dataForQueue,
        'reading'   => \&dataForReading,
        'set'       => \&dataForSet,
        'timestamp' => \&dataForTimestamp,
    );
    if ( exists $dispatch{$type} ) {
       return $dispatch{$type}->($options, $tableName);
    }
}

sub generateDataForTable {
    my ($tableName, $columns, $filename) = @_;
    my %static;
    my $instances = $columns->{'instances'};
    my @rows;
    my $i = 0;
    while ( $i < $instances ) {
        my %row_data;
        #if ( $i == 0 ) { print join(',', grep { $_ ne 'instances' } sort keys %$columns), "\n"; }
        foreach my $column (sort keys %$columns) {
            if ( ref($columns->{$column}) eq 'HASH' ) {
                my $nodeType = $columns->{$column}{'type'};
                $row_data{$column} = generateDataForType($nodeType, $tableName, $columns->{$column});
            } elsif ( $column ne 'instances' ) {
                $row_data{$column} = $columns->{$column};
            }
        }
        print join(",", map { $row_data{$_} } sort keys %row_data), "\n";
        $i++;
    }
}

import(@ARGV);
generateDataForTable($_, $schema{$_}, "$_.csv") for keys %schema;

