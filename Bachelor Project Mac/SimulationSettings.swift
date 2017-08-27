//
//  SimulationSettings.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class SimulationSettings {
    
    private init() { }
    static var shared = SimulationSettings()
    
    // MARK: General
    let debugLevel = DebugLevel.off
    let actionInformationLevel = DebugLevel.extensive
    let isDevelopmentRun = true
    var nextFactoryID: Int = 1
    let dodgeThreshold = 100 // number of times a robot can move away from next target before being marked as blocked
    
    // MARK: Quantities
    var generationSize: Int { return isDevelopmentRun ? 16 : 50 }
    var generations: Int { return isDevelopmentRun ? 200 : 50 }
    func isLastSimulationRound(_ currentRound: Int) -> Bool { return currentRound == generations }
    
    // MARK: Factory Layout
    var factoryWidth: Int { return isDevelopmentRun ? 29 : 30 }
    var factoryLength: Int { return isDevelopmentRun ? 10 : 30 }
    var distanceFromEntranceAndExitToLayoutCorner: Int { return isDevelopmentRun ? 15 : 5 }
    
    // MARK: Products
    var productAmount: [ProductType : Int] { return [
        .pA: isDevelopmentRun ? 1 : 4,
        .pB: isDevelopmentRun ? 0 : 5,
        .pC: isDevelopmentRun ? 0 : 6,
        .pD: isDevelopmentRun ? 0 : 7,
        .pE: isDevelopmentRun ? 0 : 8,
        .pF: isDevelopmentRun ? 0 : 9
        ]
    }
    
    // MARK: Workstations
    var workstationAmount: [WorkstationType : Int] { return [
        .wsA: isDevelopmentRun ? 1 : 3,
        .wsB: isDevelopmentRun ? 1 : 4,
        .wsC: isDevelopmentRun ? 1 : 3,
        .wsD: isDevelopmentRun ? 1 : 3,
        .wsE: isDevelopmentRun ? 1 : 4,
        .wsF: isDevelopmentRun ? 1 : 3
        ]
    }
    
    // MARK: Genetic Algorithm
    let modificators: [Modificator] = [ParentSelection(), Mutation(), Hypermutation(), Crossover(), SurvivorSelection(duplicateElimination: true)]
//    let selectionMode: SelectionMode = .best(order: [.fitness, .distribution(target: .medium), .distribution(target: .low), .distribution(target: .high)])
    let selectionMode: SelectionMode = .fitness
    let usedDistributionModel: DistributionModel = .averageDistanceToCenter
    let usedDiversityModel: DiversityModel = .fitnessSharing
    let mutationProbability = 15 // Probability with which each workstation of a factory gets its position mutated
    let hypermutationThreshold = 1 // Max. Level of diversity that triggers hypermutation
    let crossoverProbability = 50 // Probability with which each workstation of a factory gets replaced by a corresponding one of the crossover partner factory
    var mutationDistance: Int { return isDevelopmentRun ? 5 : 6 } // Radius inside of which a workstation positions radius can mutate
    
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

    func getInitialGeneration() -> Generation {
        
        var initialFactories: Set<Factory> = []
        
        generationSize.times {
            let factory = generateRandomFactory()
            initialFactories.insert(factory)
        }
        
        return Generation(factories: initialFactories)
        
    }
    
    func generateRandomFactory() -> Factory {
        
        // 1 - create empty factory layout
        var factoryLayout = getEmptyFactoryGrid
        
        // 2 - generate workstations at empty fields in factory layout
        var nextWorkstationID = 1
        for (workstationType, n) in workstationAmount {
            n.times {
                let workstation = Workstation(id: nextWorkstationID, type: workstationType, at: Position.randomEmptyField(in: factoryLayout))
                factoryLayout.addWorkstation(workstation)
                nextWorkstationID += 1
            }
        }
        
        // 3 - generate factory with robots at the entrance
        let factory = generateFactory(from: &factoryLayout)
        
        return factory
        
    }
    
}

// MARK: Simulation Steps
extension SimulationSettings {
    
    var getEmptyFactoryGrid: FactoryLayout {
        return FactoryLayout()
    }
    
    func generateFactory(from factoryLayout: inout FactoryLayout) -> Factory {
        
        // 1 - generate robots for each product and place them at the entrance
        var nextRobotID = 1
        for (productType, n) in productAmount {
            n.times {
                let product = Product(type: productType)
                var robot = Robot(id: nextRobotID, product: product, in: factoryLayout)
                factoryLayout.addRobot(&robot)
                nextRobotID += 1
            }
        }
        
        // 2 - generate factory
        let factory = Factory(id: nextFactoryID, layout: factoryLayout)
        nextFactoryID += 1
        
        return factory
        
    }
    
}
