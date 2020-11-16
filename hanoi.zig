const std = @import("std");
const print = std.debug.print;

const Tower = std.ArrayList(u8);
var towers: [3]Tower = undefined;

const discs = 8;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = &gpa.allocator;

    for (towers) |*t|
        t.* = Tower.init(allocator);

    {
        var i: u8 = discs;
        while (i > 0) : (i -= 1) try towers[0].append(i);
    }

    try printTowers();
    try move(discs, &towers[0], &towers[2], &towers[1]);
}

var moves: std.meta.Int(.unsigned, discs) = 0;

fn move(n: u8, from: *Tower, to: *Tower, aux: *Tower) anyerror!void {
    if (n == 1) {
        try to.append(from.pop());
        const stdout = std.io.getStdOut().writer();
        try stdout.print("\x1b[{}F", .{discs});
        std.time.sleep(@as(u64, 3e9) / (1 << discs));
        moves += 1;
        try printTowers();
    } else {
        try move(n - 1, from, aux, to);
        try move(1, from, to, aux);
        try move(n - 1, aux, to, from);
    }
}

fn printTowers() !void {
    const stdout = std.io.getStdOut().writer();
    const msg = "#" ** discs;
    const pad = " " ** discs;

    var i: u8 = discs - 1;
    while (true) : (i -= 1) {
        for (towers) |t| {
            const msg_slice = if (t.items.len <= i) "" else msg[0..t.items[i]];
            const pad_slice = if (t.items.len <= i) pad else pad[0..(discs - t.items[i])];
            try stdout.print("{0}{1}|{1}{0}", .{ pad_slice, msg_slice });
        }
        if (i == discs - 1) {
            try stdout.print("  Moves: {}", .{moves});
            if (moves +% 1 == 0)
                try stdout.print(" == 2 ^ {} - 1", .{discs});
        }
        try stdout.writeByte('\n');
        if (i == 0) break;
    }
}
