package Plenum::ContaPFA::Model::Schema::Result::Metadata;

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;
use Moose;

extends 'DBIx::Class::Core';

__PACKAGE__->table('metadata');

__PACKAGE__->add_columns(
    qw<
      id
      version
      release
      >
);

__PACKAGE__->set_primary_key('id');

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
