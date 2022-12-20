import std;

void main()
{
    auto f = readText("input").split("\n\n")
        .map!(l => l.split("\n")
                    .filter!(c => !c.empty)
                    .map!(c => c.to!int())
                    .sum())
        .array()
        .sort!"a > b"
        .take(3)
        .sum();

    writeln(f);
}
