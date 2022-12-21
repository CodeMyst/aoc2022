#!/usr/bin/env dub
/+ dub.sdl:
  name "runner"
  dependency "console-colors" version="~>1.0.8"
 +/

import std;
import std.datetime.stopwatch;
import consolecolors;

void main()
{
    const lastDay = dirEntries(".", SpanMode.shallow)
        .filter!(d => d.isDir && d.name != "./.git")
        .map!(s => s.strip("./").to!int)
        .reduce!max();
    
    long total;
    
    foreach (i; 1 .. lastDay + 1)
    {
        const day = format("%.2d", i);
        cwriteln("<magenta>day ", day, ":</magenta>");

        auto sw = StopWatch(AutoStart.yes);
        auto o = execute(["rdmd", "aoc_" ~ day ~ "_01.d"], null, Config(), ulong.max, day);
        sw.stop();

        total += sw.peek.total!"msecs";

        bool multiline = o.output.count("\n") > 1;

        cwriteln("  <magenta>part 1:</magenta> ",
            multiline ? "<black>(multiline output)</black>" : "<blue>" ~ o.output.strip() ~ "</blue>",
            " <lgreen>", sw.peek.total!"msecs", "ms</lgreen>");

        if (exists(day ~ "/aoc_" ~ day ~ "_02.d"))
        {
            sw.reset();
            sw.start();
            o = execute(["rdmd", "aoc_" ~ day ~ "_02.d"], null, Config(), ulong.max, day);
            sw.stop();

            total += sw.peek.total!"msecs";

            multiline = o.output.count("\n") > 1;

            cwriteln("  <magenta>part 2:</magenta> ",
                multiline ? "<black>(multiline output)</black>" : "<blue>" ~ o.output.strip() ~ "</blue>",
                " <lgreen>", sw.peek.total!"msecs", "ms</lgreen>");
        }

        writeln();
    }

    cwriteln("<magenta>total:</magenta> <lgreen>", total, "ms</lgreen>");
}
