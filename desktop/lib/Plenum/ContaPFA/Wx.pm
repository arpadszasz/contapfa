package Plenum::ContaPFA::Wx;

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;
use Moose;
use MooseX::NonMoose;
use Wx::XRC;
use Try::Tiny;
use Plenum::ContaPFA::Model;
use Plenum::ContaPFA::Wx::Main;

extends 'Wx::App';
with 'Plenum::ContaPFA::Role::Setup';

my $cfg;

sub FOREIGNBUILDARGS {
    my $class = shift;
    my $args  = shift;
    $cfg = $args->{cfg};
    return;
}

sub OnInit {
    my $self = shift;

    $self->cfg($cfg);

    try {
        $self->model( Plenum::ContaPFA::Model->new( { cfg => $self->cfg } ) );
    }
    catch {
        warn $_;
        Wx::LogError('Problema baza de date!');
        return 1;
    };

    $self->xrc( Wx::XmlResource->new );
    $self->xrc->InitAllHandlers;
    $self->xrc->Load( $self->cfg->{xrc_file} )
      or die "Can't load XRC file\n";

    my $main_frame = Plenum::ContaPFA::Wx::Main->new(
        {
            cfg   => $self->cfg,
            model => $self->model,
            xrc   => $self->xrc
        }
    );
    $self->SetTopWindow($main_frame);
    $main_frame->Show(1);

    return 1;
}

sub OnExit {
    return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
