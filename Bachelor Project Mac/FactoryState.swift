//
//  FactoryState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 03.05.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum FactoryState: String {
    
    case running
    case finished
    
}

// MARK: - 🔖 Identifiable Conformance
extension FactoryState: Identifiable {
    
    var id: Int {
        switch self {
        case .running: return 1
        case .finished: return 2
        }
    }
    
}
