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
import std.typecons;

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

    for (int y = 0; y <= maxSearchSpace; y++)
    {
        Tuple!(int, int)[] intervals;

        foreach (sensor; sensors)
        {
            const distToY = abs(sensor.y - y);
            if (distToY <= sensor.dist)
            {
                const dt = sensor.dist - distToY;
                intervals ~= tuple(sensor.x - dt, sensor.x + dt);
            }
        }

        intervals.sort!((a, b) => a[0] < b[0]);
        for (int i = 1; i < intervals.length; i++)
        {
            if (intervals[i][1] <= intervals[i-1][1])
            {
                intervals = intervals.remove(i);
                i--;
            }
        }

        for (int i = 0; i + 1 < intervals.length; i++)
        {
            if (intervals[i][1] + 1 < intervals[i+1][0])
            {
                writeln(intervals[i][1] + 1, " ", y);
                writeln(cast(long) (intervals[i][1] + 1) * cast(long) 4_000_000 + cast(long) y);
                return;
            }
        }
    }
}

int manhattanDistance(Point a, Point b)
{
    return abs(a.x - b.x) + abs(a.y - b.y);
}
