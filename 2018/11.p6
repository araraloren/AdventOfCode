
my $grid-serial-number = 3463;

my ($maxx, $maxy);
my $max = 0;

for 3 .. 300 -> $x {
    for 3 .. 300 -> $y {
        given &get-total-power-level($x, $y, $grid-serial-number) {
            if .self > $max {
                $max = .self;
                ($maxx, $maxy) = ($x, $y);
            }
        }
    }
}

say " MAX POWER LEVEL OF SQUARE => ({$maxx - 1}, {$maxy - 1})";

sub get-total-power-level($x, $y, $gsn) {
    return &get-power-level($x, $y, $gsn) +
        &get-power-level($x - 1, $y - 1, $gsn) +
        &get-power-level($x - 1, $y, $gsn) +
        &get-power-level($x - 1, $y + 1, $gsn) +
        &get-power-level($x, $y + 1, $gsn) +
        &get-power-level($x + 1, $y + 1, $gsn) +
        &get-power-level($x + 1, $y, $gsn) +
        &get-power-level($x + 1, $y - 1, $gsn) +
        &get-power-level($x, $y - 1, $gsn);
}

my @cell;

sub get-power-level($x, $y, $gsn) {
    if ! @cell[$x][$y].defined {
        my $rack-id = $x + 10;
        my $digit = (($rack-id * $y) + $gsn) * $rack-id;
        @cell[$x][$y] = $digit < 100 ?? 0 !! ( $digit div 100 % 10 - 5 );
    }
    return @cell[$x][$y];
}
