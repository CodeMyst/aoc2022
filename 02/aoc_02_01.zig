const std = @import("std");
const mem = std.mem;

const Shape = enum {
    rock,
    paper,
    scissors,
};

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var score: i32 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const sep = mem.indexOf(u8, line, " ") orelse unreachable;

        const a = toShape(line[0..sep]);
        const b = toShape(line[sep+1..]);

        score += getScore(a, b);
    }

    std.debug.print("{}\n", .{score});
}

fn getScore(a: Shape, b: Shape) i32 {
    var win: i32 = 0;

    if (a == .rock and b == .paper) { win = 1; }
    else if (a == .rock and b == .scissors) { win = -1; }
    else if (a == .paper and b == .rock) { win = -1; }
    else if (a == .paper and b == .scissors) { win = 1; }
    else if (a == .scissors and b == .rock) { win = 1; }
    else if (a == .scissors and b == .paper) { win = -1; }

    var score: i32 = @enumToInt(b) + 1;

    if (win == 1) { score += 6; }
    else if (win == 0) { score += 3; }

    return score;
}

fn toShape(shape: []const u8) Shape {
    if (mem.eql(u8, shape, "A") or mem.eql(u8, shape, "X")) return .rock;
    if (mem.eql(u8, shape, "B") or mem.eql(u8, shape, "Y")) return .paper;

    return .scissors;
}
