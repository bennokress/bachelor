//
//  Extensions.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation
import SwifterSwift

extension Array {
    
    var randomElement: Element? {
        return self[safe: Int.random(between: startIndex, and: endIndex-1)]
    }
    
    var halfLength: Int {
        return self.count / 2
    }
    
    var firstHalf: [Element] {
        return self.count > 0 ? Array(self.prefix(halfLength)) : []
    }
    
    var middleHalf: [Element] {
        return firstHalf.lastHalf + lastHalf.firstHalf
    }
    
    var lastHalf: [Element] {
        return self.count > 0 ? Array(self.suffix(halfLength)) : []
    }
    
    func shifted(by shiftAmount: Int) -> Array {
        guard self.count > 0, (shiftAmount % self.count) != 0 else { return self }
        let moduloShiftAmount = shiftAmount % self.count
        let effectiveShiftAmount = moduloShiftAmount < 0 ? moduloShiftAmount + self.count : moduloShiftAmount
        let shift: (Int) -> Int = { return $0 + effectiveShiftAmount >= self.count ? $0 + effectiveShiftAmount - self.count : $0 + effectiveShiftAmount }
        return self.enumerated().sorted(by: { shift($0.offset) < shift($1.offset) }).map { $0.element }
    }
        
    mutating func filterDuplicates(matching: (_ lhs: Element, _ rhs: Element) -> Bool) {
        var results: [Element] = []
        
        self.forEach { (element) in
            let existingElements = results.filter { return matching(element, $0) }
            if existingElements.count == 0 { results.append(element) }
        }
        
        self = results
    }
    
}

extension Array where Element == Int {
    
    /// Returns the sum of all elements in the array
    var total: Int {
        return reduce(0, +)
    }
    
    /// Returns the maximum of all the elements in the array
    var max: Int? {
        return self.max()
    }
    
    /// Returns the minimum of all the elements in the array
    var min: Int? {
        return self.min()
    }
    
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(self.total) / Double(self.count)
    }
    
}

extension Bool {
    
    static func random(trueProbability: Int = 50) -> Bool {
        return Int.random(between: 1, and: 100) <= trueProbability ? true : false
    }
    
}

extension Collection {
    
    subscript(safe index: Index) -> Iterator.Element? {
        return self.contains(index: index) ? self[index] : nil
    }
    
    func contains(index: Index) -> Bool {
        return (self.startIndex ..< self.endIndex).contains(index)
    }
    
}

extension Encodable {
    
    func printToConsole() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            guard let json = String.init(data: data, encoding: .utf8) else { return }
            print(json)
        } catch { }
    }
    
}

extension Int {
    
    static func random(between min: Int, and max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    var twoDigitRepresentation: String {
        if self > 99 {
            return "++"
        } else if self > 9 {
            return "\(self)"
        } else if self > -1 {
            return "0\(self)"
        } else {
            return "--"
        }
    }
    
    var digits: Int {
        return self.abs < 10 ? 1 : 1 + (self / 10).digits
    }
    
    /// Returns 100 * percentValue divided by self rounded to the next Int
    func inverseAndExpand(by percentValue: Int) -> Int {
        let double = Double(self)
        let inverse = 1 / double
        return Int(100 * Double(percentValue) * inverse)
    }
    
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0 ..< self {
                f()
            }
        }
    }
    
    //    func times(f: @autoclosure () -> ()) {
    //        if self > 0 {
    //            for _ in 0 ..< self {
    //                f()
    //            }
    //        }
    //    }
    
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    var shuffled: [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension String {
    
    func withAddedDivider(_ divider: Character, totalLength: Int, padding: Int = 1) -> String {
        let contentLength = self.count + 2 * padding
        guard contentLength < totalLength else { return self }
        let dividerLength = totalLength - contentLength
        let oddLength = (totalLength - contentLength) % 2 > 0
        let halfDivider = String.init(repeating: divider, count: dividerLength / 2)
        let spacing = String.init(repeating: " ", count: padding)
        let oddLengthFix = oddLength ? "\(divider)" : ""
        return "\(halfDivider)\(spacing)\(self)\(spacing)\(halfDivider)\(oddLengthFix)"
    }
    
}
