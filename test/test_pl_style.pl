#! /usr/bin/env perl

=pod

=head1 NAME

test_pl_style.pl

=head1 DESCRIPTION

Tests the Perl scripts maintained by Tools and Integration using Perl::Critic.
The script runs File::Find over each package maintained, as well as the CMSToolBox, docs, and test
directories within OpsSpace.
Any files matching *.pl have Perl::Critic run over it.

.. todo::

    This script does not run on Travis-CI at the moment because Perl::Critic needs to be installed automatically.
    Get this working.

=head1 AUTHOR

Daniel Abercrombie <dabercro@mit.edu>

=cut

use strict;
use warnings;

use Cwd qw(abs_path);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catfile);
use File::Find;

# Load or install (and then load) Perl::Critic

eval 'use Perl::Critic';

# Checking for error message, and install, if necessary

if ($@) {

    if ($ENV{'TRAVIS'} eq 'true') {

        ## Get this working on Travis ##
        print "Right now, this script doesn't install on Travis-CI properly.\n";
        print "Need a virtual environment to get the installation right.\n";
        exit;
        ######

        print "Installing Perl::Critic\n";
        $ENV{'PERL_MM_USE_DEFAULT'} = 1;

        use CPAN;
        CPAN::Shell->notest('install', 'Perl::Critic');
        eval 'use Perl::Critic';

        if ($@) {

            die "Perl::Critic doesn't like being installed on the fly.\n";

        }

    } else {

        die "Please install Perl::Critic to run this script\n";

    }

}

my $critic = Perl::Critic->new();

my $test_dir = abs_path(dirname $0);

# Next, check all the Perl scripts in each package.

open my $package_handle, '<', catfile($test_dir, '..', 'PackageList.txt');
chomp(my @packages = <$package_handle>);
close $package_handle;

my @OpsSpace_dirs = ('CMSToolBox', 'docs');

push @packages, @OpsSpace_dirs;

my $errors = 0;

my $pack = '';

foreach (@packages) {

    # Look for files in the package, and critique them
    $pack = $_;
    find(\&critique_file, catfile($test_dir, '..', $pack));

}

sub critique_file {

    my $pl_file =  $_;

    if ($pl_file =~ /\.pl$/) {

        my @violations = $critic->critique($pl_file);

        if (@violations) {

            print "$File::Find::name\n";
            print @violations;

            if ($pack eq $ENV{'MUSTWORK'} or grep /^$pack$/, @OpsSpace_dirs) {

                $errors += 1;

            }

            print "\n";

        }

    }

}

print "Exit code: $errors\n";

exit $errors;
