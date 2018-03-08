//
//  WorkstationState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum WorkstationState {
    
    case busy(robot: Robot)     // when working on a docked robot
    case idle                   // when waiting for the next robot
    
}

// MARK: - 🔖 Identifiable Conformance
extension WorkstationState: Identifiable {
    
    var id: Int {
        switch self {
        case .busy: return 1
        case .idle: return 2
        }
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension WorkstationState: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .busy: return "busy"
        case .idle: return "idle"
        }
    }
    
}
