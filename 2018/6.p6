my $str = Q:to/STR/;
337, 150
198, 248
335, 161
111, 138
109, 48
261, 155
245, 130
346, 43
355, 59
53, 309
59, 189
325, 197
93, 84
194, 315
71, 241
193, 81
166, 187
208, 95
45, 147
318, 222
338, 354
293, 242
240, 105
284, 62
46, 103
59, 259
279, 205
57, 102
77, 72
227, 194
284, 279
300, 45
168, 42
302, 99
338, 148
300, 316
296, 229
293, 359
175, 208
86, 147
91, 261
188, 155
257, 292
268, 215
257, 288
165, 333
131, 322
264, 313
236, 130
98, 60
STR

class Point {
    has $.x;
    has $.y;
}

my @point = $str.chomp.lines.map({ given .split(', ') { Point.new(x => .[0].Int, y => .[1].Int) } });

my ($lx, $rx, $ly, $ry) = (
    @point.min(*.x).x,
    @point.max(*.x).x,
    @point.min(*.y).y,
    @point.max(*.y).y,
);

say "TOTAL SIZE => ", ($rx - $lx) * ($ry - $ly);

my @closest;
my Int @areas is default(0);
my $region = 0;

for ^($rx - $lx) -> $x {
    for ^($ry - $ly) -> $y {
        my @distance;
        for @point {
            @distance.push( (.x - $lx - $x).abs + (.y - $ly - $y).abs );
        }
        given @distance.minpairs {
            if .elems == 1 {
                my $i = .[0].key;

                if @areas[$i] != -1 {
                    if $x == 0 || $x == ($rx - $lx - 1) || $y == 0 || $y == ($ry - $ly - 1) {
                        @areas[$i] = -1;
                    } else {
                        @areas[$i] += 1;
                    }
                }
            }
        }

        if @distance.sum < 10000 {
            $region += 1;
        }
    }
}

say "largest => ", @areas.max;
say "region size => ", $region;
