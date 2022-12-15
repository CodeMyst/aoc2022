import std.stdio;
import std.string;
import std.file;
import std.algorithm;
import std.array;
import std.regex;
import std.conv;
import std.math;
import std.container;
import std.range;

struct Sensor
{
    Point point;

    alias point this;

    Beacon* closest;

    int dist;

    public this(int x, int y, Beacon* closest)
    {
        point.x = x;
        point.y = y;
        this.closest = closest;
    }
}

struct Beacon
{
    Point point;

    alias point this;

    public this(int x, int y)
    {
        point.x = x;
        point.y = y;
    }
}

struct Point
{
    int x;
    int y;
}

const inputRegex = ctRegex!(r"^\D+(-?\d+)\D+(-?\d+)\D+(-?\d+)\D+(-?\d+)$", "mU");

const maxSearchSpace = 4_000_000;

void main()
{
    const lines = readText("input").splitLines();

    Sensor[] sensors;
    Beacon[] beacons;

    foreach (line; lines)
    {
        const match = line.matchFirst(inputRegex);

        beacons ~= Beacon(match[3].to!int, match[4].to!int);
        sensors ~= Sensor(match[1].to!int, match[2].to!int, &beacons[$-1]);
    }

    foreach (ref sensor; sensors) sensor.dist = manhattanDistance(sensor, *sensor.closest);

    foreach(sensor; sensors)
    {
        // top right edge
        for (int y = sensor.y - sensor.dist - 1; y < sensor.y; y++)
        {
            int x = sensor.x + sensor.dist - (sensor.y - y) + 1;

            if ((x < 0 || x > maxSearchSpace) || (y < 0 || y > maxSearchSpace)) continue;

            if (!isCovered(Point(x, y), sensors))
            {
                writeln(cast(long) x * maxSearchSpace + y);
                writeln(x, " ", y);
            }
        }

        // bottom right edge
        for (int y = sensor.y; y < sensor.y + sensor.dist + 1; y++)
        {
            int x = sensor.x + sensor.dist - (y - sensor.y) + 1;

            if ((x < 0 || x > maxSearchSpace) || (y < 0 || y > maxSearchSpace)) continue;

            if (!isCovered(Point(x, y), sensors))
            {
                writeln(cast(long) x * maxSearchSpace + y);
                writeln(x, " ", y);
            }
        }

        // top left edge
        for (int y = sensor.y - sensor.dist - 1; y < sensor.y; y++)
        {
            int x = sensor.x - sensor.dist + (sensor.y - y) - 1;

            if ((x < 0 || x > maxSearchSpace) || (y < 0 || y > maxSearchSpace)) continue;

            if (!isCovered(Point(x, y), sensors))
            {
                writeln(cast(long) x * maxSearchSpace + y);
                writeln(x, " ", y);
            }
        }

        // bottom left edge
        for (int y = sensor.y; y < sensor.y + sensor.dist + 1; y++)
        {
            int x = sensor.x - sensor.dist + (y - sensor.y) - 1;

            if ((x < 0 || x > maxSearchSpace) || (y < 0 || y > maxSearchSpace)) continue;

            if (!isCovered(Point(x, y), sensors))
            {
                writeln(cast(long) x * maxSearchSpace + y);
                writeln(x, " ", y);
            }
        }
    }
}

bool isCovered(Point p, Sensor[] sensors)
{
    foreach(sensor; sensors)
    {
        if (p.x >= sensor.x - sensor.dist &&
            p.x <= sensor.x + sensor.dist &&
            p.y >= sensor.y - sensor.dist &&
            p.y <= sensor.y + sensor.dist) return true;
    }

    return false;
}

int manhattanDistance(Point a, Point b)
{
    return abs(a.x - b.x) + abs(a.y - b.y);
}
