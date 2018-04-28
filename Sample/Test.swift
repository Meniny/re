//
//  Test.swift
//  Sample
//
//  Created by 李二狗 on 2018/4/28.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import Foundation
import re

public func test() {
    let string = """
public struct SomeStruct {
    let objc: NSObject = NSObject()
    let valueOne: NSString = "hello"
    let someNumber: Int = 2
    let contains0: Bool = true
    
    public init() {
    
    }
}
"""
    let pattern = "let\\s([a-z][A-Za-z\\d_]*):\\s([A-Z][A-Za-z\\d]+)\\s=\\s(.+)"
    
    let regex = RegularExpression.of(pattern)
    
    let matches = regex.matches(in: string)
    let groups1 = regex.groups(matches: string)
    let groups2 = regex.groups(matches: string, at: 1)
    let groups3 = regex.groups(matches: string, at: [1, 2])
    let split = regex.split(string)
    let replace = regex.replace(with: "BEING_REPLACED", in: string)
    
    print(string, regex.pattern, matches, groups1, groups2, groups3, split, replace.string, replace.times, separator: "\n\n", terminator: "\n")
}
