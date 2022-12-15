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
import std.parallelism;

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

const goal = 2_000_000; // full input
// const goal = 10; // example

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

    const covered = getCoveredPoints(sensors);

    int res = 0;
    foreach (pos; covered.byKey)
    {
        if (beacons.canFind!(b => b.x == pos && b.y == goal)) continue;

        res++;
    }

    writeln(res);
}

auto getCoveredPoints(Sensor[] sensors)
{
    bool[int] res;

    foreach(sensor; sensors)
    {
        const dist = sensor.dist;

        if (sensor.y - dist > goal || sensor.y + dist < goal) continue;

        auto startX = sensor.x - dist;
        auto endX = sensor.x + dist;

        if (sensor.y >= goal)
        {
            startX += sensor.y - goal;
            endX -= sensor.y - goal;
        }
        else
        {
            startX += goal - sensor.y;
            endX -= goal - sensor.y;
        }

        for (int x = startX; x <= endX; x++) res[x] = true;
    }

    return res;
}

int manhattanDistance(Point a, Point b)
{
    return abs(a.x - b.x) + abs(a.y - b.y);
}
