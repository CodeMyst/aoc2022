import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.conv;

void main()
{
    const input = readText("input");

    char[][] stacks;
    auto readStacks = false;

    const lines = input.splitLines();

    foreach (line; lines)
    {
        if (!readStacks && line.startsWith(" 1"))
        {
            readStacks = true;
            foreach (ref s; stacks)
            {
                s = s.reverse();
            }
        }

        if (!readStacks)
        {
            const s = toStacks(line);

            foreach (i, x; s)
            {
                if (i + 1 > stacks.length) stacks.length++;

                if (x == ' ') continue;

                stacks[i] ~= x;
            }
        }
        else
        {
            if (!line.startsWith("move")) continue;

            const words = line.split();
            const quantity = words[1].to!int();
            const from = words[3].to!int() - 1;
            const to = words[5].to!int() - 1;

            stacks[to] ~= stacks[from][$-quantity..$];
            stacks[from].length -= quantity;
        }
    }

    string res;
    foreach (stack; stacks) res ~= stack[$-1];

    writeln(res);
}

char[] toStacks(string s)
{
    char[] res;

    for (int i = 0; i < (s.length + 1) / 4; i++)
    {
        const start = i*4;
        auto end = start+4;
        if (i == (s.length + 1) / 4 - 1) end = start+3;

        const container = s[start..end].strip();

        if (container.length < 3)
        {
            res ~= ' ';
        }
        else
        {
            res ~= container[1];
        }
    }

    return res;
}
