//
//  re.swift
//  re
//
//  Created by 李二狗 on 2018/4/28.
//  Copyright © 2016 Elias Abel. All rights reserved.
//

import Foundation

/// Counterpart of Python(2.x)'s `re` module, but as a class.
public struct re {
  // MARK: - re methods
  /**
  Compile a regular expression pattern into a RegexObject object, which can be used for matching using its match() and search() methods, described below.
  
  See https://docs.python.org/2/library/re.html#re.compile
  
  - parameter pattern: regular expression pattern string
  - parameter flags:   NSRegularExpressionOptions value
  
  - returns: The created RegexObject object. If the pattern is invalid, RegexObject.isValid is false, and all methods have a default return value.
  */
  public static func compile(_ pattern: String, flags: RegexObject.Flag = []) -> RegexObject  {
    return RegexObject(pattern: pattern, flags: flags)
  }
  
  /**
  Scan through string looking for the first location where the regular expression pattern produces a match, and return a corresponding MatchObject instance.
  
  See https://docs.python.org/2/library/re.html#re.search
  
  - parameter pattern: regular expression pattern string
  - parameter string:  string to be searched
  - parameter flags:   NSRegularExpressionOptions value
  
  - returns: Corresponding MatchObject instance. Return nil if no position in the string matches the pattern or pattern is invalid; note that this is different from finding a zero-length match at some point in the string.
  */
  public static func search(_ pattern: String, _ string: String, flags: RegexObject.Flag = []) -> MatchObject? {
    return re.compile(pattern, flags: flags).search(string)
  }
  
  /**
  If zero or more characters at the beginning of string match the regular expression pattern, return a corresponding MatchObject instance.
  
  See https://docs.python.org/2/library/re.html#re.match
  
  - parameter pattern: regular expression pattern string
  - parameter string:  string to be searched
  - parameter flags:   NSRegularExpressionOptions value
  
  - returns: Corresponding MatchObject instance. Return nil if the string does not match the pattern or pattern is invalid; note that this is different from a zero-length match.
  */
  public static func match(_ pattern: String, _ string: String, flags: RegexObject.Flag = []) -> MatchObject? {
    return re.compile(pattern, flags: flags).match(string)
  }
  
  /**
  Split string by the occurrences of pattern. If capturing parentheses are used in pattern, then the text of all groups in the pattern are also returned as part of the resulting list. If maxsplit is nonzero, at most maxsplit splits occur, and the remainder of the string is returned as the final element of the list.
  
  See https://docs.python.org/2/library/re.html#re.split
  
  - parameter pattern:  regular expression pattern string
  - parameter string:   string to be splitted
  - parameter maxsplit: maximum number of times to split the string, defaults to 0, meaning no limit is applied
  - parameter flags:    NSRegularExpressionOptions value
  
  - returns: Array of splitted strings
  */
  public static func split(_ pattern: String, _ string: String, _ maxsplit: Int = 0, flags: RegexObject.Flag = []) -> [String?] {
    return re.compile(pattern, flags: flags).split(string, maxsplit)
  }

  /**
  Return all non-overlapping matches of pattern in string, as a list of strings. The string is scanned left-to-right, and matches are returned in the order found. Empty matches are included in the result unless they touch the beginning of another match.
  
  See https://docs.python.org/2/library/re.html#re.findall
  
  - parameter pattern: regular expression pattern string
  - parameter string:  string to be searched
  - parameter flags:   NSRegularExpressionOptions value
  
  - returns: Array of matched substrings
  */
  public static func findall(_ pattern: String, _ string: String, flags: RegexObject.Flag = []) -> [String] {
    return re.compile(pattern, flags: flags).findall(string)
  }
  
  /**
  Return an array of MatchObject instances over all non-overlapping matches for the RE pattern in string. The string is scanned left-to-right, and matches are returned in the order found. Empty matches are included in the result unless they touch the beginning of another match.
  
  See https://docs.python.org/2/library/re.html#re.finditer
  
  - parameter pattern: regular expression pattern string
  - parameter string:  string to be searched
  - parameter flags:   NSRegularExpressionOptions value
  
  - returns: Array of match results as MatchObject instances
  */
  public static func finditer(_ pattern: String, _ string: String, flags: RegexObject.Flag = []) -> [MatchObject] {
    return re.compile(pattern, flags: flags).finditer(string)
  }
  
  /**
  Return the string obtained by replacing the leftmost non-overlapping occurrences of pattern in string by the replacement repl. If the pattern isn’t found, string is returned unchanged. Different from python, passing a repl as a closure is not supported.
  
  See https://docs.python.org/2/library/re.html#re.sub
  
  - parameter pattern: regular expression pattern string
  - parameter repl:    replacement string
  - parameter string:  string to be searched and replaced
  - parameter count:   maximum number of times to perform replace operations to the string
  - parameter flags:   NSRegularExpressionOptions value
  
  - returns: replaced string
  */
  public static func sub(_ pattern: String, _ repl: String, _ string: String, _ count: Int = 0, flags: RegexObject.Flag = []) -> String {
    return re.compile(pattern, flags: flags).sub(repl, string, count)
  }
  
  /**
  Perform the same operation as sub(), but return a tuple (new_string, number_of_subs_made) as (String, Int)
  
  See https://docs.python.org/2/library/re.html#re.subn
  
  - parameter pattern: regular expression pattern string
  - parameter repl:    replacement string
  - parameter string:  string to be searched and replaced
  - parameter count:   maximum number of times to perform replace operations to the string
  - parameter flags:   NSRegularExpressionOptions value
  
  - returns: a tuple (new_string, number_of_subs_made) as (String, Int)
  */
  public static func subn(_ pattern: String, _ repl: String, _ string: String, _ count: Int = 0, flags: RegexObject.Flag = []) -> (String, Int) {
    return re.compile(pattern, flags: flags).subn(repl, string, count)
  }
}
