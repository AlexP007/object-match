package Object::Match::Result;

use strict;
use warnings qw(FATAL);
use utf8;

use Moo;
use namespace::clean;

has [qw(matches names names_a)] => (
    is       => 'ro',
    required => 1,
);

has success => (
    is => 'rwp',
);

sub BUILD {
    my $self = shift;
    $self->_set_success(scalar @{ $self->matches } > 0);
}

1;