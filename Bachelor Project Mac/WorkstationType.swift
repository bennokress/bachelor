//
//  WorkstationType.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum WorkstationType: String {
    
    case wsA = "A"
    case wsB = "B"
    case wsC = "C"
    case wsD = "D"
    case wsE = "E"
    case wsF = "F"
    case testWorkstation = "T" // needed in unit tests only
    
    // MARK: - 📘 Static Functions
    
    /// Returns a dictionary containing the provided workstation amount per workstation type
    static func amountDictionary(a: Int, b: Int, c: Int, d: Int, e: Int, f: Int) -> [WorkstationType : Int] {
        return [.wsA: a, .wsB: b, .wsC: c, .wsD: d, .wsE: e, .wsF: f]
    }
    
}

// MARK: - 🔖 Identifiable Conformance
extension WorkstationType: Identifiable {
    
    var id: Int {
        switch self {
        case .wsA: return 1
        case .wsB: return 2
        case .wsC: return 3
        case .wsD: return 4
        case .wsE: return 5
        case .wsF: return 6
        case .testWorkstation: return Int.max
        }
    }
    
}

// MARK: - 🔖 Comparable Conformance
extension WorkstationType: Comparable {
    
    public static func < (a: WorkstationType, b: WorkstationType) -> Bool {
        return a.rawValue < b.rawValue
    }
    
}
