package Plenum::ContaPFA::Role::Setup;

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;
use Moose::Role;
use Wx ':everything';

has cfg   => ( is => 'rw', isa => 'HashRef' );
has frame => ( is => 'rw', isa => 'HashRef', default => sub { {} } );
has xrc   => ( is => 'rw', isa => 'Wx::XmlResource' );

sub BUILD { }

1;
