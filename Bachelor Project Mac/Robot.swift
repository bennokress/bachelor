//
//  Robot.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Robot: Identifiable {
    
    init(id: Int, product: Product, in factoryLayout: FactoryLayout) {
        guard let entrance = factoryLayout.entrancePosition else { fatalError("No entrance found in factory layout!") }
        
        self.id = id
        self.product = product
        self.state = .starting
        self.position = entrance
        self.remainingRoute = routing.getShortestRoute(containing: product.neededWorkstations, in: factoryLayout)
    }
    
    // MARK: - 🔧 Properties
    
    let id: Int
    let product: Product
    let routing = RobotRouting()
    
    var position: Position
    var remainingRoute: [Position]
    var state: RobotState
    
    var dodgeCounter = 0 // counts every step away from target
    
    // MARK: - ⚙️ Computed Properties
    
    var distanceToTarget: Int {
        if let target = remainingRoute.first {
            return position.distance(to: target)
        } else {
            return 0
        }
    }
    
    var isFinished: Bool { return state == .finished }
    var isBlocked: Bool { return state == .blocked }
    var isDocked: Bool { return state == .docked }
    
    // MARK: 🗝 Private Computed Properties
    
    private var settings: SimulationSettings {
        return SimulationSettings.shared
    }
    
    // MARK: - 📗 Functions
    // MARK: 🔒 Private Functions
    
    private func getClosestField(to targetPosition: Position, from fields: [Field]) -> Field? {
        return fields.sorted(by: { $0.position.distance(to: targetPosition) < $1.position.distance(to: targetPosition) }).first
    }
    
    // MARK: - 📕 Mutating Functions
    
    mutating func performStep(in factoryLayout: FactoryLayout) -> Robot {
        
        let potentialTargetFields = factoryLayout.potentialTargetFields(around: self.position)
        
        // 1a - finished and blocked robots don't do anything
        if self.isFinished || self.isBlocked {
            return self
        }
        
        // 1b - docked robots always change their state to moving and stay in position
        else if self.isDocked {
            self.state = .moving
            return self
        }
        
        // 1c - all others try to move first, if they have a field they can move to
        else if potentialTargetFields.count > 0 {
            
            // Get position of field for next move
            guard let nextTargetPosition = remainingRoute.first, let targetField = getClosestField(to: nextTargetPosition, from: potentialTargetFields)  else {
                    return self
            }
            
            // Check if moving away from target and set state to blocked, if threshold is reached
            if targetField.position.distance(to: nextTargetPosition) > distanceToTarget {
                dodgeCounter += 1
                if dodgeCounter >= settings.dodgeThreshold {
                    state = .blocked
                    return self
                }
            }
            
            // 2 - Move to the next field
            position = targetField.position
            setStateAndRemainingRoute(accordingToStateOf: targetField)
            
        }
            
        // 1d - otherwise they stay and adjust only the state they are in
        else {
            updateStateAfterNotBeingAbleToMove()
        }
        
        return self
    }
    
    // MARK: 🔒 Private Mutating Functions
    
    private mutating func updateStateAfterNotBeingAbleToMove() {
        switch state {
        // if still starting, then do nothing
        case .starting:
            break
        // if already idle, then increase idle rounds counter or switch to blocked state if counter already at 4
        case .idle(let idleRounds):
            state = idleRounds <= 3 ? .idle(since: idleRounds + 1) : .blocked
        // else change state to idle
        default:
            state = .idle(since: 1)
        }
    }
    
    private mutating func setStateAndRemainingRoute(accordingToStateOf targetField: Field) {
        switch targetField.state {
        // moving into a workstation
        case .workstation:
            if targetField.position == remainingRoute.first {
                remainingRoute.remove(at: 0)
                state = .docked
            } else {
                state = .moving
            }
        // moving into the exit
        case .exit:
            if targetField.position == remainingRoute.first {
                remainingRoute.remove(at: 0)
                state = .finished
            } else {
                state = .moving
            }
        // moving to an empty field or into the entrance
        default:
            state = .moving
        }
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Robot: CustomStringConvertible {
    
    var description: String {
        return "Robot #\(id) (\(state)) at \(position) with Product Type \(product.type.rawValue) - Remaining stations: \(remainingRoute.count)"
    }
    
}
