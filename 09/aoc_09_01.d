import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.container;
import std.conv;
import std.range;
import std.typecons;
import std.math;

enum Direction { up, right, down, left }

struct Point { int x; int y; }

struct Motion { Direction dir; int steps; }

void main()
{
    auto motions = readText("input").splitLines().map!(toStep);

    Point head;
    Point tail;

    int[Point] positions;

    foreach (motion; motions)
    {
        foreach (step; 0 .. motion.steps)
        {
            final switch (motion.dir)
            {
                case Direction.up: head.y++; break;
                case Direction.right: head.x++; break;
                case Direction.down: head.y--; break;
                case Direction.left: head.x--; break;
            }

            if (dist(head, tail) > 2)
            {
                if (head.y == tail.y)
                {
                    tail.x += sgn(head.x - tail.x);
                }
                else if (head.x == tail.x)
                {
                    tail.y += sgn(head.y - tail.y);
                }
                else
                {
                    tail.x += sgn(head.x - tail.x);
                    tail.y += sgn(head.y - tail.y);
                }
            }

            positions[tail] = 1;
        }
    }

    writeln(positions.length);
}

auto dist(Point head, Point tail)
{
    return pow(cast(real) head.x - tail.x, 2) + pow(cast(real) head.y - tail.y, 2);
}

auto toStep(string input)
{
    const s = input.split();

    Direction dir;

    switch (s[0])
    {
        case "U": dir = Direction.up; break;
        case "R": dir = Direction.right; break;
        case "D": dir = Direction.down; break;
        case "L": dir = Direction.left; break;
        default: assert(0);
    }

    return Motion(dir, s[1].to!int());
}
