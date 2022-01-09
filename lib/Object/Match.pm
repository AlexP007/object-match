package Object::Match;

use 5.20.0;
use strict;
use warnings qw(FATAL);
use utf8;
use English;

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
        matches   => \@matches,
        names     => { %nc },
        names_a   => { %nca },
        prematch  => $PREMATCH,
        match     => $MATCH,
        postmatch => $POSTMATCH,
    );
}

1;
