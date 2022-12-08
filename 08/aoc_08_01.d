import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.container;
import std.conv;
import std.range;
import std.typecons;

void main()
{
    const lines = readText("input").splitLines();

    const width = lines[0].length;
    const height = width;

    int[][] map = new int[][](height, width);

    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            map[y][x] = lines[y][x].to!string().to!int();
        }
    }

    long visible = 4 * width - 4;

    for (int y = 1; y < height - 1; y++)
    {
        for (int x = 1; x < width - 1; x++)
        {
            if (checkVisible(x, y, map)) visible++;
        }
    }

    writeln(visible);
}

bool checkVisible(int x, int y, int[][] map)
{
    if (visibleFromTop(x, y, map)) return true;
    if (visibleFromBottom(x, y, map)) return true;
    if (visibleFromLeft(x, y, map)) return true;
    if (visibleFromRight(x, y, map)) return true;

    return false;
}

bool visibleFromTop(int x, int y, int[][] map)
{
    const val = map[y][x];
    for (int ny = y - 1; ny >= 0; ny--)
    {
        if (map[ny][x] >= val) return false;
    }

    return true;
}

bool visibleFromLeft(int x, int y, int[][] map)
{
    const val = map[y][x];
    for (int nx = x - 1; nx >= 0; nx--)
    {
        if (map[y][nx] >= val) return false;
    }

    return true;
}

bool visibleFromRight(int x, int y, int[][] map)
{
    const val = map[y][x];
    for (int nx = x + 1; nx < map.length; nx++)
    {
        if (map[y][nx] >= val) return false;
    }

    return true;
}

bool visibleFromBottom(int x, int y, int[][] map)
{
    const val = map[y][x];
    for (int ny = y + 1; ny < map.length; ny++)
    {
        if (map[ny][x] >= val) return false;
    }

    return true;
}
