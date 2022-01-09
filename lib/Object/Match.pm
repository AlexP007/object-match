package Object::Match;

use strict;
use warnings qw(FATAL);
use utf8;

use Object::Match::Result;
use Moo;
use namespace::clean;

tie my %nc, "Tie::Hash::NamedCapture";
tie my %nca, "Tie::Hash::NamedCapture", all => 1;

has regex => (
    is       => 'ro',
    required => 1,
);

sub match {
    my ($self, $string) = @_;

    my @matches = $string =~ $self->regex;

    return Object::Match::Result->new(
        matches => \@matches,
        names   => { %nc },
        names_a => { %nca },
    );
}

1;
