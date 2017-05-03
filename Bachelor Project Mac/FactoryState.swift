//
//  FactoryState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 03.05.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum FactoryState: String {
    case running
    case finished
}

extension FactoryState: Equatable {
    
    static func == (lhs: FactoryState, rhs: FactoryState) -> Bool {
        switch (lhs, rhs) {
        case (.running, .running), (.finished, .finished):
            return true
        default:
            return false
        }
    }
    
}
