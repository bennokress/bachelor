//
//  Workstation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Workstation: Identifiable, CustomPrintable, Encodable {
    
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
    
    // MARK: Custom JSON Encoding
    var jsonDetails: JSONDetails { return SimulationSettings.shared.jsonOutput }
    
}

extension Workstation: CustomStringConvertible {
    
    var description: String {
        return "Workstation #\(id) (\(state)) of type \(type.rawValue) at \(position)"
    }
    
}

// MARK: Custom Encodable
extension Workstation {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case position
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(position, forKey: .position)
    }
    
}
