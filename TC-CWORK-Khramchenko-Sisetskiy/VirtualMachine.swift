//
//  VirtualMachine.swift
//  TC-CWORK-Khramchenko-Sisetskiy
//
//  Created by Nikolay Khramchenko on 6/21/18.
//  Copyright © 2018 NX. All rights reserved.
//

import Foundation

class VirtualMachine {
    
    func run(program: [Int]) {
        var v = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        var stack: [Int] = [];
        var pc: Int = 0;
        while (true) {
            var arg = 0;
            let op = program[pc];
            if (pc < program.count - 1) {
                arg = program[pc + 1];
            }
            if (op == IFETCH) {
                stack.append(v[arg]);
                pc += 2;
            } else if (op == ISTORE) {
                v[arg] = stack.popLast() ?? 0;
                pc += 2;
            } else if (op == IPUSH) {
                stack.append(arg);
                pc += 2;
            } else if (op == IPOP) {
                stack.append(arg);
                _ = stack.popLast();
                pc += 1;
            } else if (op == IADD) {
                stack[stack.count - 2] += stack[stack.count - 1];
                _ = stack.popLast();
                pc += 1;
            } else if (op == ISUB) {
                stack[stack.count - 2] -= stack[stack.count - 1];
                _ = stack.popLast();
                pc += 1;
            } else if (op == IFETCH) {
                stack.append(v[arg]);
                pc += 2;
            } else if (op == ILT) {
                if (stack[stack.count - 2] < stack[stack.count - 1]) {
                    stack[stack.count - 2] = 1;
                } else {
                    stack[stack.count - 2] = 0;
                }
                _ = stack.popLast();
                pc += 1;
            } else if (op == JZ) {
                if (stack.popLast() == 0) {
                    pc = arg;
                } else {
                    pc += 2;
                }
            } else if (op == JNZ) {
                if (stack.popLast() != 0) {
                    pc = arg;
                } else {
                    pc += 2;
                }
            } else if (op == JMP) {
                pc = arg;
            } else if (op == HALT) {
                break;
            }
        }
        print("Execution finished");
        for i in 0 ..< v.count {
            if (v[i] != 0) {
                guard let us = UnicodeScalar(Character("a").asciiValue + i) else {
                    continue;
                }
                let char = Character(us);
                print(String(format: "%@ = %d", String(char), v[i]));
            }
        }
    }
    
}
