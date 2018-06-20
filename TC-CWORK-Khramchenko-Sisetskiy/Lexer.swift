//
//  Lexer.swift
//  TC-CWORK-Khramchenko-Sisetskiy
//
//  Created by Nikolay Khramchenko on 6/20/18.
//  Copyright © 2018 NX. All rights reserved.
//

import Foundation

class Lexer {
    static let NUM = 0;
    static let ID = 1;
    static let IF = 2;
    static let ELSE = 3;
    static let WHILE = 4;
    static let DO = 5;
    static let LBRA = 6;
    static let RBRA = 7;
    static let LPAR = 8;
    static let RPAR = 9;
    static let PLUS = 10;
    static let MINUS = 11;
    static let LESS = 12;
    static let EQUAL = 13;
    static let SEMICOLON = 14;
    static let EOF = 15;
    
    static let SYMBOLS: [String: Int] = [
        "{" : Lexer.LBRA,
        "}" : Lexer.RBRA,
        "=" : Lexer.EQUAL,
        ";" : Lexer.SEMICOLON,
        "(" : Lexer.LPAR,
        ")" : Lexer.RPAR,
        "+" : Lexer.PLUS,
        "-" : Lexer.MINUS,
        "<" : Lexer.LESS
    ];
    
    static let WORDS: [String: Int] = [
        "if" : Lexer.IF,
        "else" : Lexer.ELSE,
        "do" : Lexer.DO,
        "while" : Lexer.WHILE
    ];
    
    var ch: String = " ";
    
    init(code: String) {
        self.lastLine = code;
    }
    
    func error(msg: String) {
        print("Lexer error: \(msg)");
        exit(1);
    }
    
    var lastLine = "";
    func getc() {
        if (self.lastLine == "") {
            self.ch = "";
            return;
        }
        self.ch = "\(self.lastLine.removeFirst())";
        
    }
    
    var value: Int?;
    var sym: Int?;
    
    func nextTok() {
        self.value = nil;
        self.sym = nil;
        while self.sym == nil {
            if (self.ch.count == 0) {
                self.sym = Lexer.EOF;
            } else if (self.ch == " ") {
                self.getc();
            } else if (Lexer.SYMBOLS[self.ch] != nil) {
                self.sym = Lexer.SYMBOLS[self.ch];
                self.getc();
            } else if (self.isDigit(s: self.ch)) {
                var intVal = 0;
                while self.isDigit(s: self.ch) {
                    intVal = intVal * 10 + (Int(self.ch) ?? 0);
                    self.getc();
                }
                self.value = intVal;
                self.sym = Lexer.NUM;
            } else if (self.isAlpha(s: self.ch)) {
                var ident = "";
                while (self.isAlpha(s: self.ch)) {
                    ident += self.ch.lowercased();
                    self.getc();
                }
                if (Lexer.WORDS[ident] != nil) {
                    self.sym = Lexer.WORDS[ident]!;
                } else if (ident.count == 1) {
                    self.sym = Lexer.ID;
                    self.value = ident.first!.asciiValue - Character("a").asciiValue;
                } else {
                    self.error(msg: "Unknown identifier: \(ident)");
                }
            } else {
                self.error(msg: "Unexpected symbol: \(self.ch)");
            }
        }
    }
    
    private func isDigit(s: String) -> Bool {
        return CharacterSet.decimalDigits.contains(self.ch.unicodeScalars.first!);
    }
    
    private func isAlpha(s: String) -> Bool {
        return CharacterSet.letters.contains(self.ch.unicodeScalars.first!);
    }
}
