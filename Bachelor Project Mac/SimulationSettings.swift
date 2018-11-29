//
//  SimulationSettings.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                           //
// There are two options when customizing the simulation:                                                                    //
//                                                                                                                           //
//     1. Creating a new mode in SimulationMode                                                                              //
//        --> Xcode will give you warnings until every parameter is configured                                               //
//     2. Using one of the present modes by setting simulationMode below                                                     //
//        --> diversity model can be one of: .genealogical, .genomeDistanceBased, .fitnessSharing, .none                     //
//        --> useDiversity indicates if diversity influences the genetic algorithm, it also enables / disables Hypermutation //
//        --> plotDiversity indicates if the Statistics output should include diversity measurements                         //
//                                                                                                                           //
// Please also set the statisticsOutputPath to get a csv-File with Statistics for each simulation!                           //
//                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import Foundation

class SimulationSettings {
    
    private init() { }
    
    // MARK: - 🔨 Static Properties
    
    static var shared = SimulationSettings()
    
    // MARK: - 🔧 Properties
    
    var simulationMode: SimulationMode = .production(diversityModel: .genealogical, useDiversity: true, plotDiversity: true)
    let statisticsOutputPath = "Library/Mobile Documents/com~apple~CloudDocs/iCloud Dropbox/Universität/Bachelorarbeit/Stats/testStatsFinalVersion/"
    var nextFactoryID = 1 // used and updated when building a new individual (factory) or restarting the simulation
    
    // MARK: - ⚙️ Computed Properties
    
    var brokenWorkstationIDs: [Int] { return simulationMode.brokenWorkstationIDs }
    var crossoverProbability: Int { return simulationMode.crossoverProbability }
    var distanceFromEntranceAndExitToLayoutCorner: Int { return simulationMode.distanceFromEntranceAndExitToLayoutCorner }
    var dodgeThreshold: Int { return simulationMode.dodgeThreshold }
    var duplicateEliminationActivated: Bool { return simulationMode.duplicateEliminationActivated }
    var entrance: Position { return simulationMode.entrancePosition }
    var exit: Position { return simulationMode.exitPosition }
    var factoryLength: Int { return simulationMode.factoryLength }
    var factoryWidth: Int { return simulationMode.factoryWidth }
    var generations: Int { return simulationMode.generations }
    var hypermutationThreshold: Double { return simulationMode.hypermutationThreshold }
    var isDiversityEnabled: Bool { return simulationMode.isDiversityEnabled }
    var mutationDistance: Int { return simulationMode.mutationDistance }
    var mutationProbability: Int { return simulationMode.mutationProbability }
    var parentSelectionUsesRouletteMode: Bool { return simulationMode.parentSelectionUsesRouletteMode }
    var phases: [GAPhase] { return simulationMode.phases }
    var populationSize: Int { return simulationMode.populationSize }
    var productAmount: [ProductType : Int] { return simulationMode.productAmount }
    var simulatedWorkstationBreakdownActivated: Bool { return simulationMode.simulatedWorkstationBreakdownActivated }
    var statisticsShouldPlotDiversity: Bool { return simulationMode.statisticsShouldPlotDiversity }
    var usedDiversityModel: DiversityModel { return simulationMode.diversityModel }
    var workstationAmount: [WorkstationType : Int] { return simulationMode.workstationAmount }
    var workstationBreakdownTiming: Int { return simulationMode.workstationBreakdownTiming }
    var workstationCount: Int { return simulationMode.workstationCount }
    
}
