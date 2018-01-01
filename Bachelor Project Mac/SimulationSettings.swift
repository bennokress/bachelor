//
//  SimulationSettings.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

class SimulationSettings {
    
    private init() { }
    static var shared = SimulationSettings()
    
    //  var simulationMode: SimulationMode = .development(diversityModel: .genealogical, useDiversity: true)
    //  var simulationMode: SimulationMode = .phase1(diversityModel: .fitnessSharing, useDiversity: false, randomizeProducts: false)
    //  var simulationMode: SimulationMode = .phase2(diversityModel: .fitnessSharing, useDiversity: false, randomizeProducts: false)
    //  var simulationMode: SimulationMode = .phase3(diversityModel: .fitnessSharing, useDiversity: false, randomizeProducts: false)
    var simulationMode: SimulationMode = .phase4(diversityModel: .genealogical, useDiversity: true, randomizeProducts: false)
    
    // MARK: General
    let debugLevel = DebugLevel.off
    let actionInformationLevel = DebugLevel.off
    let jsonOutput = JSONDetails.off
    var nextFactoryID: Int = 1
    let dodgeThreshold = 100 // number of times a robot can move away from next target before being marked as blocked
    
    // MARK: Computed Properties
    var jsonOutputActive: Bool { return jsonOutput > JSONDetails.off }
    var workstationCount: Int { return workstationAmount.values.reduce(0, +) }
    
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
    
    // MARK: Last Round Checker for simulation statistics output
    func isLastSimulationRound(_ currentRound: Int) -> Bool { return currentRound == generations }
    
    // MARK: Settings depending on Simulation Mode
    var generationSize: Int { return simulationMode.generationSize }
    var generations: Int { return simulationMode.generations }
    var factoryWidth: Int { return simulationMode.factoryWidth }
    var factoryLength: Int { return simulationMode.factoryLength }
    var distanceFromEntranceAndExitToLayoutCorner: Int { return simulationMode.distanceFromEntranceAndExitToLayoutCorner }
    var productAmount: [ProductType : Int] { return simulationMode.productAmount }
    var workstationAmount: [WorkstationType : Int] { return simulationMode.workstationAmount }
    var mutationProbability: Int { return simulationMode.mutationProbability }
    var mutationDistance: Int { return simulationMode.mutationDistance }
    var hypermutationThreshold: Double { return simulationMode.hypermutationThreshold }
    var crossoverProbability: Int { return simulationMode.crossoverProbability }
    var phases: [Modificator] { return simulationMode.phases }
    var usedDistributionModel: DistributionModel { return simulationMode.distributionModel }
    var usedDiversityModel: DiversityModel { return simulationMode.diversityModel }
    var selectionUsesDiversity: Bool { return simulationMode.selectionUsesDiversity }
    var parentSelectionUsesRouletteMode: Bool { return simulationMode.parentSelectionUsesRouletteMode }
    var duplicateEliminationActivated: Bool { return simulationMode.duplicateEliminationActivated }
    var simulatedWorkstationBreakdownActivated: Bool { return simulationMode.simulatedWorkstationBreakdownActivated }
    var brokenWorkstationIDs: [Int] { return simulationMode.brokenWorkstationIDs }
    var workstationBreakdownTiming: Int { return simulationMode.workstationBreakdownTiming }
    
}

// MARK: Initial Generation Calculation
extension SimulationSettings {

    func getInitialGeneration() -> Generation {
        
        nextFactoryID = 1
        var initialFactories: Set<Factory> = []
        
        generationSize.times {
            let factory = generateRandomFactory()
            initialFactories.insert(factory)
        }
        
        return Generation(factories: initialFactories)
        
    }
    
    func generateRandomFactory(withBrokenWorkstation brokenWorkstationEnabled: Bool = false) -> Factory {
        
        // 1 - create empty factory layout
        var factoryLayout = getEmptyFactoryGrid
        
        // 2 - generate workstations at empty fields in factory layout
        var nextWorkstationID = 1
        for workstationType in workstationAmount.keys.sorted(by: { $0 < $1 }) {
            guard let amountOfCurrentWorkstationType = workstationAmount[workstationType] else {
                fatalError("No information found on amount for workstations of type \(workstationType.rawValue)")
            }
            amountOfCurrentWorkstationType.times {
                let workstation = Workstation(id: nextWorkstationID, type: workstationType, at: Position.randomEmptyField(in: factoryLayout))
                factoryLayout.addWorkstation(workstation)
                nextWorkstationID += 1
            }
        }
        
        // 3 - generate factory with robots at the entrance and a random genealogyDNA
        let factory = generateFactory(from: &factoryLayout, genealogyDNA: Bitstring(length: workstationCount))
        
        return brokenWorkstationEnabled ? getFactoryWithDeactivatedWorkstations(withIDs: brokenWorkstationIDs, from: factory) : factory
        
    }
    
}

// MARK: Simulation Steps
extension SimulationSettings {
    
    var getEmptyFactoryGrid: FactoryLayout {
        return FactoryLayout()
    }
    
    func generateFactory(from factoryLayout: inout FactoryLayout, genealogyDNA: Bitstring) -> Factory {
        
        // 1 - generate robots for each product and place them at the entrance
        var nextRobotID = 1
        for productType in productAmount.keys.sorted(by: { $0 < $1 }) {
            guard let amountOfCurrentProductType = productAmount[productType] else {
                fatalError("No information found on amount for product of type \(productType.rawValue)")
            }
            amountOfCurrentProductType.times {
                let product = Product(type: productType)
                var robot = Robot(id: nextRobotID, product: product, in: factoryLayout)
                factoryLayout.addRobot(&robot)
                nextRobotID += 1
            }
        }
        
        // 2 - generate factory
        let factory = Factory(id: nextFactoryID, layout: factoryLayout, genealogyDNA: genealogyDNA)
        nextFactoryID += 1
        
        return factory
        
    }
    
    func getFactoryWithDeactivatedWorkstations(withIDs brokenWorkstationIDs: [Int], from oldFactory: Factory) -> Factory {
        // 1 - Save important values from old Factory
        let oldFactoryID = oldFactory.id
        let oldFactoryDNA = oldFactory.genealogyDNA.removing(numberOfBits: brokenWorkstationIDs.count)
        let oldLayout = oldFactory.layout
        guard let entrance = oldLayout.entrancePosition, let exit = oldLayout.exitPosition else { fatalError("Could not find Entrance or Exit!") }
        
        // 2 - Get Empty Layout with equal dimensions, entrance and exit positions
        var newLayout = FactoryLayout(width: oldLayout.width, length: oldLayout.length, entrance: entrance, exit: exit)
        
        // 3 - Insert all but the deactivated workstations
        let healthyWorkstations = oldFactory.workstations.filter { !(brokenWorkstationIDs.contains($0.id)) }
        for workstation in healthyWorkstations {
            newLayout.addWorkstation(workstation)
        }
        
        // 4 - Get updated Robots for new Layout
        for robot in oldFactory.robots {
            var updatedRobot = Robot(id: robot.id, product: robot.product, in: newLayout)
            newLayout.addRobot(&updatedRobot)
        }
        
        // 5 - Generate Factory with updated Layout and Robots
        return Factory(id: oldFactoryID, layout: newLayout, genealogyDNA: oldFactoryDNA)
    }
    
}

// MARK: Statistics Path
extension SimulationSettings {
    func composeStatisticsURL(for endTime: Date) -> URL {
        // Unique File Name Parts
        let endDateString = "\(endTime.year)\(endTime.month > 9 ? "" : "0")\(endTime.month)\(endTime.day > 9 ? "" : "0")\(endTime.day)"
        let endTimeString = "\(endTime.hour > 9 ? "" : "0")\(endTime.hour)\(endTime.minute > 9 ? "" : "0")\(endTime.minute)"
        let simulationModeName = SimulationSettings.shared.simulationMode.name
        
        // URL Composition
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let path = "Library/Mobile Documents/com~apple~CloudDocs/iCloud Dropbox/Universität/Bachelorarbeit/Stats/rawStats/"
        let fileName = "\(simulationModeName)_\(endDateString)-\(endTimeString)"
        let fileExtension = ".csv"
        
        return homeDirectory.appendingPathComponent(path + fileName + fileExtension)
    }
}
