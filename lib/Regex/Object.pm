package Regex::Object;

use 5.20.0;
use strict;
use warnings qw(FATAL);
use utf8;
use English;

use Regex::Object::Match;
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

    my @captures = $string =~ $self->regex;

    return Regex::Object::Match->new(
        prematch           => $PREMATCH,
        match              => $MATCH,
        postmatch          => $POSTMATCH,
        last_paren_match   => $LAST_PAREN_MATCH,
        captures           => \@captures,
        named_captures     => { %nc },
        named_captures_all => { %nca },
    );
}

1;

__END__
