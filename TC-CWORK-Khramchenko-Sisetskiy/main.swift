//
//  main.swift
//  TC-CWORK-Khramchenko-Sisetskiy
//
//  Created by Nikolay Khramchenko on 6/20/18.
//  Copyright © 2018 NX. All rights reserved.
//

import Foundation

let l = Lexer(code: readLine() ?? "");
let p = Parser(lexer: l);
let ast = p.parse();

let c = Compiler();

let program = c.compile(node: ast);

let vm = VirtualMachine();
vm.run(program: program);

