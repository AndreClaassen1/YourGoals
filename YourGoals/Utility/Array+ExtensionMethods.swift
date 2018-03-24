//
//  Array+ExtensionMethods.swift
//  YourGoals
//
//  Created by André Claaßen on 24.03.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import Foundation

/// test if all elements in a sequence are unique
///
/// - Parameter source: the sequence with hashable elements
/// - Returns: true if all elements are unique an
public func areElementsUnique<S: Sequence, E: Hashable>(_ source: S) -> Bool where E==S.Iterator.Element {
    var seen: [E:Bool] = [:]
    
    return source.reduce(true, { u,e in   u && seen.updateValue(true, forKey: e) == nil })
}

extension Array {
    /// find an element in an array
    ///
    /// - Parameter includedElement: the element
    /// - Returns: index if the element was found otherwise nil
    public func find(_ includedElement: (Element) -> Bool) -> Int? {
        for (idx, element) in self.enumerated() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
    
    public func get(_ includedElement: (Element) -> Bool) -> Element! {
        for element in self {
            if includedElement(element) {
                return element
            }
        }
        
        assertionFailure("error in get() function. Element with predicate not found")
        return nil
    }
    
    
    /// the head element of the array
    ///
    /// - Returns: the head
    public func head() -> Element {
        return self[0]
    }
    
    /// the tail without the head
    ///
    /// - Returns: the tail of the arry
    public func tail() -> [Element] {
        return Array(self.dropFirst())
    }
    
    /// tests if any element matches a condition
    public func any(_ element: (Element) -> Bool) -> Bool{
        return find(element) != nil
    }
    
    /// tests if every element matches a condition
    /// if array is emtpy, test is also true
    public func every(_ test: (Element) -> Bool) -> Bool {
        for e in self {
            if !test(e) {
                return false
            }
        }
        
        return true
    }
    
    /// checks if every element in the array passes the expression
    ///
    /// - Parameter test: the test expression
    /// - Returns: true, if all elements are getting true
    /// - Throws: an exception
    public func every(_ test: (Element) throws -> Bool) throws -> Bool {
        for e in self {
            if try !test(e) {
                return false
            }
        }
        
        return true
    }
    
    // this function combines a reduced value with an index.
    public func reduceWithIndex<U>(_ initial: U, combine: ((U, Int), (Element, Int)) -> (U, Int)) -> Int {
        var reduced = (initial, 0)
        
        for i in 0 ..< self.count {
            reduced = combine(reduced, (self[i], i ))
        }
        
        return reduced.1
    }
    
    /// group an array by a given criteria
    ///
    /// see more at [https://medium.com/ios-os-x-development/little-snippet-group-by-in-swift-3-5be0a06307db]
    ///
    /// Example:
    ///
    ///
    ///
    ///        let numbers = [1, 2, 3, 4, 5, 6]
    ///
    ///        let groupedNumbers = numbers.grouped(by: { (number: Int) -> String in
    ///        if number % 2 == 1 {
    ///            return "odd"
    ///     } else {
    ///            return "even"
    ///        }
    ///
    /// - Parameter criteria: the group criteria
    /// - Returns: an grouped  dictionary
    func grouped<T>(by criteria: (Element) -> T) -> [T: [Element]] {
        var groups = [T: [Element]]()
        for element in self {
            let key = criteria(element)
            if groups.keys.contains(key) == false {
                groups[key] = [Element]()
            }
            groups[key]?.append(element)
        }
        return groups
    }
    
}
