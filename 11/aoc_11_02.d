import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.conv;
import std.regex;

struct Monkey
{
    long[] items;
    string op;
    int opValue;
    int test;
    int trueMonkey;
    int falseMonkey;

    int numInspected;
}

Monkey[] monkeys;

auto monkeyRegex = ctRegex!(r".*(\d+):\s*.*:\s(.*)$\s.*old\s([*+])\s(old|\d+)\s.*by\s(\d+)\s.*(\d+)\s.*(\d+)", "gm");

void main()
{
    const lines = readText("input").splitLines();

    for (int i = 0; i < (lines.length + 1) / 7; i++)
    {
        monkeys ~= parseMonkey(lines[i*7..i*7+6]);
    }

    const normalizationModulo = monkeys.map!(m => m.test).reduce!((acc, cur) => acc * cur);

    foreach(_; 0 .. 10_000) round(normalizationModulo);

    monkeys.sort!((a, b) => a.numInspected > b.numInspected);

    writeln(cast(ulong) monkeys[0].numInspected * cast(ulong) monkeys[1].numInspected);
}

void round(int normalizationModulo)
{
    foreach (ref monke; monkeys)
    {
        foreach (item; monke.items)
        {
            const opTo = monke.opValue == -1 ? item : monke.opValue;

            if (monke.op == "*") item *= opTo;
            else item += opTo;

            item %= normalizationModulo;

            if (item % monke.test == 0) monkeys[monke.trueMonkey].items ~= item;
            else monkeys[monke.falseMonkey].items ~= item;

            monke.numInspected++;
        }

        monke.items = [];
    }
}

Monkey parseMonkey(const string[] s)
{
    const match = s.join("\n").matchFirst(monkeyRegex);

    assert(!match.empty);

    return Monkey(match[2].split(", ").map!(x => x.to!long()).array(),
                  match[3],
                  match[4] == "old" ? -1 : match[4].to!int(),
                  match[5].to!int(),
                  match[6].to!int(),
                  match[7].to!int());
}
