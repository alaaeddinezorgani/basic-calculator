const std = @import("std");
const Lexer = @import("lexer.zig").Lexer;
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;


pub const Parser = struct {
    lexer: *Lexer,
    current: Token,

    fn eat(self: *Parser, typ: TokenType) void {
        if (self.current.typ == typ) {
            self.current = self.lexer.nextToken();
        } else {
            @panic("Unexpected token");
        }
    }

    fn factor(self: *Parser) f64 {
        const tok = self.current;
        switch (tok.typ) {
            .Number => {
                self.eat(.Number);
                return tok.value;
            },
            .LParen => {
                self.eat(.LParen);
                const val = self.expr();
                self.eat(.RParen);
                return val;
            },
            else => @panic("Invalid factor"),
        }
    }

    fn term(self: *Parser) f64 {
        var result = self.factor();
        while (self.current.typ == .Star or self.current.typ == .Slash) {
            const op = self.current.typ;
            self.eat(op);
            const rhs = self.factor();
            result = switch (op) {
                .Star => result * rhs,
                .Slash => result / rhs,
                else => result,
            };
        }
        return result;
    }

    fn expr(self: *Parser) f64 {
        var result = self.term();
        while (self.current.typ == .Plus or self.current.typ == .Minus) {
            const op = self.current.typ;
            self.eat(op);
            const rhs = self.term();
            result = switch (op) {
                .Plus => result + rhs,
                .Minus => result - rhs,
                else => result,
            };
        }
        return result;
    }

    pub fn parse(self: *Parser) f64 {
        return self.expr();
    }
};
