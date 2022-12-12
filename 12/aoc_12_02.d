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
    public int gCost = 0;
    public int hCost = 0;

    public this(int x, int y) { this.x = x; this.y = y; }
}

void main()
{
    const lines = readText("input").splitLines();

    const width = lines[0].length;
    const height = lines.length;

    string[][] map = new string[][](height, width);

    Node end;

    Node[] lowestPoints;

    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            const t = lines[y][x].to!string();

            if (t == "E")
            {
                end = new Node(x, y);
            }
            else if (t == "a" || t == "S")
            {
                lowestPoints ~= new Node(x, y);
            }

            map[y][x] = t;
        }
    }

    int[] trailPaths;

    foreach(low; lowestPoints) trailPaths ~= getShortestPath(map, low, end);

    trailPaths.filter!(a => a != 0).array().sort!((a, b) => a < b);

    writeln(trailPaths[0]);
}

int getShortestPath(string[][] map, Node start, Node end)
{
    Node[] openSet = [start];
    Node[] closedSet;

    int steps = 0;

    while (openSet.length > 0)
    {
        Node current = openSet[0];
        int currentIdx = 0;

        for (int i = 1; i < openSet.length; i++)
        {
            if ((openSet[i].hCost + openSet[i].gCost) <= (current.hCost + current.gCost))
            {
                if (openSet[i].hCost < current.hCost)
                {
                    current = openSet[i];
                    currentIdx = i;
                }
            }
        }

        openSet = openSet.remove(currentIdx);
        closedSet ~= current;

        if (current.x == end.x && current.y == end.y)
        {
            Node parent = current.parent;
            while (parent !is null)
            {
                steps++;
                parent = parent.parent;
            }
            break;
        }

        auto neighbours = getNeighbours(map, current);

        foreach(n; neighbours)
        {
            if (!isWalkable(map[current.y][current.x], map[n.y][n.x]) ||
                closedSet.canFind!(e => e.x == n.x && e.y == n.y)) continue;
            
            const newCost = current.gCost + getDistance(current, n);
            const found = openSet.canFind!(e => e.x == n.x && e.y == n.y);
            if (newCost < n.gCost || !found)
            {
                n.gCost = newCost;
                n.hCost = getDistance(n, end);
                n.parent = current;

                if (!found) openSet ~= n;
            }
        }
    }

    return steps;
}

int getDistance(Node a, Node b)
{
    int dstX = abs(a.x - b.x);
    int dstY = abs(a.y - b.y);

    return dstX > dstY ? 14 * dstY + 10 * (dstX - dstY) : 14 * dstX + 10 * (dstY - dstX);
}

Node[] getNeighbours(string[][] map, Node current)
{
    Node[] possible = [
        new Node(current.x, current.y - 1),
        new Node(current.x, current.y + 1),
        new Node(current.x - 1, current.y),
        new Node(current.x + 1, current.y),
    ];

    const width = map[0].length;
    const height = map.length;

    return possible.filter!(n => n.x >= 0 && n.x < width)
                   .filter!(n => n.y >= 0 && n.y < height)
                   .array();
}

bool isWalkable(string current, string test)
{
    const c = current == "S" ? 'a' : current[0];
    const t = test == "E" ? 'z' : test[0];
    return t - c <= 1;
}
