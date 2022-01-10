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

    ######## ---- ########

    $re = Regex::Object->new(regex  => qr/(?<name>\w+?) (?<surname>\w+)/); # named captures

    my $result1 = $re->match('John Doe');
    my $result2 = $re->match('Fill Anselmo');

    # The main goal - both results have different named captured hashes
    if ($result2->success) {
        my $name    = $result2->named_captures->{name};
        my $surname = $result2->named_captures->{surname};

        print "Name: $name; Surname: $surname\n";
    }

    if ($result1->success) {
        my $name    = $result1->named_captures->{name};
        my $surname = $result1->named_captures->{surname};

        print "Name: $name; Surname: $surname\n";
    }

=head1 DESCRIPTION

This module was created for one certain goal: give you a level
of isolation from perlre global variables.

The Regex::Object supports qr// regex, so these modifiers
could be used: m,s,i,x,xx,p,a,d,l,u,n.

More about Perl Regex: L<perlre|https://perldoc.perl.org/perlre>.

=head2 Regex::Object METHODS

=head3 new(regex => $regex)

    my $re = Regex::Object->new(regex  => qr/^\w{3}$/);

Constructor: accept one parameter - qr// regex and returns new instance.

=head3 regex()

    my $regex = $re->regex;

Returns regex that was passed to constructor earlier.

=head3 match($string)

    my $result = $re->match('foo');

Execute regex matching and returns Regex::Object::Match result DTO.

=head2 Regex::Object::Match METHODS

=cut
