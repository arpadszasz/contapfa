package Plenum::ContaPFA::Model::Metadata;

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;
use Moose;

with 'Plenum::ContaPFA::Role::Setup';

sub get {
    my $self = shift;
    return $self->dbh->resultset('Metadata')->find( { id => 1 } );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
