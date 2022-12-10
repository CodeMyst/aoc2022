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

        const shape = toShape(line[0..sep]);
        const res = toRoundRes(line[sep+1..]);

        score += getScore(shape, res);
    }

    std.debug.print("{}\n", .{score});
}

fn getScore(shape: Shape, res: i32) i32 {
    var score: i32 = 0;

    if (res == 0) {
        score = 3 + @intCast(i32, @enumToInt(shape) + 1);
    } else if (res == -1) {
        score = @intCast(i32, if (shape == .rock) @enumToInt(Shape.scissors) else @enumToInt(shape) - 1) + 1;
    } else if (res == 1) {
        score = @intCast(i32, if (shape == .scissors) @enumToInt(Shape.rock) else @enumToInt(shape) + 1) + 6 + 1;
    }

    return score;
}

fn toRoundRes(res: []const u8) i32 {
    if (mem.eql(u8, res, "X")) return -1;
    if (mem.eql(u8, res, "Y")) return 0;

    return 1;
}

fn toShape(shape: []const u8) Shape {
    return @intToEnum(Shape, shape[0] - 'A');
}
