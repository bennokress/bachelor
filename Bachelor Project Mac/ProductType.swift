//
//  ProductType.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum ProductType {
    case pA
    case pB
    case pC
    case pD
    case pE
    case pF
    case testProduct // needed in unit tests only
    
    var route: [WorkstationType] {
        switch self {
        case .pA: return [.wsA, .wsB, .wsC, .wsD, .wsE, .wsF]
        case .pB: return [.wsA, .wsF, .wsB, .wsE, .wsC, .wsD]
        case .pC: return [.wsF, .wsE, .wsD, .wsC, .wsB, .wsA]
        case .pD: return [.wsA, .wsB, .wsA, .wsC, .wsA, .wsD]
        case .pE: return [.wsC, .wsD, .wsB, .wsE, .wsA, .wsF]
        case .pF: return [.wsC, .wsD, .wsC, .wsD, .wsC, .wsE]
        case .testProduct: return [.testWorkstation]
        }
    }
}
