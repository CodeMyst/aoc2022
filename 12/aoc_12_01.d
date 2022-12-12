import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.math;
import std.algorithm;
import std.array;

class Node
{
    public int x;
    public int y;
    public Node parent = null;
    public int cost;
    public int dist;

    int costDistance() { return cost + dist; }

    void setDist(int targetX, int targetY) { dist = abs(targetX - x) + abs(targetY - y); }

    public this(int x, int y) { this.x = x; this.y = y; }

    public this(int x, int y, Node parent, int cost) { this.x = x; this.y = y; this.parent = parent; this.cost = cost; }
}

void main()
{
    const lines = readText("input").splitLines();

    const width = lines[0].length;
    const height = lines.length;

    string[][] map = new string[][](height, width);

    Node start;
    Node end;

    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            const t = lines[y][x].to!string();

            if (t == "S")
            {
                start = new Node(x, y);
            }
            else if (t == "E")
            {
                end = new Node(x, y);
            }

            map[y][x] = t;
        }
    }

    start.setDist(end.x, end.y);

    Node[] activeNodes = [start];
    Node[] visitedNodes;

    int steps = 0;

    while (activeNodes.length > 0)
    {
        auto check = activeNodes.sort!((a, b) => a.costDistance < b.costDistance).array()[0];

        if (check.x == end.x && check.y == end.y)
        {
            Node parent = check.parent;
            while (parent !is null)
            {
                steps++;
                parent = parent.parent;
            }
            break;
        }

        visitedNodes ~= check;
        activeNodes.remove!(n => n.x == check.x && n.y == check.y);

        auto walkable = walkableTiles(map, check, end);

        foreach(ref w; walkable)
        {
            if (visitedNodes.canFind!(n => n.x == w.x && n.y == w.y)) continue;

            if (activeNodes.canFind!(n => n.x == w.x && n.y == w.y))
            {
                auto existing = activeNodes.find!(n => n.x == w.x && n.y == w.y)[0];
                if (existing.costDistance > check.costDistance)
                {
                    activeNodes.remove!(n => n.x == existing.x && n.y == existing.y);
                    activeNodes ~= w;
                }
            }
            else
            {
                activeNodes ~= w;
            }
        }
    }

    writeln(steps);
}

Node[] walkableTiles(string[][] map, Node current, Node target)
{
    Node[] possible = [
        new Node(current.x, current.y - 1, current, current.cost + 1),
        new Node(current.x, current.y + 1, current, current.cost + 1),
        new Node(current.x - 1, current.y, current, current.cost + 1),
        new Node(current.x + 1, current.y, current, current.cost + 1),
    ];

    foreach (p; possible) p.setDist(target.x, target.y);

    const width = map[0].length;
    const height = map.length;

    return possible.filter!(n => n.x >= 0 && n.x < width)
                   .filter!(n => n.y >= 0 && n.y < height)
                   .filter!(n => isWalkable(map[current.y][current.x], map[n.y][n.x]))
                   .array();
}

bool isWalkable(string current, string test)
{
    if (current == "S") return true;
    if (test == "E") return 'z' - current[0] <= 1;
    return test[0] - current[0] <= 1;
}
