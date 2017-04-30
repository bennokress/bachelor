//
//  Field.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Field {
    
    let position: Position
    var state: FieldType
    
    var isEmpty: Bool { return state == .empty }
    var hasRemainingCapacity: Bool { return state.remainingCapacity > 0 }
    
    init(at position: Position, type: FieldType = .empty) {
        self.position = position
        self.state = type
    }
    
}

extension Field: Equatable {
    
    static func == (lhs: Field, rhs: Field) -> Bool {
        return (lhs.position == rhs.position) && (lhs.state == rhs.state)
    }
    
}
