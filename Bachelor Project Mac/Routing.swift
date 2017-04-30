//
//  Routing.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class Routing {
    
    static var shared = Routing()
    private init() {}
    
    func getShortestRoute(containing workstationTypes: [WorkstationType], in factoryLayout: FactoryLayout) -> [Position]? {
        guard let exit = factoryLayout.exitPosition else { return nil }
        
        var shortestRoute: [Position] = []
        
        // TODO: Implement
        
        // 1 - Set currentPosition to factoryLayout.entrancePosition
        // For workstation type in workstation types
            // 2 - filter factoryLayout.workstations for workstation type
            // 3 - from filtered workstations get the one with the shortest distance to the currentPosition
            // 4 - add the workstation position to shortestRoute
            // 5 - update currentPositiong to the workstation position
        
        shortestRoute.append(exit)
        
        return shortestRoute
    }
    
}
