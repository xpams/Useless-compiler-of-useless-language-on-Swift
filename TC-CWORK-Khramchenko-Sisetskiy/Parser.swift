//
//  Parser.swift
//  TC-CWORK-Khramchenko-Sisetskiy
//
//  Created by Nikolay Khramchenko on 6/20/18.
//  Copyright © 2018 NX. All rights reserved.
//

import Foundation

class Parser {
    static let VAR = 0;
    static let CONST = 1;
    static let ADD = 2;
    static let SUB = 3;
    static let LT = 4;
    static let SET = 5;
    static let IF1 = 6;
    static let IF2 = 7;
    static let WHILE = 8;
    static let DO = 9;
    static let EMPTY = 10;
    static let SEQ = 11;
    static let EXPR = 12;
    static let PROG = 13;
    
    var lexer: Lexer;
    
    init(lexer: Lexer) {
        self.lexer = lexer;
    }
    
    func error(msg: String) {
        print("Parser error: \(msg)");
        exit(1);
    }
    
    func term() -> Node {
        if (self.lexer.sym == Lexer.ID) {
            let n = Node(kind: Parser.VAR, value: self.lexer.value, op1: nil, op2: nil, op3: nil);
            self.lexer.nextTok();
            return n;
        } else if (self.lexer.sym == Lexer.NUM) {
            let n = Node(kind: Parser.CONST, value: self.lexer.value, op1: nil, op2: nil, op3: nil);
            self.lexer.nextTok();
            return n;
        } else {
            return self.parenExpr();
        }
    }
    
    var kind: Int?;
    
    func summa() -> Node {
        var n = self.term();
        while self.lexer.sym == Lexer.PLUS || self.lexer.sym == Lexer.MINUS {
            if (self.lexer.sym == Lexer.PLUS) {
                self.kind = Parser.ADD;
            } else {
                self.kind = Parser.SUB;
            }
            self.lexer.nextTok();
            n = Node(kind: self.kind, value: nil, op1: n, op2: self.term(), op3: nil);
        }
        return n;
    }
    
    func test() -> Node {
        var n = self.summa();
        if self.lexer.sym == Lexer.LESS{
            self.lexer.nextTok();
            n = Node(kind: Parser.LT, value: nil, op1: n, op2: self.summa(), op3: nil);
        }
        return n;
    }
    
    func expr() -> Node {
        if (self.lexer.sym != Lexer.ID) {
            return self.test();
        }
        var n = self.test();
        if (n.kind == Parser.VAR && self.lexer.sym == Lexer.EQUAL) {
            self.lexer.nextTok();
            n = Node(kind: Parser.SET, value: nil, op1: n, op2: self.expr(), op3: nil);
        }
        return n;
    }
    
    func parenExpr() -> Node {
        if (self.lexer.sym != Lexer.LPAR) {
            self.error(msg: "\"(\" expected:");
        }
        self.lexer.nextTok();
        let n = self.expr();
        if (self.lexer.sym != Lexer.RPAR) {
            self.error(msg: "\")\" expected:");
        }
        self.lexer.nextTok();
        return n;
    }
    
    func statement() -> Node {
        var n: Node;
        if (self.lexer.sym == Lexer.IF) {
            n = Node(kind: Parser.IF1, value: nil, op1: nil, op2: nil, op3: nil);
            self.lexer.nextTok();
            n.op1 = self.parenExpr();
            n.op2 = self.statement();
            if (self.lexer.sym == Lexer.ELSE) {
                n.kind = Parser.IF2;
                self.lexer.nextTok();
                n.op3 = self.statement();
            }
        } else if (self.lexer.sym == Lexer.WHILE) {
            n = Node(kind: Parser.WHILE, value: nil, op1: nil, op2: nil, op3: nil);
            self.lexer.nextTok();
            n.op1 = self.parenExpr();
            n.op2 = self.statement();
        } else if (self.lexer.sym == Lexer.DO) {
            n = Node(kind: Parser.DO, value: nil, op1: nil, op2: nil, op3: nil);
            self.lexer.nextTok();
            n.op1 = self.statement();
            if (self.lexer.sym != Lexer.WHILE) {
                self.error(msg: "\"while\" expected");
            }
            self.lexer.nextTok();
            n.op2 = self.parenExpr();
            if (self.lexer.sym != Lexer.SEMICOLON) {
                self.error(msg: "\";\" expected");
            }
        }  else if (self.lexer.sym == Lexer.SEMICOLON) {
            n = Node(kind: Parser.EMPTY, value: nil, op1: nil, op2: nil, op3: nil);
            self.lexer.nextTok();
        } else if (self.lexer.sym == Lexer.LBRA) {
            n = Node(kind: Parser.EMPTY, value: nil, op1: nil, op2: nil, op3: nil);
            self.lexer.nextTok();
            while (self.lexer.sym != Lexer.RBRA) {
                n = Node(kind: Parser.SEQ, value: nil, op1: n, op2: self.statement(), op3: nil);
            }
            self.lexer.nextTok();
        } else {
            n = Node(kind: Parser.EXPR, value: nil, op1: self.expr(), op2: nil, op3: nil);
            if (self.lexer.sym != Lexer.SEMICOLON) {
                self.error(msg: "\";\" expected");
            }
            self.lexer.nextTok();
        }
        return n;
    }
    
    func parse() -> Node {
        self.lexer.nextTok();
        let node = Node(kind: Parser.PROG, value: nil, op1: self.statement(), op2: nil, op3: nil);
        if (self.lexer.sym != Lexer.EOF) {
            self.error(msg: "Invalid statement syntax");
        }
        return node;
    }
    
}
