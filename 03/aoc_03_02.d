import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.typecons;
import std.ascii;

void main()
{
    const rucksacks = readText("input").splitLines();
    
    int[] priorities;
    
    for (int i = 0; i < rucksacks.length / 3; i++)
    {
        priorities ~= getPriority(rucksacks[i*3..i*3+3]);
    }

    writeln(priorities.sum());
}

int getPriority(const string[] rucksacks)
{
    int[char][] frequencies = rucksacks.map!(getCharFrequency).array();

    char common;

    foreach (c; letters)
    {
        if (c in frequencies[0] && c in frequencies[1] && c in frequencies[2])
        {
            common = c;
            break;
        }
    }

    if (isLower(common)) return common - 'a' + 1;
    else return common - 'A' + 27;
}

int[char] getCharFrequency(string s)
{
    int[char] res;

    foreach (c; s)
    {
        if (c in res) res[c]++;
        else res[c] = 1;
    }

    return res;
}
