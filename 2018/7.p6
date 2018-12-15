my $str = Q:to/STR/;
Step L must be finished before step T can begin.
Step B must be finished before step I can begin.
Step A must be finished before step T can begin.
Step F must be finished before step T can begin.
Step D must be finished before step J can begin.
Step N must be finished before step R can begin.
Step J must be finished before step U can begin.
Step C must be finished before step Z can begin.
Step V must be finished before step H can begin.
Step W must be finished before step H can begin.
Step H must be finished before step I can begin.
Step R must be finished before step K can begin.
Step M must be finished before step X can begin.
Step T must be finished before step O can begin.
Step Q must be finished before step P can begin.
Step I must be finished before step E can begin.
Step E must be finished before step Y can begin.
Step K must be finished before step Y can begin.
Step X must be finished before step O can begin.
Step U must be finished before step G can begin.
Step Z must be finished before step P can begin.
Step O must be finished before step S can begin.
Step S must be finished before step G can begin.
Step Y must be finished before step G can begin.
Step P must be finished before step G can begin.
Step C must be finished before step P can begin.
Step N must be finished before step K can begin.
Step E must be finished before step U can begin.
Step C must be finished before step T can begin.
Step F must be finished before step I can begin.
Step Q must be finished before step Y can begin.
Step E must be finished before step S can begin.
Step T must be finished before step P can begin.
Step K must be finished before step O can begin.
Step H must be finished before step Y can begin.
Step Q must be finished before step G can begin.
Step K must be finished before step P can begin.
Step R must be finished before step O can begin.
Step W must be finished before step T can begin.
Step O must be finished before step P can begin.
Step Q must be finished before step X can begin.
Step D must be finished before step I can begin.
Step R must be finished before step T can begin.
Step I must be finished before step K can begin.
Step I must be finished before step G can begin.
Step K must be finished before step G can begin.
Step N must be finished before step U can begin.
Step A must be finished before step Y can begin.
Step X must be finished before step Y can begin.
Step N must be finished before step H can begin.
Step R must be finished before step Z can begin.
Step C must be finished before step Q can begin.
Step F must be finished before step O can begin.
Step B must be finished before step Z can begin.
Step Z must be finished before step S can begin.
Step U must be finished before step S can begin.
Step A must be finished before step K can begin.
Step B must be finished before step N can begin.
Step T must be finished before step E can begin.
Step A must be finished before step N can begin.
Step F must be finished before step V can begin.
Step D must be finished before step C can begin.
Step M must be finished before step P can begin.
Step D must be finished before step V can begin.
Step V must be finished before step Q can begin.
Step O must be finished before step Y can begin.
Step W must be finished before step I can begin.
Step E must be finished before step Z can begin.
Step B must be finished before step R can begin.
Step C must be finished before step X can begin.
Step J must be finished before step T can begin.
Step A must be finished before step W can begin.
Step Q must be finished before step U can begin.
Step I must be finished before step Z can begin.
Step N must be finished before step P can begin.
Step W must be finished before step U can begin.
Step Y must be finished before step P can begin.
Step J must be finished before step P can begin.
Step F must be finished before step Q can begin.
Step L must be finished before step M can begin.
Step E must be finished before step G can begin.
Step B must be finished before step P can begin.
Step H must be finished before step X can begin.
Step W must be finished before step S can begin.
Step N must be finished before step Q can begin.
Step J must be finished before step I can begin.
Step L must be finished before step F can begin.
Step S must be finished before step Y can begin.
Step J must be finished before step X can begin.
Step A must be finished before step H can begin.
Step T must be finished before step U can begin.
Step H must be finished before step Z can begin.
Step W must be finished before step R can begin.
Step X must be finished before step Z can begin.
Step T must be finished before step Y can begin.
Step H must be finished before step T can begin.
Step K must be finished before step U can begin.
Step H must be finished before step G can begin.
Step U must be finished before step O can begin.
Step W must be finished before step P can begin.
Step A must be finished before step D can begin.
STR

my %name;
my %task is default(Hash);

for $str.lines {
    my ($d, $t) = .words.[1, * - 3];
    %task{$t}{$d} = %name{$t} = %name{$d} = 1;
}

my (@order, %run);

while True {
    for %name.keys -> $name {
        if !%task{$name}.defined || %task{$name}.elems == 0 {
            %run{$name} = 1;
            %task{$name}:delete;
            %name{$name}:delete;
        }
    }
    last if +%run == 0;
    given %run.min(*.key).[0].key -> $min {
        @order.push($min);
        %run{$min}:delete;
        for %task {
            .value.{$min}:delete if .value.{$min}:exists;
        }
    }
}

# 1
{
    say " {+@order} TASK => ", @order.join;
}

# 2
{
    my constant MAXWORKER = 5;
    my $totalcost = 0;

    for $str.lines {
        my ($d, $t) = .words.[1, * - 3];
        %task{$t}{$d} = %name{$t} = %name{$d} = 1;
    }
    %name = %name.map({ .key => .key.ord - 4 });
    %run  = %{};

    while True {
        for %name.keys -> $name {
            if !%task{$name}.defined || %task{$name}.elems == 0 {
                %run{$name} = %name{$name};
                %task{$name}:delete;
                %name{$name}:delete;
            }
        }
        last if +%run == 0;
        my @head = %run.sort(*.key).[^MAXWORKER].grep(*.defined);
        my $cost = @head.min(*.value).value;

        $totalcost += $cost;
        for @head -> $task {
            last if ! $task.defined;
            %run{$task.key} -= $cost;
        }
        for %run -> $task {
            if $task.value <= 0 {
                %run{$task.key}:delete;
                for %task {
                    .value.{$task.key}:delete if .value.{$task.key}:exists;
                }
            }
        }
    }

    say "COST => ", $totalcost;
}
