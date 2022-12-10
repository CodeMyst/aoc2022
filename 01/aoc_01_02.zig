const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var calories = ArrayList(i32).init(std.heap.page_allocator);
    defer calories.deinit();

    var i: u32 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (i == calories.items.len) try calories.append(0);

        if (line.len == 0) {
            i += 1;
            continue;
        }

        calories.items[i] += try std.fmt.parseInt(i32, line, 0);
    }

    std.sort.sort(i32, calories.items, {}, comptime std.sort.desc(i32));

    const res = calories.items[0] + calories.items[1] + calories.items[2];

    std.debug.print("{d}\n", .{res});
}
