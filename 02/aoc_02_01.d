import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;

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
        .map!(l => split(l).map!(toShape))
        .map!(r => getScore(r[0], r[1]))
        .sum();

    writeln(res);
}

int getScore(Shape a, Shape b)
{
    int win = 0;
    if (a == Shape.rock && b == Shape.paper) win = 1;
    else if (a == Shape.rock && b == Shape.scissors) win = -1;
    else if (a == Shape.paper && b == Shape.rock) win = -1;
    else if (a == Shape.paper && b == Shape.scissors) win = 1;
    else if (a == Shape.scissors && b == Shape.rock) win = 1;
    else if (a == Shape.scissors && b == Shape.paper) win = -1;

    int score = b + 1;

    if (win == 1) score += 6;
    else if (win == 0) score += 3;

    return score;
}

Shape toShape(string s)
{
    switch (s)
    {
    case "A":
    case "X":
        return Shape.rock;
    case "B":
    case "Y":
        return Shape.paper;
    case "C":
    case "Z":
        return Shape.scissors;
    default:
        return Shape.init;
    }
}
