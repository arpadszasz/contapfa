package Plenum::ContaPFA::Model;

use 5.10.1;
use strict;
use warnings FATAL => 'all';
use utf8;
use Moose;
use DBI;
use DBIx::MultiStatementDo;
use Plenum::ContaPFA::Model::Schema;
use Plenum::ContaPFA::Model::Metadata;

with 'Plenum::ContaPFA::Role::Setup';

sub BUILD {
    my $self = shift;
    my $args = shift;

    my $db_filename = $args->{cfg}->{db_filename};
    if ( !-r -w $db_filename ) {
        warn "Creating DB $db_filename" if $ENV{DEBUG};
        $self->_create_db_file($db_filename);
    }

    my $dsn = q/dbi:SQLite:dbname=/ . $args->{cfg}->{db_filename};

    my %dbi_args = (
        AutoCommit     => 1,
        RaiseError     => 1,
        sqlite_unicode => 1
    );

    my %dbic_args = (
        on_connect_do => qq<
            PRAGMA foreign_keys = ON;
            PRAGMA encoding = "UTF-8";
        >
    );

    $self->dbh(
        Plenum::ContaPFA::Model::Schema->connect(
            $dsn,
            '',
            '',
            \%dbi_args,
            \%dbic_args
        )
    );

    $self->dbh->storage->sql_maker->quote_char('"');

    return;
}

sub metadata {
    my $self = shift;
    return Plenum::ContaPFA::Model::Metadata->new( { dbh => $self->dbh } );
}

sub _create_db_file {
    my $self        = shift;
    my $db_filename = shift;

    my $dbh = DBI->connect( "dbi:SQLite:dbname=$db_filename", "", "" );
    my $sql = do { local $/; <DATA> };
    my $batch = DBIx::MultiStatementDo->new( dbh => $dbh );
    $batch->do($sql) or die $batch->dbh->errstr;

    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__DATA__
BEGIN TRANSACTION;

PRAGMA foreign_keys = ON;
PRAGMA encoding = "UTF-8";

CREATE TABLE metadata (
    id          INTEGER PRIMARY KEY ASC,
    version     VARCHAR(16),
    release     TIMESTAMP NOT NULL
);

INSERT INTO metadata (id, version, release) VALUES (1, "1.0", datetime('now', 'localtime'));

COMMIT;

