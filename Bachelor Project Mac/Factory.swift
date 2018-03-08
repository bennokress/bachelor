//
//  Factory.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Factory: Identifiable {
    
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
