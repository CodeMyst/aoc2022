import std.stdio;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.math;
import std.typecons;

struct Valve
{
    string name;
    int rate;
    string[] leadsToNames;
    long[] leadsTo;
}

Valve[] valves;

void main()
{
    valves = readText("input").splitLines().map!(toValve).array();

    foreach (ref v; valves)
    {
        foreach (name; v.leadsToNames) v.leadsTo ~= valves.countUntil!(x => x.name == name);
    }

    bool[long] o;
    const res = findMaxFlow(valves.countUntil!(x => x.name == "AA"), o, 30);

    writeln(res);
}

int[Tuple!(long, bool[long], int)] cache;

int findMaxFlow(long cur, bool[long] opened, int minutesLeft)
{
    if (minutesLeft <= 0) return 0;

    auto cacheTuple = tuple(cur, opened, minutesLeft);
    if (cacheTuple in cache) return cache[cacheTuple];

    int best;

    if (cur !in opened)
    {
        const val = (minutesLeft - 1) * valves[cur].rate;
        auto curOpened = opened.dup;
        curOpened[cur] = true;

        foreach (l; valves[cur].leadsTo)
        {
            if (val != 0) best = max(best, val + findMaxFlow(l, curOpened, minutesLeft - 2));

            best = max(best, findMaxFlow(l, opened, minutesLeft - 1));
        }
    }
    else
    {
        foreach (l; valves[cur].leadsTo) best = max(best, findMaxFlow(l, opened, minutesLeft - 1));
    }

    if (cacheTuple !in cache) cache[cacheTuple] = best;

    return best;
}

Valve toValve(string s)
{
    string name = s[6..8];
    int rate = s[23..s.indexOf(";")].to!int();
    string[] leadsTo = s[s.indexOf("valve")+6..$].strip().split(", ");

    return Valve(name, rate, leadsTo);
}
