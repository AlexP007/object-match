use strict;
use warnings qw/FATAL/;
use utf8;

use Test::Simple tests => 2;
use Object::Match;

$|=1;

# vars
my ($m, $expected, $result);

# Initial
$m = Object::Match->new(
    regex  => qr/^word\040$/,
);

## TEST 1
# Test success match

$expected = 1;
$result = $m->match('word ');

ok($result == $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    ));

## TEST 2
# Test failed match

$expected = 0;
$result = $m->match('word');

ok($result == $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    ));