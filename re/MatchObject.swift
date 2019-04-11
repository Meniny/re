//
//  MatchObject.swift
//  re
//
//  Created by 李二狗 on 2018/4/28.
//  Copyright © 2016 Elias Bbel. All rights reserved.
//

import Foundation

public extension re {
    // MARK: - MatchObject
    /**
     *  Counterpart of Python's re.MatchObject
     */
    final class MatchObject {
        /// String matched
        public let string: String
        
        /// Underlying NSTextCheckingResult
        public let match: NSTextCheckingResult
        
        init(string: String, match: NSTextCheckingResult) {
            self.string = string
            self.match = match
        }
        
        /**
         Return the string obtained by doing backslash substitution on the template string template, as done by the sub() method.
         
         Note that named backreferences in python is not supported here since NSRegularExpression does not have this feature.
         
         See https://docs.python.org/2/library/re.html#re.MatchObject.expand
         
         - parameter template: regular expression template decribing the expanded format
         
         - returns: expanded string
         */
        public func expand(_ template: String) -> String {
            guard let regex = match.regularExpression else {
                return ""
            }
            return regex.replacementString(for: match, in: string, offset: 0, template: template)
        }
        
        /**
         Returns one subgroup of the match. If the group number is negative or larger than the number of groups defined in the pattern, nil returned. If a group is contained in a part of the pattern that did not match, the corresponding result is nil. If a group is contained in a part of the pattern that matched multiple times, the last match is returned.
         
         Note that different from python's group function this function does not accept multiple arguments due to ambiguous syntax. If you would like to use multiple arguments pass in an array instead.
         
         See https://docs.python.org/2/library/re.html#re.MatchObject.group
         
         - parameter index: group index, defaults to 0, meaning the entire matching string
         
         - returns: string of the matching group
         */
        public func group(_ index: Int = 0) -> String? {
            guard let range = span(index), range.lowerBound < string.endIndex else {
                return nil
            }
            return String(string[range])
        }
        
        /**
         Returns one or more subgroups of the match. If a group number is negative or larger than the number of groups defined in the pattern, nil is inserted at the relevant index of the returned array. If a group is contained in a part of the pattern that did not match, the corresponding result is None. If a group is contained in a part of the pattern that matched multiple times, the last match is returned.
         
         See https://docs.python.org/2/library/re.html#re.MatchObject.group
         
         - parameter indexes: array of group indexes to get
         
         - returns: array of strings of the matching groups
         */
        public func group(_ indexes: [Int]) -> [String?] {
            return indexes.map { group($0) }
        }
        
        /**
         Return an array containing all the subgroups of the match, from 1 up to however many groups are in the pattern. The default argument is used for groups that did not participate in the match.
         
         Note that python version of this function returns a tuple while this one returns an array due to the fact that swift cannot specify a variadic tuple as return value.
         
         See https://docs.python.org/2/library/re.html#re.MatchObject.groups
         
         - parameter defaultValue: default value string
         
         - returns: array of all matching subgroups as String
         */
        public func groups(_ defaultValue: String) -> [String] {
            return (1..<match.numberOfRanges).map { group($0) ?? defaultValue }
        }
        
        /**
         Return an array containing all the subgroups of the match, from 1 up to however many groups are in the pattern. For groups that did not participate in the match, nil is inserted at the relevant index of the return array.
         
         Note that python version of this function returns a tuple while this one returns an array due to the fact that swift cannot specify a variadic tuple as return value.
         
         See https://docs.python.org/2/library/re.html#re.MatchObject.groups
         
         - returns: array of all matching subgroups as String? (nil when relevant optional capture group is not matched)
         */
        public func groups() -> [String?] {
            return (1..<match.numberOfRanges).map { group($0) }
        }
        
        /**
         Return the range of substring matched by group; group defaults to zero (meaning the whole matched substring). Return nil if paremeter is invalid or group exists but did not contribute to the match.
         
         See https://docs.python.org/2/library/re.html#re.MatchObject.span
         
         - parameter index: group index
         
         - returns: range of matching group substring
         */
        public func span(_ index: Int = 0) -> Range<String.Index>? {
            if index >= match.numberOfRanges {
                return nil
            }
            let nsrange = match.range(at: index)
            
            if nsrange.location == NSNotFound {
                return string.endIndex..<string.endIndex
            }
            let startIndex16 = string.utf16.index(string.startIndex, offsetBy: nsrange.location)
            let endIndex16 = string.utf16.index(startIndex16, offsetBy: nsrange.length)
            return (String.Index(startIndex16, within: string) ?? string.endIndex)..<(String.Index(endIndex16, within: string) ?? string.endIndex)
        }
    }
}

