//
//  Factory.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Factory: Identifiable, CustomPrintable, Encodable {
    
    let id: Int
    let layout: FactoryLayout
    let layoutHash: String // used to recognize identical layouts (duplicate factories)
    let fitness: Int
    let distribution: Double
    
    init(id: Int, layout: FactoryLayout) {
        self.id = id
        self.layout = layout
        self.layoutHash = layout.hash
        
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
    
    /// Fitness measure with respect to the selected diversity measure: f'(x,P) = f(x) + lambda * d(x,P)
    func getAdaptedFitness(in generation: Generation) -> Double {
        let diversityModel = SimulationSettings.shared.usedDiversityModel
        let lambda = diversityModel.lambda
        let diversity = diversityModel.diversityScore(of: self, in: generation)
        return Double(fitness) + lambda * diversity
    }
    
    func hasIdenticalLayout(as otherFactory: Factory) -> Bool {
        return self.layoutHash == otherFactory.layoutHash
    }
    
}

extension Factory: CustomStringConvertible {
    
    var description: String {
        return "Factory #\(id) with fitness \(fitness) and distribution \(Int(distribution)):\n\n\(layout.description)\n\n"
    }
    
    func extensivePrint() {
        print(self)
        print("\(robots.count) Robots:")
        for robot in robots { print(robot) }
        print("\n\n")
        print("\(workstations.count) Workstations:")
        for workstation in workstations { print(workstation) }
        print("\n\n------------------------------------------------------------------------")
    }
    
}

extension Factory {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case fitness
        case distribution
        case layoutHash
        case layout = "workstations"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fitness, forKey: .fitness)
        try container.encode(layout.workstations.sorted(by: { $0.id < $1.id }), forKey: .layout)
    }
    
}
