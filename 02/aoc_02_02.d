import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.typecons;

enum Shape
{
    rock,
    paper,
    scissors
}

void main()
{
    const res = readText("input")
        .splitLines()
        .map!((l) {
            const elems = split(l);
            return tuple(toShape(elems[0]), toRoundResult(elems[1]));
        })
        .map!(getScore)
        .sum();

    writeln(res);
}

int toRoundResult(string s)
{
    switch (s)
    {
    case "X":
        return -1;
    case "Y":
        return 0;
    case "Z":
        return 1;
    default:
        return int.min;
    }
}

int getScore(Tuple!(Shape, int) round)
{
    const shape = round[0];
    const res = round[1];

    int score;

    if (res == 0) score = 3 + shape + 1;
    else if (res == -1) score = (shape == Shape.rock ? Shape.scissors : shape - 1) + 1;
    else if (res == 1) score = (shape == Shape.scissors ? Shape.rock : shape + 1) + 6 + 1;

    return score;
}

Shape toShape(string s)
{
    return cast(Shape) (s[0] - 'A');
}
