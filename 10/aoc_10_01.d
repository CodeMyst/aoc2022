import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.container;
import std.conv;
import std.range;
import std.typecons;
import std.math;

const int[] targetCycles = [20, 60, 100, 140, 180, 220];

int x = 1;
int cycle = 1;
int[] signalStrengths;

void main()
{
    const cmds = readText("input").splitLines();

    foreach (cmd; cmds)
    {
        nextCycle();

        if (cmd == "noop") continue;

        x += cmd.split()[1].to!int();

        nextCycle();
    }

    writeln(signalStrengths.sum());
}

void nextCycle()
{
    cycle++;

    if (targetCycles.canFind(cycle)) signalStrengths ~= cycle * x;
}
