package Regex::Object;

use 5.20.0;
use strict;
use warnings qw(FATAL);
use utf8;
use English;

use Regex::Object::Match;
use Regex::Object::Matches;
use Moo;
use namespace::clean;

our $VERSION = '1.11';

tie my %nc,  "Tie::Hash::NamedCapture";
tie my %nca, "Tie::Hash::NamedCapture", all => 1;

has regex => (
    is => 'ro',
);

sub match {
    my ($self, $string) = @_;

    $string =~ $self->regex;
    return $self->collect;
}

sub match_all {
    my ($self, $string) = @_;
    my $regex = $self->regex;
    my @matches;

    while($string =~ /$regex/g) {
        push @matches, $self->collect;
    }

    return Regex::Object::Matches->new(
        matches => \@matches,
    );
}

sub collect {
    return Regex::Object::Match->new(
        prematch           => $PREMATCH,
        match              => $MATCH,
        postmatch          => $POSTMATCH,
        last_paren_match   => $LAST_PAREN_MATCH,
        captures           => _collect_captures(),
        named_captures     => { %nc },
        named_captures_all => { %nca },
    );
}

sub _collect_captures {
    my @captures;

    # Trick to get @captures the most appropriate to language version way.
    eval {
        @captures = @{^CAPTURE}; # This was added in 5.25.7.
    }
    or do {
        no strict 'refs';
        @captures = map { "$$_" } 1 .. $#-;
    };

    return \@captures;
}

1;

__END__

# ABSTRACT: solves problems with global Regex variables side effects.

=pod

=encoding UTF-8

=head1 NAME

Regex::Object - solves problems with global Regex variables side effects.

=head1 VERSION

version 1.11

=head1 SYNOPSIS

    use Regex::Object;

    my $re = Regex::Object->new(regex  => qr/^\w{3}$/); # regex to match 3 letters words

    print "matched\n" if $re->match('foo')->success;  # prints matched
    print "matched\n" if $re->match('fooz')->success; # nothing

    ######## ---- ########
    # The main goal - both results have different named captured hashes

    $re = Regex::Object->new(regex  => qr/(?<name>\w+?) (?<surname>\w+)/); # named captures

    my $result1 = $re->match('John Doe');
    my $result2 = $re->match('Fill Anselmo');

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

    ######## ---- ########
    # Works with match regex

    my $re = Regex::Object->new;
    my @matches;

    while ('John Doe Eric Lide Hans Zimmermann' =~ /(?<name>\w+?) (?<surname>\w+)/g) {
        my $match = $re->collect;
        push @matches, $match;
    }

=head1 DESCRIPTION

This module was created for one certain goal: give you a level
of isolation from perlre global variables.

The Regex::Object supports two approaches:

=over 4

=item object scoped regex

qr// regex passed to constructor, so these modifiers could be used: m,s,i,x,xx,p,a,d,l,u,n.

=item global regex

collecting regex result vars from global match expression, (nothing passed to constructor).

=back

More about Perl Regex: L<perlre|https://perldoc.perl.org/perlre>.

=head2 Regex::Object METHODS

=head3 new(regex => $regex)

    my $re = Regex::Object->new(regex  => qr/^\w{3}$/); # scoped qr regex
    my $re = Regex::Object->new; # to work with global match expression

Constructor: accept one optional parameter - qr// regex and returns new instance.

=head3 regex()

    my $regex = $re->regex;

Returns regex that was passed to constructor earlier.

=head3 match($string)

    my $result = $re->match('foo');

Execute regex matching and returns Regex::Object::Match result DTO.

=head3 collect()

    $string =~ /(\w*)/
    my $result = $re->collect;

Returns Regex::Object::Match result DTO filled with values from the nearest global match expression.

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
