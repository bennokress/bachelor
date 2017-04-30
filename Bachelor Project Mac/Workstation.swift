//
//  Workstation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Workstation {
    
    var state: WorkstationState
    let type: WorkstationType
    let position: Position
    
    var isIdle: Bool { return state == .idle }
    
    init(type: WorkstationType, at position: Position) {
        self.state = .idle
        self.type = type
        self.position = position
    }
    
}

extension Workstation: Equatable {
    
    static func == (lhs: Workstation, rhs: Workstation) -> Bool {
        return (lhs.position == rhs.position) && (lhs.type == rhs.type)
    }
    
}
