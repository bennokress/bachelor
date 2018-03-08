//
//  Factory.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Factory: Identifiable {
    
    init(withBrokenWorkstation brokenWorkstationEnabled: Bool = false) {
        
        let settings = SimulationSettings.shared
        
        // 1 - create empty factory layout
        var factoryLayout = FactoryLayout.empty
        
        // 2 - generate workstations at empty fields in factory layout
        var nextWorkstationID = 1
        for workstationType in settings.workstationAmount.keys.sorted(by: { $0 < $1 }) {
            guard let amountOfCurrentWorkstationType = settings.workstationAmount[workstationType] else {
                fatalError("No information found on amount for workstations of type \(workstationType.rawValue)")
            }
            amountOfCurrentWorkstationType.times {
                let workstation = Workstation(id: nextWorkstationID, type: workstationType, at: Position.randomEmptyField(in: factoryLayout))
                factoryLayout.addWorkstation(workstation)
                nextWorkstationID += 1
            }
        }
        
        // 3 - generate factory with robots at the entrance and a random genealogyDNA
        let factory = Factory(from: &factoryLayout, genealogyDNA: Bitstring(length: settings.workstationCount))
        
        self = brokenWorkstationEnabled ? Factory(from: factory, with: settings.brokenWorkstationIDs) : factory
        
    }
    
    init(from factoryLayout: inout FactoryLayout, genealogyDNA: Bitstring) {
        
        let settings = SimulationSettings.shared
        
        // 1 - generate robots for each product and place them at the entrance
        var nextRobotID = 1
        for productType in settings.productAmount.keys.sorted(by: { $0 < $1 }) {
            guard let amountOfCurrentProductType = settings.productAmount[productType] else {
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
        let factory = Factory(id: settings.nextFactoryID, layout: factoryLayout, genealogyDNA: genealogyDNA)
        settings.nextFactoryID += 1
        
        self = factory
        
    }
    
    init(from oldFactory: Factory, with brokenWorkstationIDs: [Int]) {
        
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
        self = Factory(id: oldFactoryID, layout: newLayout, genealogyDNA: oldFactoryDNA)
        
    }
    
    var diversityModel: DiversityModel { return SimulationSettings.shared.usedDiversityModel }
    
    let id: Int
    let layout: FactoryLayout
    let layoutHash: String // used to recognize identical layouts (duplicate factories)
    let fitness: Int
    let distribution: Double
    
    let genealogyDNA: Bitstring
    
    init(id: Int, layout: FactoryLayout, genealogyDNA: Bitstring) {
        self.id = id
        self.layout = layout
        self.layoutHash = layout.hash
        self.genealogyDNA = genealogyDNA
        
        // Fitness Calculation
        let factoryCopy = RunnableFactory(layout: layout)
        self.fitness = factoryCopy.calculateFitness()
        
        // Distribution Calculation
        self.distribution = factoryCopy.calculateDistribution()
    }
    
    // MARK: Computed Properties
    
    var robots: Set<Robot> {
        var robots: Set<Robot> = []
        for field in layout.fields {
            if let fieldRobots = field.robots {
                robots.formUnion(fieldRobots)
            }
        }
        return robots
    }
    
    var workstations: Set<Workstation> {
        var workstations: Set<Workstation> = []
        for field in layout.fields {
            if let fieldWorkstation = field.workstation {
                workstations.insert(fieldWorkstation)
            }
        }
        return workstations
    }
    
    var sortedWorkstations: [Workstation] {
        return workstations.sorted { $0.id < $1.id }
    }
    
    // MARK: Functions
    
    /// Fitness measure with respect to the selected diversity measure: f'(x,P) = f(x) + λ * d(x,P)
    func getAdaptedFitness(in generation: Generation) -> Double {
        let λ = diversityModel.lambda
        let f_x = Double(fitness)
        let d_xP = diversityModel.diversityScore(of: self, in: generation) == nil ? 0.0 : (1 / diversityModel.diversityScore(of: self, in: generation)!)
        return f_x + λ * d_xP
    }
    
    func hasIdenticalLayout(as otherFactory: Factory) -> Bool {
        return self.layoutHash == otherFactory.layoutHash
    }
    
}

// MARK: - 🔖 Equatable Conformance
extension Factory: Equatable {
    
    static func == (lhs: Factory, rhs: Factory) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Factory: CustomStringConvertible {
    
    var description: String {
        return "Factory #\(id) with fitness \(fitness):\n\n\(layout.description)\n\n"
    }
    
}
