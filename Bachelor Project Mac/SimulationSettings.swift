//
//  SimulationSettings.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct SimulationSettings {
    
    // MARK: General
    let debugLevel = DebugLevel.readable
    
    // MARK: Quantities
    let generationSize = 10
    let generations = 1
    
    // MARK: Factory Layout
    let factoryWidth = 10
    let factoryLength = 10
    let distanceFromEntranceAndExitToLayoutCorner = 3
    
    // MARK: Products
    let productAmount: [ProductType : Int] = [
        .pA: 2,
        .pB: 1,
        .pC: 1,
        .pD: 1,
        .pE: 1,
        .pF: 1
    ]
    
    // MARK: Workstations
    let workstationAmount: [WorkstationType : Int] = [
        .wsA: 1,
        .wsB: 2,
        .wsC: 1,
        .wsD: 1,
        .wsE: 1,
        .wsF: 1
    ]
    
    // MARK: Genetic Algorithm
    let simulationRounds = 2
    let modificators: [Modificator] = [Selection()]
    
}

// MARK: Computed Properties
extension SimulationSettings {
    
    var entrance: Position {
        let entranceFieldnumber = distanceFromEntranceAndExitToLayoutCorner - 1
        guard let entrancePosition = Position(fromFieldnumber: entranceFieldnumber, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength) else {
            fatalError("Entrance is outside of Factory Layout!")
        }
        return entrancePosition
    }
    
    var exit: Position {
        let exitFieldnumber = factoryWidth * factoryLength - distanceFromEntranceAndExitToLayoutCorner
        guard let exitPosition = Position(fromFieldnumber: exitFieldnumber, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength) else {
            fatalError("Exit is outside of Factory Layout!")
        }
        return exitPosition
    }
    
}

// MARK: Initial Generation Calculation
extension SimulationSettings {

    func getInitialGeneration() -> Set<Factory> {
        
        var initialGeneration: Set<Factory> = []
        
        var nextFactoryID: Int = 1
        generationSize.times {
            
            // 1 - create empty factory layout
            var factoryLayout = createEmptyFactoryGrid()
            
            // 2 - generate workstations at empty fields in factory layout
            var nextWorkstationID = 1
            for (workstationType, n) in workstationAmount {
                n.times {
                    let workstation = Workstation(id: nextWorkstationID, type: workstationType, at: Position.randomEmptyField(in: factoryLayout))
                    factoryLayout.addWorkstation(workstation)
                    nextWorkstationID += 1
                }
            }
            
            // 3 - generate robots for each product and place them at the entrance
            var nextRobotID = 1
            for (productType, n) in productAmount {
                n.times {
                    let product = Product(type: productType)
                    var robot = Robot(id: nextRobotID, product: product, in: factoryLayout)
                    factoryLayout.addRobot(&robot)
                    nextRobotID += 1
                }
            }
            
            // 4 - generate factory
            let factory = Factory(id: nextFactoryID, layout: factoryLayout, state: .running)
            nextFactoryID += 1
            
            
            // 5 - append factory to initial generation
            initialGeneration.insert(factory)
        }
        
        return initialGeneration
        
    }
    
}

// MARK: Simulation Steps
extension SimulationSettings {
    
    fileprivate func createEmptyFactoryGrid() -> FactoryLayout {
        let grid = FactoryLayout(width: factoryWidth, length: factoryLength)
        return grid
    }
    
}
