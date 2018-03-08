//
//  Workstation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Workstation: Identifiable {
    
    let id: Int
    var state: WorkstationState
    let type: WorkstationType
    let position: Position
    
    var isIdle: Bool { return state == .idle }
    
    init(id: Int, type: WorkstationType, at position: Position) {
        self.id = id
        self.state = .idle
        self.type = type
        self.position = position
    }
    
    mutating func work(on robot: Robot) {
        self.state = .busy(robot: robot)
    }
    
    mutating func finishWorking() {
        self.state = .idle
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Workstation: CustomStringConvertible {
    
    var description: String {
        return "Workstation #\(id) (\(state)) of type \(type.rawValue) at \(position)"
    }
    
}
