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
    
    // used until Nov 26th | first version for the final work, no influence on selection by diversity
    case phase2(diversityModel: DiversityModel, useDiversity: Bool, randomizeProducts: Bool)
    
    // used until Dec 03rd | still no influence on selection by diversity, but hypermutation in every round
    case phase3(diversityModel: DiversityModel, useDiversity: Bool, randomizeProducts: Bool)
    
    // used until Jan 28th | diversity now used in selection
    case phase4(diversityModel: DiversityModel, useDiversity: Bool, randomizeProducts: Bool)
    
    // used until Mar 12th | Lambda in adapted fitness now with observation based value
    case phase5(diversityModel: DiversityModel, useDiversity: Bool, randomizeProducts: Bool)
    
    // MARK: - Manually entered settings per mode
    
    // Used in Statistics
    var name: String {
        switch self {
        case .development: return "Development"
        case .phase1: return "phase1"
        case .phase2: return "phase2"
        case .phase3: return "phase3"
        case .phase4: return "phase4"
        case .phase5: return "phase5"
        }
    }
    
    /// Number of generations (= rounds of the Genetic Algorithm)
    var generations: Int {
        switch self {
        case .development: return 200
        case .phase1: return 50
        case .phase2,
             .phase3,
             .phase4,
             .phase5: return 300
        }
    }
    
    /// The amount of individuals in each generation
    var generationSize: Int {
        switch self {
        case .development: return 30
        case .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return 50
        }
    }
    
    /// The width of each factory (x)
    var factoryWidth: Int {
        switch self {
        case .development: return 29
        case .phase1: return 30
        case .phase2,
             .phase3,
             .phase4,
             .phase5: return 40
        }
    }
    
    /// The length of each factory (y)
    var factoryLength: Int {
        switch self {
        case .development: return 10
        case .phase1: return 30
        case .phase2,
             .phase3,
             .phase4,
             .phase5: return 40
        }
    }
    
    /// The number of fields from the side wall to the entrance and exit respectively
    var distanceFromEntranceAndExitToLayoutCorner: Int {
        switch self {
        case .development: return 15
        case .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return 5
        }
    }
    
    /// Amounts for each product type used in the simulation
    var productAmount: [ProductType : Int] {
        switch self {
        case .development:
            return ProductType.amountDictionary(a: 1, b: 0, c: 0, d: 0, e: 0, f: 0)
        case .phase1(_, _, let randomize),
             .phase2(_, _, let randomize),
             .phase3(_, _, let randomize),
             .phase4(_, _, let randomize),
             .phase5(_, _, let randomize):
            return randomize ? ProductType.randomAmountDictionary(maxAmount: 10) : ProductType.amountDictionary(a: 4, b: 5, c: 6, d: 7, e: 8, f: 9)
        }
    }
    
    /// Amounts for each workstation type used in the simulation
    var workstationAmount: [WorkstationType : Int] {
        switch self {
        case .development: return WorkstationType.amountDictionary(a: 2, b: 1, c: 1, d: 1, e: 1, f: 1)
        case .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return WorkstationType.amountDictionary(a: 3, b: 4, c: 3, d: 3, e: 4, f: 3)
        }
    }
    
    /// The probability in percent with which each of an individuals workstations mutate in the Mutation phase
    var mutationProbability: Int {
        switch self {
        case .development: return 35
        case .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return 15
        }
    }
    
    /// The radius inside of which a workstation can get mutated in the Mutation phase
    var mutationDistance: Int {
        switch self {
        case .development: return 5
        case .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return 6
        }
    }
    
    /// The probability in percent with which a workstation of the first individual of a pair gets chosen in the Crossover phase
    var crossoverProbability: Int {
        switch self {
        case .development,
             .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return 50
        }
    }
    
    /// The minimal average diversity below which Hypermutation will trigger (1.0 is equal to unused)
    var hypermutationThreshold: Double {
        switch self {
        case .development,
             .phase1,
             .phase2: return 1.0 // = never
        case .phase3,
             .phase4,
             .phase5: return Double.infinity // = always
        }
    }
    
    // The number of times a robot can move away from his next target before being marked as blocked
    var dodgeThreshold: Int {
        switch self {
        case .development,
             .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return 100
        }
    }
    
    /// Sequence of all the phases of the Genetic Algorithm
    var phases: [Modificator] {
        switch self {
        case .development,
             .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return [ParentSelection(), Crossover(), Mutation(), Hypermutation(), SurvivorSelection()]
        }
    }
    
    /// The distribution model used for calculating how distributed the workstation are in each factory
    var distributionModel: DistributionModel {
        switch self {
        case .development,
             .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return .averageDistanceToCenter
        }
    }
    
    /// The diversity model used in the Selection phase
    var diversityModel: DiversityModel {
        switch self {
        case .development(let diversityModel, _),
             .phase1(let diversityModel, _, _),
             .phase2(let diversityModel, _, _),
             .phase3(let diversityModel, _, _),
             .phase4(let diversityModel, _, _),
             .phase5(let diversityModel, _, _): return diversityModel
        }
    }
    
    /// Indication if selection is based on fitness alone or fitness and diversity together
    var selectionUsesDiversity: Bool {
        switch self {
        case .development(_, let useDiversity),
             .phase1(_, let useDiversity, _),
             .phase2(_, let useDiversity, _),
             .phase3(_, let useDiversity, _),
             .phase4(_, let useDiversity, _),
             .phase5(_, let useDiversity, _): return useDiversity
        }
    }
    
    /// Indication if the Parent Selection Phase should give all individuals a weighed chance to become parents or if the should be selected by fitness
    var parentSelectionUsesRouletteMode: Bool {
        switch self {
        case .development,
             .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return true
        }
    }
    
    /// Indication if duplicate individuals should be eliminated in Survivor Selection Phase (only neccessary if diversity is not factored in to the selection process)
    var duplicateEliminationActivated: Bool {
        switch self {
        case .development: return false
        case .phase1: return true
        case .phase2,
             .phase3,
             .phase4,
             .phase5: return false
        }
    }
    
    /// Indication if a workstation should be deactivated after a while
    var simulatedWorkstationBreakdownActivated: Bool {
        switch self {
        case .development: return true
        case .phase1: return false
        case .phase2,
             .phase3,
             .phase4,
             .phase5: return true
        }
    }
    
    /// IDs of all the workstations that should be deactivated after a while (as indicated by simulatedWorkstationBreakdownActivated)
    var brokenWorkstationIDs: [Int] {
        switch self {
        case .development: return [1]
        case .phase1: return []
        case .phase2,
             .phase3,
             .phase4,
             .phase5: return [1]
        }
    }
    
    // Timing of the workstation breakdown (as indicated by simulatedWorkstationBreakdownActivated)
    var workstationBreakdownTiming: Int {
        switch self {
        case .development,
             .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return generations * 2 / 3 // at 2/3rd of the runtime
        }
    }
    
    // MARK: - Automatically determined variables from the values above
    
    var entrancePosition: Position {
        let entranceFieldnumber = distanceFromEntranceAndExitToLayoutCorner - 1
        guard let entrancePosition = Position(fromFieldnumber: entranceFieldnumber, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength) else {
            fatalError("Entrance is outside of Factory Layout!")
        }
        return entrancePosition
    }
    
    var exitPosition: Position {
        let exitFieldnumber = factoryWidth * factoryLength - distanceFromEntranceAndExitToLayoutCorner
        guard let exitPosition = Position(fromFieldnumber: exitFieldnumber, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength) else {
            fatalError("Exit is outside of Factory Layout!")
        }
        return exitPosition
    }
    
    var workstationCount: Int { return workstationAmount.values.reduce(0, +) }
    
}
