//
//  Compiler.swift
//  TC-CWORK-Khramchenko-Sisetskiy
//
//  Created by Nikolay Khramchenko on 6/20/18.
//  Copyright © 2018 NX. All rights reserved.
//

import Foundation

let IFETCH = 0;
let ISTORE = 1;
let IPUSH = 2;
let IPOP = 3;
let IADD = 4;
let ISUB = 5;
let ILT = 6;
let JZ = 7;
let JNZ = 8;
let JMP = 9;
let HALT = 10;

class Compiler {
    var program: [Int] = [];
    var pc = 0;
    
    func gen(command: Int) {
        self.program.append(command);
        self.pc += 1;
    }
    
    func compile(node: Node) -> [Int] {
        if (node.kind == Parser.VAR) {
            self.gen(command: IFETCH);
            self.gen(command: node.value!);
        } else if (node.kind == Parser.CONST) {
            self.gen(command: IPUSH);
            self.gen(command: node.value!);
        } else if (node.kind == Parser.ADD) {
            _ = self.compile(node: node.op1!);
            _ = self.compile(node: node.op2!);
            self.gen(command: IADD);
        } else if (node.kind == Parser.SUB) {
            _ = self.compile(node: node.op1!);
            _ = self.compile(node: node.op2!);
            self.gen(command: ISUB);
        } else if (node.kind == Parser.LT) {
            _ = self.compile(node: node.op1!);
            _ = self.compile(node: node.op2!);
            self.gen(command: ILT);
        } else if (node.kind == Parser.SET) {
            _ = self.compile(node: node.op2!);
            self.gen(command: ISTORE);
            self.gen(command: node.op1!.value!);
        } else if (node.kind == Parser.IF1) {
            _ = self.compile(node: node.op1!);
            self.gen(command: JZ);
            let addr = self.pc;
            self.gen(command: 0);
            _ = self.compile(node: node.op2!);
            self.program[addr] = self.pc;
        } else if (node.kind == Parser.IF2) {
            _ = self.compile(node: node.op1!);
            self.gen(command: JZ);
            let addr1 = self.pc;
            self.gen(command: 0);
            _ = self.compile(node: node.op2!);
            self.gen(command: JMP);
            let addr2 = self.pc;
            self.gen(command: 0);
            self.program[addr1] = self.pc;
            _ = self.compile(node: node.op3!);
            self.program[addr2] = self.pc;
        } else if (node.kind == Parser.WHILE) {
            let addr1 = self.pc;
            _ = self.compile(node: node.op1!);
            self.gen(command: JZ);
            let addr2 = self.pc;
            self.gen(command: 0);
            _ = self.compile(node: node.op2!);
            self.gen(command: JMP);
            self.gen(command: addr1);
            self.program[addr2] = self.pc;
        } else if (node.kind == Parser.DO) {
            let addr = self.pc;
            _ = self.compile(node: node.op1!);
            _ = self.compile(node: node.op2!);
            self.gen(command: JNZ);
            self.gen(command: addr);
        } else if (node.kind == Parser.SEQ) {
            _ = self.compile(node: node.op1!);
            _ = self.compile(node: node.op2!);
        } else if (node.kind == Parser.EXPR) {
            _ = self.compile(node: node.op1!);
            self.gen(command: IPOP);
        } else if (node.kind == Parser.PROG) {
            _ = self.compile(node: node.op1!);
            self.gen(command: HALT);
        }
        return self.program;
    }
}
