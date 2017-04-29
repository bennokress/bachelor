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
        
        shortestRoute.append(exit)
        
        return shortestRoute
    }
    
}
