my $str = Q:to/STR/;
459 players; last marble is worth 71790 points
STR

my ($players, $max) = ($str.chomp ~~ / ^ (\d+) .*? (\d+) \s+ 'points' $ /).[0 .. * - 1]>>.Int;
my @marble = 0, 1;
my @score = 0 xx $players;
my ($current, $count, $marble, $next) = (1, 2, 1);

print " WITH $players players, last marble is $max ---> ";
while ++$marble <= $max { # very very very slow, maybe using a link list ?
    $count = +@marble;
    if $marble % 23 != 0 {
        $next = ($current + 2) % $count;
        if $next == 0 {
            @marble.push($marble);
            $current = +@marble - 1;
            next;
        }
        @marble[$_] = @marble[$_ - 1] for $count ...^ $next;
        @marble[$next] = $marble;
        $current = $next;
    } else {
        $next = ($current - 7) % $count;
        @score[$marble % $players] += $marble;
        @score[$marble % $players] += @marble[$next];
        @marble[$_] = @marble[$_ + 1] for $next ...^ $count;
        @marble.pop();
        $current = $next;
    }
    if $marble % 1000 == 0 {
        say $marble;
    }
}

say @score.maxpairs;
