//
//  Node.swift
//  TC-CWORK-Khramchenko-Sisetskiy
//
//  Created by Nikolay Khramchenko on 6/20/18.
//  Copyright © 2018 NX. All rights reserved.
//

import Foundation

class Node {
    var kind: Int?;
    var value: Int?;
    var op1: Node?;
    var op2: Node?;
    var op3: Node?;
    
    init(kind: Int?, value: Int?, op1: Node?, op2: Node?, op3: Node?) {
        self.kind = kind;
        self.value = value;
        self.op1 = op1;
        self.op2 = op2;
        self.op3 = op3;
    }
}
