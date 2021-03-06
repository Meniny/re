//
//  Swiftify.swift
//  re
//
//  Created by 李二狗 on 2018/4/28.
//  Copyright © 2018年 Ce Zheng. All rights reserved.
//

import Foundation

public struct RegularExpression {
    public let pattern: String
    public let options: re.RegexObject.Flag
    
    public let regex: re.RegexObject
    
    public init(_ pt: String, options opts: re.RegexObject.Flag = []) {
        self.pattern = pt
        self.options = opts
        self.regex = re.compile(pt, flags: opts)
    }
}

public extension RegularExpression {
    static func of(_ pt: String, options opts: re.RegexObject.Flag = []) -> RegularExpression {
        return RegularExpression.init(pt, options: opts)
    }
}

public extension RegularExpression {
    func matches(in string: String) -> [String] {
        return self.regex.findall(string)
    }
    
    func firstMatch(in string: String) -> String? {
        return self.matches(in: string).first
    }
    
    func lastMatch(in string: String) -> String? {
        return self.matches(in: string).last
    }
}

public extension RegularExpression {
    func groups(matches string: String) -> [[String?]] {
        return self.regex.finditer(string).map({ $0.groups() })
    }
    
    func groups(matches string: String, at positions: [Int]) -> [[String?]] {
        return self.regex.finditer(string).map({ $0.group(positions) })
    }
    
    func groups(matches string: String, at position: Int) -> [String?] {
        return self.regex.finditer(string).map({ $0.group(position) })
    }
}

public extension RegularExpression {
    func split(_ string: String, count: Int = 0) -> [String?] {
        return self.regex.split(string, count)
    }
}

public extension RegularExpression {
    func replace(with replacement: String, in string: String, count: Int = 0) -> (string: String, times: Int) {
        return self.regex.subn(replacement, string, count)
    }
}

public extension RegularExpression {
    func ranges(in string: String) -> [Range<String.Index>?] {
        return self.regex.finditer(string).map({ $0.span() })
    }
    
    func firstRange(in string: String) -> Range<String.Index>? {
        return self.ranges(in: string).first ?? nil
    }
    
    func lastRange(in string: String) -> Range<String.Index>? {
        return self.ranges(in: string).last ?? nil
    }
}

