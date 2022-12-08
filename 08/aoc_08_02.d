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

    int bestScore = int.min;

    for (int y = 1; y < height - 1; y++)
    {
        for (int x = 1; x < width - 1; x++)
        {
            const s = getScore(x, y, map);
            if (s > bestScore) bestScore = s;
        }
    }

    writeln(bestScore);
}

int getScore(int x, int y, int[][] map)
{
    return scoreFromTop(x, y, map) * scoreFromLeft(x, y, map) * scoreFromRight(x, y, map) * scoreFromBottom(x, y, map);
}

int scoreFromTop(int x, int y, int[][] map)
{
    int score = 0;
    const val = map[y][x];
    for (int ny = y - 1; ny >= 0; ny--)
    {
        score++;
        if (map[ny][x] >= val) break;
    }

    return score;
}

int scoreFromLeft(int x, int y, int[][] map)
{
    int score = 0;
    const val = map[y][x];
    for (int nx = x - 1; nx >= 0; nx--)
    {
        score++;
        if (map[y][nx] >= val) break;
    }

    return score;
}

int scoreFromRight(int x, int y, int[][] map)
{
    int score = 0;
    const val = map[y][x];
    for (int nx = x + 1; nx < map.length; nx++)
    {
        score++;
        if (map[y][nx] >= val) break;
    }

    return score;
}

int scoreFromBottom(int x, int y, int[][] map)
{
    int score = 0;
    const val = map[y][x];
    for (int ny = y + 1; ny < map.length; ny++)
    {
        score++;
        if (map[ny][x] >= val) break;
    }

    return score;
}
