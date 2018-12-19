my $str = Q:to/STR/;
459 players; last marble is worth 71790 points
STR

my ($players, $max) = ("10 players; last marble is worth 1618 points".chomp ~~ / ^ (\d+) .*? (\d+) \s+ 'points' $ /).[0 .. * - 1]>>.Int;
my @marble = 0, 1;
my @score = 0 xx $players;
my ($current, $count, $marble, $next) = (1, 2, 1);

print " WITH $players players, last marble is $max ---> ";
while ++$marble <= $max {
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

class LinkedList {
    class Node {
        has $.data is rw;
        has $.prev is rw;
        has $.next is rw;

        method new($data, $prev, $next) {
            self.bless(:$data, :$prev, :$next);
        }

        method two() {
            $!next.next;
        }

        method seven() {
            my $node = self;
            $node = $node.prev for ^7;
            $node;
        }

        method insert-before($data) {
            $!prev.next = (my $node = Node.new($data, Node, Node));
            $node.prev = $!prev;
            $node.next = self;
            self.prev = $node;
            $node;
        }

        method remove-me() {
            my $ret = $!next;
            $!prev.next = $!next;
            $!next.prev = $!prev;
            $!next = Node;
            $!prev = Node;
            $ret;
        }
    }

    has $.head;
    has $.elems;

    submethod TWEAK() {
        $!head = Node.new(0, $!head, $!head);
        $!head.prev = $!head.next = $!head;
        $!elems = 1;
    }

    method push($data) {
        $!head.prev.next = (my $node = Node.new($data, Node, Node));
        $node.prev = $!head.prev;
        $!head.prev = $node;
        $node.next = $!head;
        $!elems += 1;
        self;
    }

    method pop() {
        $!head.next = $!head.prev.prev;
        $!head.prev.next = $!head;
        $!elems -= 1;
        self;
    }

    method tail() {
        $!head.prev;
    }

    method print() {
        my $head = $!head;
        repeat {
            print $head.data, "\@{$head.WHICH}", " -> ";
            $head = $head.next;
        } while ($head.WHICH ne $!head.WHICH);
    }
}

my ($players, $max) = ($str.chomp ~~ / ^ (\d+) .*? (\d+) \s+ 'points' $ /).[0 .. * - 1]>>.Int;
my $ll = LinkedList.new.push(1);
my @score = 0 xx $players;
my ($current, $marble, $next) = ($ll.tail, 1);

print " WITH $players players, last marble is $max ---> ";
while ++$marble <= $max {
    if $marble % 23 != 0 {
        $next = $current.two();
        if $next.WHICH eq $ll.head.WHICH {
            $ll.push($marble);
            $current = $ll.tail;
            next;
        }
        $current = $next.insert-before($marble);
    } else {
        $next = $current.seven();
        @score[$marble % $players] += $marble;
        @score[$marble % $players] += $next.data();
        $current = $next.remove-me();
    }
}

say @score.maxpairs;
