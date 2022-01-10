package Regex::Object;

use 5.20.0;
use strict;
use warnings qw(FATAL);
use utf8;
use English;

use Regex::Object::Match;
use Moo;
use namespace::clean;

our $VERSION = '1.10';

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

# ABSTRACT: solves problems with global Regex variables side effects.

=pod

=encoding UTF-8

=head1 NAME

Regex::Object - solves problems with global Regex variables side effects.

=head1 VERSION

version 1.10

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

=head3 success()

    my $is_success = $result->success;

Returns 1 if match succeeded or '' if not.

=head3 prematch()

Returns string preceding whatever was matched by the last successful pattern match.
$` equivalent.

    my $prematch = $result->prematch;

=head3 match()

Returns string matched by the last successful pattern match.
$& equivalent

    my $match = $result->match;

=head3 postmatch()

Returns string following whatever was matched by the last successful pattern match.
$' equivalent.

    my $postmatch = $result->postmatch;

=head3 last_paren_match()

Returns string matched by the highest used capture group of the last successful search pattern.
$+ equivalent.

    my $last_paren_match = $result->last_paren_match;

=head3 captures()

Returns array ref contains of ($1, $2 ...) capture groups values.

    my $first_group = $result->captures->[0];

=head3 named_captures()

Returns hash ref of the named captures.
%+ equivalent.

    my $name = $result->named_captures->{name};

=head3 named_captures_all()

Returns hash ref of the named captures all.
%- equivalent.

    my $names_array_ref = $result->named_captures_all->{name};

=head1 BUGS AND LIMITATIONS

If you find one, please let me know.

=head1 SOURCE CODE REPOSITORY

L<https://github.com/AlexP007/regex-object|https://github.com/AlexP007/regex-object> - fork or add pr.

=head1 AUTHOR

Alexander Panteleev <alexpan at cpan dot org>.

=head1 LICENSE AND COPYRIGHT

This software is copyright (c) 2022 by Alexander Panteleev.
This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
