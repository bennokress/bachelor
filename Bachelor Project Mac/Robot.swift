//
//  Robot.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Robot: Identifiable, CustomPrintable {
    
    let id: Int
    let product: Product
    var position: Position
    var remainingRoute: [Position]
    var state: RobotState
    
    var dodgeCounter = 0 // counts every step away from target
    var distanceToTarget: Int {
        if let target = remainingRoute.first {
            return position.distance(to: target)
        } else {
            return 0
        }
    }
    
    let routing = Routing()
    
    init(id: Int, product: Product, in factoryLayout: FactoryLayout) {
        guard let entrance = factoryLayout.entrancePosition else { fatalError("No entrance found in factory layout!") }
        
        self.id = id
        self.product = product
        self.state = .starting
        self.position = entrance
        self.remainingRoute = routing.getShortestRoute(containing: product.neededWorkstations, in: factoryLayout)
    }
    
    mutating func performStep(in factoryLayout: FactoryLayout) -> Robot {
        let potentialTargetFields = factoryLayout.potentialTargetFields(around: self.position)
        
//        print("Robot \(self.id) is \(self.state.description) at position \(self.position.x)/\(self.position.y). \(remainingRoute.count) remaining target positions:")
//        for target in self.remainingRoute { print("    \(target.x)/\(target.y)") }
//        print("Moves are possible to:")
//        if potentialTargetFields.count > 0 { for field in potentialTargetFields { print("    \(field.position.x)/\(field.position.y)") } }
//        print("---------------------------------------------------------------------")
        
        // finished and blocked robots don't do anything
        if case .finished = state, case .blocked = state {
            return self
        }
        
        // docked robots always change their state to moving and stay in position
        else if case .docked = state {
            self.state = .moving
            return self
        }
        
        // all others try to move first, if they have a field they can move to
        else if potentialTargetFields.count > 0 {
            guard let nextTargetPosition = remainingRoute.first,
                let targetField = potentialTargetFields.sorted(by: { $0.position.distance(to: nextTargetPosition) < $1.position.distance(to: nextTargetPosition) }).first  else {
                    return self
            }
            
            // Check if moving away from target and set state to blocked, if threshold is reached
            if targetField.position.distance(to: nextTargetPosition) > distanceToTarget {
                dodgeCounter += 1
                if dodgeCounter >= SimulationSettings.shared.dodgeThreshold {
                    state = .blocked
                    return self
                }
            }
            
            position = targetField.position
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
            
        // ... otherwise they stay and adjust only the state they are in
        else {
            // moving not possible
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
        
        return self
    }
    
}

extension Robot: CustomStringConvertible {
    
    var description: String {
        return "Robot #\(id) (\(state)) at \(position) with Product Type \(product.type.rawValue) - Remaining stations: \(remainingRoute.count)"
    }
    
}
