#!/usr/bin/env perl6

my $grid-serial-number = 3463;

my ($maxx, $maxy);
my $max = 0;

for 1 .. 298 -> $z {
    for 2 .. 300 - $z -> $x {
        for 2 .. 300 - $z -> $y {
            given &get-total-power-level($x, $y, $z, $grid-serial-number) {
                if .self > $max {
                    $max = .self;
                    ($maxx, $maxy) = ($x, $y);
                }
            }
        }
    }

    say "\t\tMAX POWER LEVEL OF {$z} SQUARE => ({$maxx}, {$maxy}) -> $max";
}

say " MAX POWER LEVEL OF SQUARE => ({$maxx}, {$maxy})";

my @cell;

sub get-total-power-level($x, $y, $z, $gsn) {
    if ! @cell[$x][$y][$z].defined {
        if $z == 1 {
            my $rack-id = $x + 10;
            my $digit = (($rack-id * $y) + $gsn) * $rack-id;
            @cell[$x][$y][$z] = $digit < 100 ?? 0 !! ( $digit div 100 % 10 - 5 );
        } elsif $z == 2 {
            @cell[$x][$y][$z] = &get-total-power-level($x + 1, $y + 1, 1, $gsn) +
                &get-total-power-level($x, $y + 1, 1, $gsn) +
                &get-total-power-level($x + 1, $y, 1, $gsn);
        } else {
            my $res = 0;
            $res += &get-total-power-level($x, $y, $z - 1, $gsn);
            for ^$z -> $iz {
                $res += &get-total-power-level( $x + $z - 1, $y + $iz, 1, $gsn );
                $res += &get-total-power-level( $x + $iz, $y + $z - 1, 1, $gsn );
            }
            $res -= &get-total-power-level( $x + $z - 1, $y + $z - 1, 1, $gsn );
            @cell[$x][$y][$z] = $res;
        }
    }
    return @cell[$x][$y][$z];
}
