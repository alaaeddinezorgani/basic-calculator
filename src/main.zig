const std = @import("std");
const Lexer = @import("lexer.zig").Lexer;
const Parser = @import("parser.zig").Parser;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const stdout_fd = std.posix.STDOUT_FILENO;
    const stdin_fd = std.posix.STDIN_FILENO;

    var buf: [256]u8 = undefined;

    try std.posix.write(stdout_fd, "Simple Zig Arithmetic Interpreter\n");
    try std.posix.write(stdout_fd, "Enter expressions, or 'exit' to quit.\n\n");

    while (true) {
        try std.posix.write(stdout_fd, "> ");

        const n = try std.posix.read(stdin_fd, &buf);
        if (n == 0) break; // EOF

        const line = std.mem.trim(u8, buf[0..n], " \t\r\n");
        if (std.mem.eql(u8, line, "exit")) break;
        if (line.len == 0) continue;

        var lexer = Lexer{ .input = line };
        var parser = Parser{ .lexer = &lexer, .current = lexer.nextToken() };

        const result = parser.parse();
        var out_buf: [64]u8 = undefined;
        const len = try std.fmt.bufPrint(&out_buf, "= {d}\n", .{result});
        try std.posix.write(stdout_fd, out_buf[0..len]);
    }

    try std.posix.write(stdout_fd, "\nGoodbye!\n");
}

