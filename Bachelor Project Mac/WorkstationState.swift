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

extension WorkstationState: Identifiable {
    
    var id: Int {
        if case .busy = self { return 1 } else { return 2 }
    }
    
}

extension WorkstationState: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .busy: return "busy"
        case .idle: return "idle"
        }
    }
    
}

extension WorkstationState: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        switch self {
        case .busy(let robot): try singleContainer.encode("busy with robot (type \(robot.product.type.rawValue))")
        case .idle: try singleContainer.encode("idle")
        }
    }
    
}
