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
    
}

extension Collection {
    
    subscript(safe index: Index) -> Iterator.Element? {
        return self.contains(index: index) ? self[index] : nil
    }
    
    func contains(index: Index) -> Bool {
        return (self.startIndex ..< self.endIndex).contains(index)
    }
    
}

//extension Collection where Iterator: Robot {
//    
//    var finished: Set<Robot> {
//        return Set(self)
//    }
//    
//}

extension Int {
    
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0 ..< self {
                f()
            }
        }
    }
    
    func times(f: @autoclosure () -> ()) {
        if self > 0 {
            for _ in 0 ..< self {
                f()
            }
        }
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
    
}
