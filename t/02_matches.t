use strict;
use warnings qw/FATAL/;
use utf8;

use Test::Simple tests => 4;
use Regex::Object;

$|=1;

# vars
my ($re, $expected, $result);

# Initial
$re = Regex::Object->new(
    regex  => qr/regex/,
);

## TEST 1
# Test match

$expected = 'regex';
$result = $re->match('full regex expression')->match;

ok($result eq $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    )
);

## TEST 2
# Test prematch

$expected = 'full ';
$result = $re->match('full regex expression')->prematch;

ok($result eq $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    )
);

## TEST 3
# Test postmatch

$expected = ' expression';
$result = $re->match('full regex expression')->postmatch;

ok($result eq $expected,
    sprintf('Returns wrong value: %s, expected: %s',
        $result,
        $expected,
    )
);

## TEST 4
# Test unmatched

$result = $re->match('full expression')->match;

ok(!$result,
    'Returns wrong value: string, expected: undef'
);
