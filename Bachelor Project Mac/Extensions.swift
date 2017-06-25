//
//  Extensions.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
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
    
    func shifted(by shiftAmount: Int) -> Array {
        guard self.count > 0, (shiftAmount % self.count) != 0 else { return self }
        let moduloShiftAmount = shiftAmount % self.count
        let effectiveShiftAmount = moduloShiftAmount < 0 ? moduloShiftAmount + self.count : moduloShiftAmount
        let shift: (Int) -> Int = { return $0 + effectiveShiftAmount >= self.count ? $0 + effectiveShiftAmount - self.count : $0 + effectiveShiftAmount }
        return self.enumerated().sorted(by: { shift($0.offset) < shift($1.offset) }).map { $0.element }
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
