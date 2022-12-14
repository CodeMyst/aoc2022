import std.stdio;
import std.file;
import std.string;
import std.algorithm;
import std.array;
import std.conv;
import std.math;

struct Point { int x; int y; }

enum Tile { air, rock, sand }

const Point sandSource = Point(500, 0);

void main()
{
    const allPaths = readText("input").splitLines().map!(parsePath).array();

    int maxX = int.min;
    int maxY = int.min;

    foreach (paths; allPaths)
    {
        for (int i = 0; i < paths.length; i++)
        {
            if (paths[i].y > maxY)
            {
                maxY = paths[i].y + 1;
            }
            else if (paths[i].x > maxX)
            {
                maxX = paths[i].x + 1;
            }
        }
    }

    Tile[][] map = new Tile[][](maxY + 2, maxX + 200);

    map[$-1][0..$-1] = Tile.rock;

    fillRocks(map, allPaths);

    writeln(getMaxSand(map));

    // printMap(map);
}

int getMaxSand(Tile[][] map)
{
    int i = 0;
    Point sand;
    while (sand != sandSource)
    {
        sand = spawnSand(map);

        i++;
    }

    return i;
}

Point spawnSand(Tile[][] map)
{
    Point sand = sandSource;

    while (true)
    {
        if (sand.y + 1 >= map.length)
        {
            break;
        }

        if (map[sand.y+1][sand.x] == Tile.air)
        {
            sand.y++;
        }
        else if (map[sand.y+1][sand.x-1] == Tile.air)
        {
            sand.x--;
            sand.y++;
        }
        else if (map[sand.y+1][sand.x+1] == Tile.air)
        {
            sand.x++;
            sand.y++;
        }
        else
        {
            break;
        }
    }

    map[sand.y][sand.x] = Tile.sand;

    return sand;
}

Point[] parsePath(string p)
{
    const paths = p.split(" -> ");

    Point[] res;

    foreach (path; paths)
    {
        const coords = path.split(",");
        res ~= Point(coords[0].to!int, coords[1].to!int);
    }

    return res;
}

void fillRocks(Tile[][] map, const Point[][] allPaths)
{
    foreach (paths; allPaths)
    {
        for (int i = 0; i + 1 < paths.length; i++)
        {
            const p1 = paths[i];
            const p2 = paths[i+1];
            const dx = p2.x - p1.x;
            const dy = p2.y - p1.y;

            for (int j = 0; j <= abs(dx) + abs(dy); j++)
            {
                map[p1.y + j * sgn(dy)][p1.x + j * sgn(dx)] = Tile.rock;
            }
        }
    }
}

void printMap(Tile[][] map)
{
    for (int y = 0; y < map.length; y++)
    {
        for (int x = 450; x < map[0].length; x++)
        {
            if (map[y][x] == Tile.rock) write("#");
            else if (map[y][x] == Tile.air) write(".");
            else if (map[y][x] == Tile.sand) write("o");
        }

        writeln();
    }
}
