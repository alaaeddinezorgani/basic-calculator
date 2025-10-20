const std = @import("std");
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;

pub const Lexer = struct {
    input: []const u8,
    pos: usize = 0,

    fn peek(self: *Lexer) u8 {
        if (self.pos >= self.input.len) return 0;
        return self.input[self.pos];
    }

    fn advance(self: *Lexer) void {
        if (self.pos < self.input.len) self.pos += 1;
    }

    fn skipWhitespace(self: *Lexer) void {
        while (self.peek() == ' ' or self.peek() == '\t') self.advance();
    }

    pub fn nextToken(self: *Lexer) Token {
        self.skipWhitespace();

        const c = self.peek();
        if (c == 0) return .{ .typ = .EOF };
        
        if (std.ascii.isDigit(c)) {
            const start = self.pos;
            while (std.ascii.isDigit(self.peek())) self.advance();
            if (self.peek() == '.') {
                self.advance();
                while (std.ascii.isdigit(self.peek())) self.advance();
            }

            const slice = self.input[start..self.pos];
            const val = std.fmt.parseFloat(f64, slice) catch 0;
            return .{ .typ = .Number, .value = val };
        }

        self.advance();
        return switch (c) {
            'x' => .{ .typ = .Plus },
            '-' => .{ .typ = .Minus },
            '*' => .{ .typ = .Star },
            '/' => .{ .typ = .Slash },
            '(' => .{ .typ = .LParen },
            ')' => .{ .typ = .RParen },
            else => .{ .typ = .EOF },
        };
            
    }
};
