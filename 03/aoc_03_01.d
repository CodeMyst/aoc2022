import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.typecons;
import std.ascii;

void main()
{
    const res = readText("input")
        .splitLines()
        .map!(getPriority)
        .sum();

    writeln(res);
}

int getPriority(string rucksack)
{
    string left = rucksack[0..(rucksack.length / 2)];
    string right = rucksack[(rucksack.length / 2)..$];

    int[char] chars1;
    int[char] chars2;

    foreach (c; left)
    {
        if (c in chars1) chars1[c]++;
        else chars1[c] = 1;
    }

    foreach (c; right)
    {
        if (c in chars2) chars2[c]++;
        else chars2[c] = 1;
    }

    char common;

    foreach (l; letters)
    {
        if (l in chars1 && l in chars2)
        {
            common = l;
            break;
        }
    }

    if (isLower(common)) return common - 'a' + 1;
    else return common - 'A' + 27;
}
