#!/usr/bin/perl -w
#
# Copyright (C) 2017 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html
#
#  ***********************************************************************
#  * Copyright (C) 2016 and later: Unicode, Inc. and others.
#  * License & terms of use: http://www.unicode.org/copyright.html#License
#  ***********************************************************************
#  ***********************************************************************
#  * COPYRIGHT:
#  * Copyright (c) 2002-2011, International Business Machines Corporation
#  * and others. All Rights Reserved.
#  ***********************************************************************
# 
#  Search for and list files which don't have a copyright notice, and should.
#
use strict;
use warnings;
use File::Find;

use FindBin qw($Bin);
use lib $Bin;

use Cpy;
my $icu_src = $ARGV[0] || ".";
my $icu_src_len = length($icu_src);
die "Can't open ICU directory: $icu_src" unless -d $icu_src;
find({
        wanted => sub {
            return unless -f;
            my $relpath = substr($_, $icu_src_len + 1);
            return if should_ignore($relpath);

            open F, "<$_" or die "Error opening '$_'.";
            my $result = any { $_ =~ /(Copyright|©).*Unicode/i } <F>;

            close F;

            print "$relpath\n" unless $result;
        },
        no_chdir => 1,
    }, $icu_src);
