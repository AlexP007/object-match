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
    regex  => qr/(gr1) (gr2) (gr3)/,
);

## TEST 1
# Test 3 groups match

$expected = 3;
$result = scalar @{ $m->match('gr1 gr2 gr3')->matches };

ok($result == $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    ));

## TEST 2
# Test 0 groups match

$expected = 0;
$result = scalar @{ $m->match('gr1 ngr2 gr3')->matches };

ok($result == $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    ));