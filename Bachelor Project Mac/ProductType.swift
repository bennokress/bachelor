//
//  ProductType.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum ProductType: String {
    
    case pA = "A"
    case pB = "B"
    case pC = "C"
    case pD = "D"
    case pE = "E"
    case pF = "F"
    case testProduct = "T"   // needed in unit tests only
    case emptyProduct = ""   // needed in unit tests only
    
    // MARK: - ⚙️ Computed Properties
    
    /// The order of workstation types needed to produce the product
    var route: [WorkstationType] {
        switch self {
        case .pA: return [.wsA, .wsB, .wsC, .wsD, .wsE, .wsF]
        case .pB: return [.wsA, .wsF, .wsB, .wsE, .wsC, .wsD]
        case .pC: return [.wsF, .wsE, .wsD, .wsC, .wsB, .wsA]
        case .pD: return [.wsA, .wsB, .wsA, .wsC, .wsA, .wsD]
        case .pE: return [.wsC, .wsD, .wsB, .wsE, .wsA, .wsF]
        case .pF: return [.wsC, .wsD, .wsC, .wsD, .wsC, .wsE]
        case .testProduct: return [.testWorkstation]
        case .emptyProduct: return []
        }
    }
    
    // MARK: - 📘 Static Functions
    
    /// Returns a dictionary containing the randomly generated production amount per product type
    static func randomAmountDictionary(maxAmount: Int = 10) -> [ProductType : Int] {
        let a = Int.random(between: 1, and: maxAmount)
        let b = Int.random(between: 1, and: maxAmount)
        let c = Int.random(between: 1, and: maxAmount)
        let d = Int.random(between: 1, and: maxAmount)
        let e = Int.random(between: 1, and: maxAmount)
        let f = Int.random(between: 1, and: maxAmount)
        return amountDictionary(a: a, b: b, c: c, d: d, e: e, f: f)
    }
    
    /// Returns a dictionary containing the provided production amount per product type
    static func amountDictionary(a: Int, b: Int, c: Int, d: Int, e: Int, f: Int) -> [ProductType : Int] {
        return [.pA: a, .pB: b, .pC: c, .pD: d, .pE: e, .pF: f]
    }
    
}

// MARK: - 🔖 Identifiable Conformance
extension ProductType: Identifiable {
    
    var id: Int {
        switch self {
        case .emptyProduct: return 0
        case .pA: return 1
        case .pB: return 2
        case .pC: return 3
        case .pD: return 4
        case .pE: return 5
        case .pF: return 6
        case .testProduct: return Int.max
        }
    }
    
}

// MARK: - 🔖 Comparable Conformance
extension ProductType: Comparable {
    
    public static func < (a: ProductType, b: ProductType) -> Bool {
        return a.rawValue < b.rawValue
    }
    
}
