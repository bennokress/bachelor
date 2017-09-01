//
//  WorkstationType.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
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
}

extension WorkstationType: IdentifiableEnum {
    
    var id: Int { return hashValue }
    
}
