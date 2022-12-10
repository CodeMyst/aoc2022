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

int x = 1;
int cycle = 0;
string[6] crt;

void main()
{
    const cmds = readText("input").splitLines();

    nextCycle();

    foreach (cmd; cmds)
    {
        nextCycle();

        if (cmd == "noop") continue;

        x += cmd.split()[1].to!int();

        nextCycle();
    }

    foreach (row; crt) writeln(row);
}

void nextCycle()
{
    cycle++;

    int cursor = cycle % 40;
    int crtIdx = (cycle - 1) / 40;
    if (crtIdx >= crt.length) return;
    if (cursor >= x && cursor <= x + 2) crt[crtIdx] ~= "#";
    else crt[crtIdx] ~= ".";
}
