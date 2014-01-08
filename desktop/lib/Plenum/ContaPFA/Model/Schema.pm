package Plenum::ContaPFA::Model::Schema;

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;
use Moose;

extends 'DBIx::Class::Schema';

__PACKAGE__->load_classes(
    { 'Plenum::ContaPFA::Model::Schema::Result' => [ qw( Metadata ) ] } );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
