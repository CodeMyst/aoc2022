import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.container;
import std.conv;

void main()
{
    const res = readText("input").getStartOfMessageIndex();

    writeln(res);
}

int getStartOfMessageIndex(string s)
{
    for (int start = 0; start < s.length; start++)
    {
        const end = start + 14;

        if (end + 1 >= s.length) break;

        const seq = s[start..end];

        if (seq.isMarker()) return end;
    }

    return 0;
}

bool isMarker(string seq)
{
    const set = redBlackTree(seq.array());

    return seq.length == set.length;
}
