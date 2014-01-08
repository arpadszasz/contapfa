package Plenum::ContaPFA::Wx::Main;

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;
use Moose;
use MooseX::NonMoose;
use Wx ':everything';
use Wx::Event ':everything';
use Wx::XRC;

extends 'Wx::Frame';
with 'Plenum::ContaPFA::Role::Setup';

sub FOREIGNBUILDARGS {
    return;
}

after BUILD => sub {
    my $self = shift;
    $self->initialize;
    return $self;
};

sub initialize {
    my $self = shift;

    $self->xrc->LoadFrame( $self, undef, 'main_frame' );
    $self->frame->{main_frame} = $self->FindWindow('main_frame');

    $self->SetIcon(
        Wx::Icon->new( $self->cfg->{icon_file}, wxBITMAP_TYPE_ICO ) );

    EVT_MENU(
        $self,
        Wx::XmlResource::GetXRCID('menu_program_quit'),
        sub { $self->_close_window },
    );

    EVT_CLOSE(
        $self,
        sub { $self->_close_window }
    );

    return;
}

sub _close_window {
    my $self = shift;

    my $dialog = Wx::MessageDialog->new(
        $self->frame->{main_frame},
        'Doriti sa inchideti aplicatia?',
        '',
        wxNO_DEFAULT | wxYES_NO | wxICON_QUESTION
    );
    my $selection = $dialog->ShowModal;

    return if $selection == wxID_NO;

    $self->Destroy;

    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
