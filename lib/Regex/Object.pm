package Regex::Object;

use 5.20.0;
use strict;
use warnings qw(FATAL);
use utf8;
use English;

use Regex::Object::Match;
use Moo;
use namespace::clean;

our $VERSION = '1.00';

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

# ABSTRACT: Regex object that solves problems with global variables side effects.

=pod

=encoding UTF-8

=head1 NAME

Regex::Object - Regex object that solves problems with global variables side effects.

=head1 VERSION

version 1.00

=head1 SYNOPSIS
    use Regex::Object;

    my $re = Regex::Object->new(regex  => qr/^\w{3}$/); # regex to match 3 letters words

    print "matched\n" if $re->match('foo')->success;  # prints matched
    print "matched\n" if $re->match('fooz')->success; # nothing

    #### ---- ####



=cut
