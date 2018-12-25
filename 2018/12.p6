my $str = Q:to/STR/;
initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
STR

subset RChar of Str where * eq '#' | '.';

class RTree {
    has $.lt is rw  = RTree;
    has $.rt is rw  = RTree;

    method hasChild(RChar $rc) {
        ($rc eq '#' ?? $!lt !! $!rt).defined;
    }

    method addChild(RChar $rc) {
        ($rc eq '#' ?? $!lt !! $!rt) = RTree.new;
    }

    method result() {
        $!lt.defined ?? '#' !! '.';
    }

    method getChild(RChar $rc) {
        $rc eq '#' ?? $!lt !! $!rt;
    }

    method gist() {
        if !$!lt.defined && !$!rt.defined {
            return "RTree";
        }
        if $!lt.defined && $!rt.defined {
            return "RTree \{ # {$!lt.gist()} <> . {$!rt.gist()} } ";
        }

        if $!lt.defined {
            return "RTree \{ # {$!lt.gist()} <> } ";
        }

        if $!rt.defined {
            return "RTree \{ <> . {$!rt.gist()} } ";
        }
    }
}

my $zero = 0;
my @pot;
my RTree $rtree .= new;

for $str.lines {
    if /^ 'initial state:' \s+ (<[\#\.]>+)/ {
        @pot = $0.Str.comb;
    } elsif / (<[\#\.]>+) \s+ '=>' \s+ (<[\#\.]>)  / {
        my $tree = $rtree;
        for $0.Str.comb -> $ch {
            $tree.addChild($ch) if ! $tree.hasChild($ch);
            $tree = $tree.getChild($ch);
        }
        $tree.addChild($1.Str);
    }
}

@pot = extendPot(@pot);

my @next = @pot;

for ^(+@pot - 5) {
    my @sub = @pot[$_ .. $_ + 4];
    my ($found, $tree) = (True, $rtree);
    for @sub -> $ch {
        if $tree.hasChild($ch) {
            $tree = $tree.getChild($ch);
        } else {
            $found = False;
            last;
        }
    }
    if $found {
        @next[$_] = @next[$_ + 1] = @next[$_ + 3] = @next[$_ + 4] = '.';
        @next[$_ + 2] = $tree.result;
    }
    say @next;
}

sub extendPot(@pot) {
    if @pot.head(3).grep('#') {
        @pot.prepend(< . . . >);
        $zero += 3;
    }
    if @pot.tail(3).grep('#') {
        @pot.append(< . . . >);
    }
    @pot;
}
