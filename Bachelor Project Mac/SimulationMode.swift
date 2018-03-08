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
    case development(diversityModel: DiversityModel, useDiversity: Bool, plotDiversity: Bool)
    
    // used until Oct 20th | still quite small, but has some usable output
    case phase1(diversityModel: DiversityModel, useDiversity: Bool, plotDiversity: Bool)
    
    // used until Nov 26th | first version for the final work, no influence on selection by diversity
    case phase2(diversityModel: DiversityModel, useDiversity: Bool, plotDiversity: Bool)
    
    // used until Dec 03rd | still no influence on selection by diversity, but hypermutation in every round
    case phase3(diversityModel: DiversityModel, useDiversity: Bool, plotDiversity: Bool)
    
    // used until Jan 28th | diversity now used in selection
    case phase4(diversityModel: DiversityModel, useDiversity: Bool, plotDiversity: Bool)
    
    // used until Mar 12th | Lambda in adapted fitness now with observation based value
    case phase5(diversityModel: DiversityModel, useDiversity: Bool, plotDiversity: Bool)
    
    // MARK: - ⚙️ Computed Properties
    
    // ⚠️ THE FOLLOWING PROPERTIES HAVE TO BE UPDATED FOR NEW MODES AS INDICATED BY XCODE!
    
    // Returns the String representation for the mode in use - used in Statistics output
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
    
    /// Returns the number of generations (= rounds of the genetic algorithm)
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
    
    /// Returns the amount of individuals in each generation
    var populationSize: Int {
        switch self {
        case .development: return 30
        case .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return 50
        }
    }
    
    /// Returns the width of each factory in fields (x-axis)
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
    
    /// Returns the length of each factory in fields (y-axis)
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
    
    /// Returns the number of fields from the side wall to the entrance and exit respectively
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
    
    /// Returns the amounts for each product type used in the simulation
    var productAmount: [ProductType : Int] {
        switch self {
        case .development:
            return ProductType.amountDictionary(a: 1, b: 0, c: 0, d: 0, e: 0, f: 0)
        case .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5:
            return ProductType.amountDictionary(a: 4, b: 5, c: 6, d: 7, e: 8, f: 9)
        }
    }
    
    /// Returns the amounts for each workstation type used in the simulation
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
    
    /// Returns the probability in percent for workstations (genes) to mutate in the Mutation phase
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
    
    /// Returns the radius inside of which a workstation (gene) can mutate in the Mutation phase
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
    
    /// Returns the probability in percent for a workstation (gene) of parent 1 gets chosen over one of parent 2 in the Crossover phase
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
    
    /// Returns the minimal average diversity below which Hypermutation will trigger (0.0 is equal to unused)
    var hypermutationThreshold: Double {
        switch self {
        case .phase1,
             .phase2: return 0.0 // = never
        case .development,
             .phase3,
             .phase4,
             .phase5: return Double.infinity // = always
        }
    }
    
    // Returns the number of times a robot can move away from his next target before being marked as blocked
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
    
    /// Returns the sequence of all phases used in the genetic algorithm
    var phases: [Modificator] {
        let phasesWithHypermutation: [Modificator] = [ParentSelection(), Crossover(), Mutation(), Hypermutation(), SurvivorSelection()]
        let phasesWithoutHypermutation: [Modificator] = [ParentSelection(), Crossover(), Mutation(), SurvivorSelection()]
        
        switch self {
        case .development(_, let useDiversity, _),
             .phase1(_, let useDiversity, _),
             .phase2(_, let useDiversity, _),
             .phase3(_, let useDiversity, _),
             .phase4(_, let useDiversity, _),
             .phase5(_, let useDiversity, _):
            return useDiversity ? phasesWithHypermutation : phasesWithoutHypermutation
        }
    }
    
    /// Returns the diversity model used in the Selection phase
    var diversityModel: DiversityModel {
        switch self {
        case .development(let diversityModel, _, _),
             .phase1(let diversityModel, _, _),
             .phase2(let diversityModel, _, _),
             .phase3(let diversityModel, _, _),
             .phase4(let diversityModel, _, _),
             .phase5(let diversityModel, _, _): return diversityModel
        }
    }
    
    /// Returns true if diversity influences the genetic algorithm
    var isDiversityEnabled: Bool {
        switch self {
        case .development(_, let useDiversity, _),
             .phase1(_, let useDiversity, _),
             .phase2(_, let useDiversity, _),
             .phase3(_, let useDiversity, _),
             .phase4(_, let useDiversity, _),
             .phase5(_, let useDiversity, _): return useDiversity
        }
    }
    
    /// Returns true parent selection is fitness-proportional (using "Roulette Mode")
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
    
    /// Returns true if duplicate individuals are eliminated in Survivor Selection Phase
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
    
    /// Returns true if a workstation should be deactivated after a given time
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
    
    /// Returns the IDs of all workstations that should be deactivated in a simulated breakdown (as indicated by simulatedWorkstationBreakdownActivated)
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
    
    /// Returns the timing of the workstation breakdown (as indicated by simulatedWorkstationBreakdownActivated)
    var workstationBreakdownTiming: Int {
        switch self {
        case .development,
             .phase1,
             .phase2,
             .phase3,
             .phase4,
             .phase5: return generations * 2 / 3
        }
    }
    
    /// Returns true if Statistics should show diversity measures
    var statisticsShouldPlotDiversity: Bool {
        switch self {
        case .development(_, _, let plotDiversity),
             .phase1(_, _, let plotDiversity),
             .phase2(_, _, let plotDiversity),
             .phase3(_, _, let plotDiversity),
             .phase4(_, _, let plotDiversity),
             .phase5(_, _, let plotDiversity): return plotDiversity
        }
    }
    
    // ⚠️ THE FOLLOWING PROPERTIES DO NOT NEED ANY UPDATE FOR NEW MODES (-> NO ERROR INDICATED BY XCODE!)
    
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
