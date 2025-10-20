const std = @import("std");

pub const TokenType = enum {
    Number,
    Plus,
    Minus,
    Star,
    Slash,
    LParen,
    RParen,
    EOF,
};

pub const Token = struct {
    typ: TokenType,
    value: f64 = 0,
};
