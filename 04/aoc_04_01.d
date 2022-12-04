import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.typecons;
import std.ascii;
import std.conv;

void main()
{
    const res = readText("input").splitLines().map!(checkPair).count!(r => r);

    writeln(res);
}

bool checkPair(string s)
{
    string[] pairs = s.split(",");
    int[] p1 = pairs[0].split("-").map!(to!int).array();
    int[] p2 = pairs[1].split("-").map!(to!int).array();

    if (p1[0] >= p2[0] && p1[1] <= p2[1]) return true;
    else if (p2[0] >= p1[0] && p2[1] <= p1[1]) return true;

    return false;
}
