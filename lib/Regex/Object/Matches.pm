package Regex::Object::Matches;

use 5.20.0;
use strict;
use warnings qw(FATAL);
use utf8;

use Moo;
use namespace::clean;

has matches => (
    is       => 'ro',
    required => 1,
);

sub match_all {
    my $self = shift;

    return [map { $_->match } @{$self->matches}];
}

sub captures_all {
    my $self = shift;

    return [map { $_->captures } @{$self->matches}];
}

1;