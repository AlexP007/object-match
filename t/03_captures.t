use strict;
use warnings qw/FATAL/;
use utf8;

use Test::Simple tests => 2;
use Regex::Object;

$|=1;

# vars
my ($re, $expected, $result);

# Initial
$re = Regex::Object->new(
    regex  => qr/(gr1) (gr2) (gr3)/,
);

## TEST 1
# Test 3 groups match

$expected = 3;
$result = scalar @{ $re->match('gr1 gr2 gr3')->captures };

ok($result == $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    )
);

## TEST 2
# Test 0 groups match

$expected = 0;
$result = scalar @{ $re->match('gr1 ngr2 gr3')->captures };

ok($result == $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    )
);