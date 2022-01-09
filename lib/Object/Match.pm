package Object::Match;

use strict;
use warnings qw/FATAL/;
use utf8;

use Carp;
use Moo;
use namespace::clean;

tie my %nc, "Tie::Hash::NamedCapture";
tie my %nca, "Tie::Hash::NamedCapture", all => 1;

has regex => (
    is       => 'ro',
    required => 1,
);

has matches => (
    is => 'rwp',
);

has names => (
    is => 'rwp',
);

has names_a => (
    is => 'rwp',
);

sub match {
    my ($self, $string) = @_;

    my @matches = $string =~ $self->regex;

    $self->_set_matches(\@matches);
    $self->_set_names({ %nc } );
    $self->_set_names_a( { %nca } );

    return scalar @matches;
}

1;
