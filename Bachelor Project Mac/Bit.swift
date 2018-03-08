//
//  Bit.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.09.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum Bit: Int, Equatable {
    
    case zero = 0
    case one = 1
    
    // MARK: - 🔨 Static Properties
    
    static var random: Bit {
        let rawValue = Int.random(between: 0, and: 1)
        return Bit(rawValue: rawValue)!
    }
    
    // MARK: - ⚙️ Computed Properties
    
    var flipped: Bit {
        return self == .zero ? .one : .zero
    }
    
    // MARK: - 📗 Functions
    
    func distance(to otherBit: Bit) -> Int {
        return self == otherBit ? 0 : 1
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Bit: CustomStringConvertible {
    
    var description: String {
        return "\(rawValue)"
    }
    
}
