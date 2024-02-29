#!/usr/bin/env perl

# Copyright (C) 2007-2021 Apple Inc.  All rights reserved.
# Copyright (C) 2021-2022 Nelson.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1.  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# 2.  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
# 3.  Neither the name of Apple Inc. ("Apple") nor the names of
#     its contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY APPLE AND ITS CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL APPLE OR ITS CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Script to case-sensitive sort "children", "files", "buildConfigurations",
# "targets", "packageProductDependencies" and "packageReferences" sections
# in Xcode project.pbxproj files.

use strict;
use warnings;

use File::Basename;
use File::Spec;
use File::Temp qw(tempfile);
use Getopt::Long;

sub sortChildrenByFileName($$);
sub sortFilesByFileName($$);

# Some files without extensions, so they can sort with the other files.
# Otherwise, names without extensions are assumed to be groups or directories and sorted last.
my %isFile = map { $_ => 1 } qw(
    create_hash_table
);

my $printWarnings = 1;
my $showHelp;

my $getOptionsResult = GetOptions(
    'h|help'         => \$showHelp,
    'w|warnings!'    => \$printWarnings,
);

if (scalar(@ARGV) == 0 && !$showHelp) {
    print STDERR "ERROR: No Xcode project files (project.pbxproj) listed on command-line.\n";
    undef $getOptionsResult;
}

if (!$getOptionsResult || $showHelp) {
    print STDERR <<__END__;
Usage: @{[ basename($0) ]} [options] path/to/project.pbxproj [path/to/project.pbxproj ...]
  -h|--help           show this help message
  -w|--[no-]warnings  show or suppress warnings (default: show warnings)
__END__
    exit 1;
}

for my $projectFile (@ARGV) {
    if (basename($projectFile) =~ /\.xcodeproj$/) {
        $projectFile = File::Spec->catfile($projectFile, "project.pbxproj");
    }

    if (basename($projectFile) ne "project.pbxproj") {
        print STDERR "WARNING: Not an Xcode project file: $projectFile\n" if $printWarnings;
        next;
    }

    my ($OUT, $tempFileName) = tempfile(
        basename($projectFile) . "-XXXXXXXX",
        DIR => dirname($projectFile),
        UNLINK => 0,
    );

    # Clean up temp file in case of die()
    $SIG{__DIE__} = sub {
        close(IN);
        close($OUT);
        unlink($tempFileName);
    };

    open(IN, "< $projectFile") || die "Could not open $projectFile: $!";
    while (my $line = <IN>) {
        # Sort files section.
        if ($line =~ /^(\s*)files = \(\s*$/) {
            print $OUT $line;
            my $endMarker = $1 . ");";
            my @files;
            while (my $fileLine = <IN>) {
                if ($fileLine =~ /^\Q$endMarker\E\s*$/) {
                    $endMarker = $fileLine;
                    last;
                }
                push @files, $fileLine;
            }

            # Remove duplicate lines then sort.
            my @uniqueLines = uniq(@files);
            print $OUT sort sortFilesByFileName @uniqueLines;
            print $OUT $endMarker;
        }
        # Sort children, buildConfigurations, targets, packageProductDependencies, and packageReferences sections.
        elsif ($line =~ /^(\s*)(children|buildConfigurations|targets|packageProductDependencies|packageReferences) = \(\s*$/) {
            print $OUT $line;
            my $endMarker = $1 . ");";
            my @children;
            while (my $childLine = <IN>) {
                if ($childLine =~ /^\Q$endMarker\E\s*$/) {
                    $endMarker = $childLine;
                    last;
                }
                push @children, $childLine;
            }

            # Remove duplicate lines then sort.
            my @uniqueLines = uniq(@children);
            print $OUT sort sortChildrenByFileName @uniqueLines;
            print $OUT $endMarker;
        }
        # Ignore whole PBXFrameworksBuildPhase section.
        elsif ($line =~ /^(.*)Begin PBXFrameworksBuildPhase section(.*)$/) {
            print $OUT $line;
            while (my $ignoreLine = <IN>) {
                print $OUT $ignoreLine;
                if ($ignoreLine =~ /^(.*)End PBXFrameworksBuildPhase section(.*)$/) {
                    last;
                }
            }
        }
        # Ignore other lines.
        else {
            print $OUT $line;
        }
    }
    close(IN);
    close($OUT);

    unlink($projectFile) || die "Could not delete $projectFile: $!";
    rename($tempFileName, $projectFile) || die "Could not rename $tempFileName to $projectFile: $!";
}

exit 0;

sub sortChildrenByFileName($$)
{
    my ($a, $b) = @_;
    my $aFileName = $1 if $a =~ /^\s*[A-Z0-9]{24} \/\* (.+) \*\/,$/;
    my $bFileName = $1 if $b =~ /^\s*[A-Z0-9]{24} \/\* (.+) \*\/,$/;
    my $aSuffix = $1 if $aFileName =~ m/\.([^.]+)$/;
    my $bSuffix = $1 if $bFileName =~ m/\.([^.]+)$/;
    my $aIsDirectory = !$aSuffix && !$isFile{$aFileName};
    my $bIsDirectory = !$bSuffix && !$isFile{$bFileName};
    return $bIsDirectory <=> $aIsDirectory if $aIsDirectory != $bIsDirectory;
    if ($aFileName =~ /^UnifiedSource\d+/ && $bFileName =~ /^UnifiedSource\d+/) {
        my $aNumber = $1 if $aFileName =~ /^UnifiedSource(\d+)/;
        my $bNumber = $1 if $bFileName =~ /^UnifiedSource(\d+)/;
        return $aNumber <=> $bNumber if $aNumber != $bNumber;
    }
    # Uncomment below line to have case-insensitive sorting.
    # return lc($aFileName) cmp lc($bFileName) if lc($aFileName) ne lc($bFileName);
    return $aFileName cmp $bFileName;
}

sub sortFilesByFileName($$)
{
    my ($a, $b) = @_;
    my $aFileName = $1 if $a =~ /^\s*[A-Z0-9]{24} \/\* (.+) in /;
    my $bFileName = $1 if $b =~ /^\s*[A-Z0-9]{24} \/\* (.+) in /;
    if ($aFileName =~ /^UnifiedSource\d+/ && $bFileName =~ /^UnifiedSource\d+/) {
        my $aNumber = $1 if $aFileName =~ /^UnifiedSource(\d+)/;
        my $bNumber = $1 if $bFileName =~ /^UnifiedSource(\d+)/;
        return $aNumber <=> $bNumber if $aNumber != $bNumber;
    }
    # Uncomment below line to have case-insensitive sorting.
    # return lc($aFileName) cmp lc($bFileName) if lc($aFileName) ne lc($bFileName);
    return $aFileName cmp $bFileName;
}

# Subroutine to remove duplicate items in an array.
# https://perlmaven.com/unique-values-in-an-array-in-perl
sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
