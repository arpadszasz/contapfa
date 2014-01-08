#!/usr/bin/env perl

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;

my $RealBin;

BEGIN {
    use File::Basename 'dirname';
    use File::Spec::Functions 'rel2abs';
    $RealBin = rel2abs( dirname(__FILE__) );

    eval { require Cava::Packager };
    if ( !$@ ) {
        Cava::Packager->import;
        if ( Cava::Packager::IsPackaged() ) {
            $RealBin = Cava::Packager::GetBinPath();
        }
    }

    $ENV{LC_NUMERIC} = 'ro_RO.UTF-8';

    my $debug_filename = "$RealBin/debug.log";
    unlink $debug_filename
      if ( -r $debug_filename
        and ( stat $debug_filename )[9] < ( time - 3600 * 24 * 7 ) );
    *CORE::GLOBAL::die = sub {
        use POSIX 'strftime';
        my $timestamp = POSIX::strftime( '%Y-%m-%d %H:%M:%S', localtime );

        my @trace = caller;

        open( my $debug_fh, '>>', $debug_filename );
        say $debug_fh "[$timestamp] Exception in package "
          . "$trace[0] at line $trace[2]: $_[0]";
        close $debug_fh;

        CORE::die(@_) if $^S;

        exit(1);
    };
}

use lib "$RealBin/lib";
use Cava::Packager;
use File::Temp 'tempfile';
use Wx::Perl::SplashFast;
use Plenum::ContaPFA::Wx;

Cava::Packager::SetResourcePath("$RealBin/res");

Wx::Perl::SplashFast->new( Cava::Packager::GetResource('splash.png'), 1000 );

my $db_filename = $RealBin . '/contapfa.db';

my %cfg = (
    program_version => '1.0.0',
    copyright_start => 2014,
    icon_file       => Cava::Packager::GetResource('icon.ico'),
    splash_file     => Cava::Packager::GetResource('splash.png'),
    xrc_file        => fix_paths( Cava::Packager::GetResource('layout.xrc') ),
    program_path    => $RealBin,
    db_filename     => $db_filename,
);

my $app = Plenum::ContaPFA::Wx->new( { cfg => \%cfg } );
$app->MainLoop;

exit;

sub fix_paths {
    my $xrc_file = shift;

    open( my $xrc_fh, '<', $xrc_file )
      or die "Can't open XRC file: $xrc_file";

    my $temp_file = File::Temp->new( UNLINK => 0, SUFFIX => '.dat' );
    open( my $temp_fh, '>', $temp_file->filename );

    while ( my $line = <$xrc_fh> ) {
        if ( $line =~ /res\/(.+?)</ ) {
            my $relative_path = Cava::Packager::GetResource($1);
            $line =~ s/res\/(.+?)</$relative_path</;
        }
        print $temp_fh $line;
    }

    close $xrc_fh;
    close $temp_fh;

    return $temp_file->filename;
}
