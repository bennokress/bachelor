//
//  SimulationMode.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 21.10.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum SimulationMode {
    // used in development | small and very predictable - good for checking the results of code adjustments
    case development(diversityModel: DiversityModel, useDiversity: Bool)
    
    // used until Oct 20th | still quite small, but has some usable output
    case phase1(diversityModel: DiversityModel, useDiversity: Bool, randomizeProducts: Bool)
    
    // used until -------- | first version for the final work, no influence on selection by diversity
    case phase2(diversityModel: DiversityModel, useDiversity: Bool, randomizeProducts: Bool)
    
    // Used in Statistics
    var name: String {
        switch self {
        case .development: return "Development"
        case .phase1: return "phase1"
        case .phase2: return "phase2"
        }
    }
}

extension SimulationMode {
    
    /// Number of generations (= rounds of the Genetic Algorithm)
    var generations: Int {
        switch self {
        case .development: return 200
        case .phase1: return 50
        case .phase2: return 300
        }
    }
    
    /// The amount of individuals in each generation
    var generationSize: Int {
        switch self {
        case .development: return 30
        case .phase1: return 50
        case .phase2: return 50
        }
    }
    
    /// The width of each factory (x)
    var factoryWidth: Int {
        switch self {
        case .development: return 29
        case .phase1: return 30
        case .phase2: return 40
        }
    }
    
    /// The length of each factory (y)
    var factoryLength: Int {
        switch self {
        case .development: return 10
        case .phase1: return 30
        case .phase2: return 40
        }
    }
    
    /// The number of fields from the side wall to the entrance and exit respectively
    var distanceFromEntranceAndExitToLayoutCorner: Int {
        switch self {
        case .development: return 15
        default: return 5
        }
    }
    
    /// Amounts for each product type used in the simulation
    var productAmount: [ProductType : Int] {
        switch self {
        case .development:
            return ProductType.amountDictionary(a: 1, b: 0, c: 0, d: 0, e: 0, f: 0)
        case .phase1(_, _, let randomize),
             .phase2(_, _, let randomize):
            return randomize ? ProductType.randomAmountDictionary(maxAmount: 10) : ProductType.amountDictionary(a: 4, b: 5, c: 6, d: 7, e: 8, f: 9)
        }
    }
    
    /// Amounts for each workstation type used in the simulation
    var workstationAmount: [WorkstationType : Int] {
        switch self {
        case .development: return WorkstationType.amountDictionary(a: 2, b: 1, c: 1, d: 1, e: 1, f: 1)
        default: return WorkstationType.amountDictionary(a: 3, b: 4, c: 3, d: 3, e: 4, f: 3)
        }
    }
    
    /// The probability in percent with which each of an individuals workstations mutate in the Mutation phase
    var mutationProbability: Int {
        switch self {
        case .development: return 35
        case .phase1: return 15
        case .phase2: return 15
        }
    }
    
    /// The radius inside of which a workstation can get mutated in the Mutation phase
    var mutationDistance: Int {
        switch self {
        case .development: return 5
        case .phase1: return 6
        case .phase2: return 6
        }
    }
    
    /// The probability in percent with which a workstation of the first individual of a pair gets chosen in the Crossover phase
    var crossoverProbability: Int {
        switch self {
        default: return 50
        }
    }
    
    /// The minimal average diversity below which Hypermutation will trigger (1.0 is equal to unused)
    var hypermutationThreshold: Double {
        switch self {
        case .development: return 1.0
        case .phase1: return 1.0
        case .phase2: return 1.0
            // TODO: [TUNING] Find a good value!
        }
    }
    
    /// Sequence of all the phases of the Genetic Algorithm
    var phases: [Modificator] {
        switch self {
        default: return [ParentSelection(), Crossover(), Mutation(), Hypermutation(), SurvivorSelection()]
        }
    }
    
    /// The distribution model used for calculating how distributed the workstation are in each factory
    var distributionModel: DistributionModel {
        switch self {
        default: return .averageDistanceToCenter
        }
    }
    
    /// The diversity model used in the Selection phase
    var diversityModel: DiversityModel {
        switch self {
        case .development(let diversityModel, _),
             .phase1(let diversityModel, _, _),
             .phase2(let diversityModel, _, _):
            return diversityModel
        }
    }
    
    /// Indication if selection is based on fitness alone or fitness and diversity together
    var selectionUsesDiversity: Bool {
        switch self {
        case .development(_, let useDiversity),
             .phase1(_, let useDiversity, _),
             .phase2(_, let useDiversity, _):
            return useDiversity
        }
    }
    
    /// Indication if the Parent Selection Phase should give all individuals a weighed chance to become parents or if the should be selected by fitness
    var parentSelectionUsesRouletteMode: Bool {
        switch self {
        case .development: return true
        case .phase1: return true
        case .phase2: return true
        }
    }
    
    /// Indication if duplicate individuals should be eliminated in Survivor Selection Phase (only neccessary if diversity is not factored in to the selection process)
    var duplicateEliminationActivated: Bool {
        switch self {
        case .development: return true
        case .phase1: return true
        case .phase2: return false
        }
    }
    
    /// Indication if a workstation should be deactivated after a while
    var simulatedWorkstationBreakdownActivated: Bool {
        switch self {
        case .development: return true
        case .phase1: return false
        case .phase2: return true
        }
    }
    
    /// IDs of all the workstations that should be deactivated after a while (as indicated by simulatedWorkstationBreakdownActivated)
    var brokenWorkstationIDs: [Int] {
        switch self {
        case .development: return [1]
        case .phase1: return []
        case .phase2: return [1]
        }
    }
    
    // Timing of the workstation breakdown (as indicated by simulatedWorkstationBreakdownActivated)
    var workstationBreakdownTiming: Int {
        switch self {
        default: return generations * 2 / 3 // at 2/3rd of the runtime
        }
    }
    
}
