my $str = Q:to/STR/;
initial state: #.##.#.##..#.#...##...#......##..#..###..##..#.#.....##..###...#.#..#...######...#####..##....#..###

##.## => .
##... => #
..#.# => #
#.... => .
#..#. => #
.#### => .
.#..# => .
.##.# => .
#.##. => #
####. => .
..##. => .
##..# => .
.#.## => #
.#... => .
.##.. => #
..#.. => #
#..## => #
#.#.. => #
..### => #
...#. => #
###.. => .
##.#. => #
#.#.# => #
##### => #
....# => .
#.### => .
.#.#. => #
.###. => #
...## => .
..... => .
###.# => #
#...# => .
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

class PotQueue {
    has @.pot handles < AT-POS append prepend push pop elems ASSIGN-POS >;
    has $.zero = 0;

    method setpot(@pot) {
        @!pot = @pot;
    }

    method extend() {
        if @!pot.head(5).grep('#') {
            @!pot.prepend(< . . . >);
            $!zero += 5;
        }
        @!pot.append(< . . . >) if @!pot.tail(5).grep('#');
        self;
    }

    method reduce() {
        if @pop.
    }

    method Int() {
        @!pot.elems;
    }

    method gist() {
        ("." xx ($!zero + 1 )) ~ "\n" ~ @!pot;
    }

    method sum() {
        my $sum = 0;
        for 0 ..^ +@!pot -> $i {
            $sum += $i - $!zero if @!pot[$i] eq '#';
        }
        $sum;
    }
}

my PotQueue $pq .= new;
my RTree $rtree .= new;

for $str.lines {
    if /^ 'initial state:' \s+ (<[\#\.]>+)/ {
        $pq.setpot($0.Str.comb);
    } elsif / (<[\#\.]>+) \s+ '=>' \s+ (<[\#\.]>)  / {
        my $tree = $rtree;
        for $0.Str.comb -> $ch {
            $tree.addChild($ch) if ! $tree.hasChild($ch);
            $tree = $tree.getChild($ch);
        }
        $tree.addChild($1.Str);
    }
}

for ^50000000000 {
    my @next = '.' xx $pq.extend.elems;

    for ^($pq.elems - 4) {
        my @sub = $pq[$_ .. $_ + 4];
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
            @next[$_ + 2] = $tree.result;
        }
    }
    $pq.setpot(@next);
    say $_ if $_ % 1000000 == 0;
}

say $pq;
say " --> sum = ", $pq.sum();
