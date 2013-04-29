use strict;
use warnings;
use Scalar::Util ();
use Test::BangAway;
use Test::BangAway::Generator;
use Test::More;

bang_away_ok { ! grep { $_ < 20 || 30 < $_  } @_ } list (integer 20, 30);
bang_away_ok { $_[0] =~ /^[a-zA-Z]$/ } char;
bang_away_ok { $_[0] =~ /^[a-zA-Z]{30,40}$/ } string 30, 40;
bang_away_ok {
    my ($string, @list) = @_;
    $string =~ /^[a-zA-Z]*$/ && ! grep { $_ < 1 || 5 < $_ } @list;
} concat +(string), (list (integer 1, 5));

bang_away_ok {
    my $hash = shift;
    ref $hash eq 'HASH' && ! grep { $_ < 50 || 60 < $_ } values %$hash;
} ref_hash string(10, 15), integer(50, 60), 5, 10;

bang_away_ok {
    my $array = shift;
    ref $array eq 'ARRAY' && ! grep { ! /^[a-z]$/ } @$array;
} ref_array(enum('a' .. 'z'), 5, 10);

bang_away_ok {
    my $data = shift;
    ref $data eq 'ARRAY' && ! grep { ! ref $_ eq 'HASH' } @$data;
} ref_array(
    ref_hash(
        string() => ref_array(enum qw(True False))
    ), 5, 10
);

bang_away_ok {
    my ($f, $x) = @_;
    Scalar::Util::looks_like_number($f->($x)) && $f->($x) == $f->($x);
} concat (function (integer, integer), integer);

bang_away_ok {
    my ($f, $x, $y) = @_;
    Scalar::Util::looks_like_number($f->($x)->($y))
                                           && $f->($x)->($y) == $f->($x)->($y);
} concat (function (integer, function (integer, integer)), integer, integer);

done_testing;
