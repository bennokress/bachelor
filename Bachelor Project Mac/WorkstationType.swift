//
//  WorkstationType.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum WorkstationType: String, Encodable {
    case wsA = "A"
    case wsB = "B"
    case wsC = "C"
    case wsD = "D"
    case wsE = "E"
    case wsF = "F"
    case testWorkstation = "T" // needed in unit tests only
    
    static func amountDictionary(a: Int, b: Int, c: Int, d: Int, e: Int, f: Int) -> [WorkstationType : Int] {
        return [.wsA: a, .wsB: b, .wsC: c, .wsD: d, .wsE: e, .wsF: f]
    }
    
}

// MARK: - 🔖 Identifiable Conformance
extension WorkstationType: Identifiable {
    
    var id: Int { return hashValue }
    
}

// MARK: - 🔖 Comparable Conformance
extension WorkstationType: Comparable {
    
    public static func < (a: WorkstationType, b: WorkstationType) -> Bool {
        return a.rawValue < b.rawValue
    }
    
}
