//
//  RegexObject.swift
//  re
//
//  Created by 李二狗 on 2018/4/28.
//  Copyright © 2016 Elias Abel. All rights reserved.
//

import Foundation

public extension re {
    // MARK: - RegexObject
    /**
     *  Counterpart of Python's re.RegexObject
     */
    public class RegexObject {
        /// Typealias for NSRegularExpressionOptions
        public typealias Flag = NSRegularExpression.Options
        
        /// Whether this object is valid or not
        public var isValid: Bool {
            return regex != nil
        }
        
        /// Pattern used to construct this RegexObject
        public let pattern: String
        
        private let regex: NSRegularExpression?
        
        /// Underlying NSRegularExpression Object
        public var nsRegex: NSRegularExpression? {
            return regex
        }
        
        /// NSRegularExpressionOptions used to contructor this RegexObject
        public var flags: Flag {
            return regex?.options ?? []
        }
        
        /// Number of capturing groups
        public var groups: Int {
            return regex?.numberOfCaptureGroups ?? 0
        }
        
        /**
         Create A re.RegexObject Instance
         
         - parameter pattern: regular expression pattern string
         - parameter flags:   NSRegularExpressionOptions value
         
         - returns: The created RegexObject object. If the pattern is invalid, RegexObject.isValid is false, and all methods have a default return value.
         */
        public required init(pattern: String, flags: Flag = [])  {
            self.pattern = pattern
            do {
                self.regex = try NSRegularExpression(pattern: pattern, options: flags)
            } catch let error as NSError {
                self.regex = nil
                debugPrint(error)
            }
        }
        
        /**
         Scan through string looking for a location where this regular expression produces a match, and return a corresponding MatchObject instance. Return nil if no position in the string matches the pattern; note that this is different from finding a zero-length match at some point in the string.
         
         See https://docs.python.org/2/library/re.html#re.RegexObject.search
         
         - parameter string:  string to be searched
         - parameter pos:     position in string where the search is to start, defaults to 0
         - parameter endpos:  position in string where the search it to end (non-inclusive), defaults to nil, meaning the end of the string. If endpos is less than pos, no match will be found.
         - parameter options: NSMatchOptions value
         
         - returns: search result as MatchObject instance if a match is found, otherwise return nil
         */
        public func search(_ string: String, _ pos: Int = 0, _ endpos: Int? = nil, options: NSRegularExpression.MatchingOptions = []) -> MatchObject? {
            guard let regex = regex else {
                return nil
            }
            let start = pos > 0 ?pos :0
            let end = endpos ?? string.utf16.count
            let length = max(0, end - start)
            let range = NSRange(location: start, length: length)
            if let match = regex.firstMatch(in: string, options: options, range: range) {
                return MatchObject(string: string, match: match)
            }
            return nil
        }
        
        /**
         If zero or more characters at the beginning of string match this regular expression, return a corresponding MatchObject instance. Return nil if the string does not match the pattern; note that this is different from a zero-length match.
         
         See https://docs.python.org/2/library/re.html#re.RegexObject.match
         
         - parameter string:  string to be matched
         - parameter pos:     position in string where the search is to start, defaults to 0
         - parameter endpos:  position in string where the search it to end (non-inclusive), defaults to nil, meaning the end of the string. If endpos is less than pos, no match will be found.
         
         - returns: match result as MatchObject instance if a match is found, otherwise return nil
         */
        public func match(_ string: String, _ pos: Int = 0, _ endpos: Int? = nil) -> MatchObject? {
            return search(string, pos, endpos, options: [.anchored])
        }
        
        /**
         Identical to the re.split() function, using the compiled pattern.
         
         See https://docs.python.org/2/library/re.html#re.RegexObject.split
         
         - parameter string:   string to be splitted
         - parameter maxsplit: maximum number of times to split the string, defaults to 0, meaning no limit is applied
         
         - returns: Array of splitted strings
         */
        public func split(_ string: String, _ maxsplit: Int = 0) -> [String?] {
            guard let regex = regex else {
                return []
            }
            var splitsLeft = maxsplit == 0 ? Int.max : (maxsplit < 0 ? 0 : maxsplit)
            let range = NSRange(location: 0, length: string.utf16.count)
            var results = [String?]()
            var start = string.startIndex
            var end = string.startIndex
            regex.enumerateMatches(in: string, options: [], range: range) { result, _, stop in
                if splitsLeft <= 0 {
                    stop.pointee = true
                    return
                }
                
                guard let result = result, result.range.length > 0 else {
                    return
                }
                
                end = string.index(string.startIndex, offsetBy: result.range.location)
                results.append(String(string[start..<end]))
                if regex.numberOfCaptureGroups > 0 {
                    results += MatchObject(string: string, match: result).groups()
                }
                splitsLeft -= 1
                start = string.index(end, offsetBy: result.range.length)
            }
            if start <= string.endIndex {
                results.append(String(string[start..<string.endIndex]))
            }
            return results
        }
        
        /**
         Similar to the re.findall() function, using the compiled pattern, but also accepts optional pos and endpos parameters that limit the search region like for match().
         
         See https://docs.python.org/2/library/re.html#re.RegexObject.findall
         
         - parameter string:  string to be matched
         - parameter pos:     position in string where the search is to start, defaults to 0
         - parameter endpos:  position in string where the search it to end (non-inclusive), defaults to nil, meaning the end of the string. If endpos is less than pos, no match will be found.
         
         - returns: Array of matched substrings
         */
        public func findall(_ string: String, _ pos: Int = 0, _ endpos: Int? = nil) -> [String] {
            return finditer(string, pos, endpos).map { $0.group()! }
        }
        
        /**
         Similar to the re.finditer() function, using the compiled pattern, but also accepts optional pos and endpos parameters that limit the search region like for match().
         
         https://docs.python.org/2/library/re.html#re.RegexObject.finditer
         
         - parameter string:  string to be matched
         - parameter pos:     position in string where the search is to start, defaults to 0
         - parameter endpos:  position in string where the search it to end (non-inclusive), defaults to nil, meaning the end of the string. If endpos is less than pos, no match will be found.
         
         - returns: Array of match results as MatchObject instances
         */
        public func finditer(_ string: String, _ pos: Int = 0, _ endpos: Int? = nil) -> [MatchObject] {
            guard let regex = regex else {
                return []
            }
            let start = pos > 0 ?pos :0
            let end = endpos ?? string.utf16.count
            let length = max(0, end - start)
            let range = NSRange(location: start, length: length)
            return regex.matches(in: string, options: [], range: range).map { MatchObject(string: string, match: $0) }
        }
        
        /**
         Identical to the re.sub() function, using the compiled pattern.
         
         See https://docs.python.org/2/library/re.html#re.RegexObject.sub
         
         - parameter repl:    replacement string
         - parameter string:  string to be searched and replaced
         - parameter count:   maximum number of times to perform replace operations to the string
         
         - returns: replaced string
         */
        public func sub(_ repl: String, _ string: String, _ count: Int = 0) -> String {
            return subn(repl, string, count).0
        }
        
        /**
         Identical to the re.subn() function, using the compiled pattern.
         
         See https://docs.python.org/2/library/re.html#re.RegexObject.subn
         
         - parameter repl:    replacement string
         - parameter string:  string to be searched and replaced
         - parameter count:   maximum number of times to perform replace operations to the string
         
         - returns: a tuple (new_string, number_of_subs_made) as (String, Int)
         */
        public func subn(_ repl: String, _ string: String, _ count: Int = 0) -> (String, Int) {
            guard let regex = regex else {
                return (string, 0)
            }
            let range = NSRange(location: 0, length: string.utf16.count)
            let mutable = NSMutableString(string: string)
            let maxCount = count == 0 ? Int.max : (count > 0 ? count : 0)
            var n = 0
            var offset = 0
            regex.enumerateMatches(in: string, options: [], range: range) { result, _, stop in
                if maxCount <= n {
                    stop.pointee = true
                    return
                }
                if let result = result {
                    n += 1
                    let resultRange = NSRange(location: result.range.location + offset, length: result.range.length)
                    let lengthBeforeReplace = mutable.length
                    regex.replaceMatches(in: mutable, options: [], range: resultRange, withTemplate: repl)
                    offset += mutable.length - lengthBeforeReplace
                }
            }
            return (mutable as String, n)
        }
    }
}

