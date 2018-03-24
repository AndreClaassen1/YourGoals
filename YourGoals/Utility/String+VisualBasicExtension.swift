//
//  String+VisualBasicExtension.swift
//  YourGoals
//
//  Created by André Claaßen on 24.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

// MARK: - sum nice old extensions from Visual Basic
public extension String {
    
    /// strings matches to a regular expression
    ///
    /// - Parameter expression: the regular expression
    /// - Returns: true or false
    public func containsExpression(_ expression: String) -> Bool  {
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options(rawValue: 0))
        let numberOfMatches = regex.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, self.count))
        return numberOfMatches > 0
    }
    
    /// eliminate all white spaces before and after the string
    ///
    /// - Returns: a trimmed string
    public func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// get the last n chars of the string
    ///
    /// - Parameter numChars: number of chars
    /// - Returns: a right string
    public func right$(_ numChars:Int) -> String {
        guard numChars < self.count else {
            return self
        }
        
        let index = self.index(self.endIndex, offsetBy: -numChars)
        return String(self[index...])
    }
    
    /// obtain the first n chars of astring
    ///
    /// - Parameter numChars: number of chars
    /// - Returns: the first n chars
    public func left$(_ numChars:Int) -> String {
        guard numChars < self.count else {
            return self
        }
        
        let index = self.index(self.startIndex, offsetBy: numChars)
        return String(self[startIndex..<index])
    }
}


