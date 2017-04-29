//
//  Workstation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum WorkstationState {
    case busy       // when working on a docked robot
    case idle       // when waiting for the next robot
}

struct Workstation {
    
    var state: WorkstationState
    let type: WorkstationType
    let position: Position
    
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
