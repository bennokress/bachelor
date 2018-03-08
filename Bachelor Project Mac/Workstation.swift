//
//  Workstation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Workstation: Identifiable {
    
    init(id: Int, type: WorkstationType, at position: Position) {
        self.id = id
        self.state = .idle
        self.type = type
        self.position = position
    }
    
    // MARK: - 🔧 Properties
    
    let id: Int
    let type: WorkstationType
    let position: Position
    var state: WorkstationState
    
    // MARK: - ⚙️ Computed Properties
    
    /// Returns true if the workstation is not assembling a product at the moment
    var isIdle: Bool {
        return state == .idle
    }
    
    // MARK: - 📕 Mutating Functions
    
    /// Sets the state of the workstation to busy with the given robot attached
    mutating func work(on robot: Robot) {
        self.state = .busy(robot: robot)
    }
    
    /// Sets the state of the workstation to idle
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
