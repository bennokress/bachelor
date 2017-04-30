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
    
    func getShortestRoute(containing workstationTypes: [WorkstationType], in factoryLayout: FactoryLayout) -> [Position] {
        guard let entrance = factoryLayout.entrancePosition, let exit = factoryLayout.exitPosition else { fatalError("Factory Layout has no entrance or exit!") }
        
        var shortestRoute: [Position] = []
        
        var currentPosition = entrance
        for desiredType in workstationTypes {
            var filteredWorkstations = factoryLayout.workstations.filter() { $0.type == desiredType }
            filteredWorkstations.sort(by: { $0.position.distance(to: currentPosition) < $1.position.distance(to: currentPosition) })
            guard let nearestWorkstation = filteredWorkstations.first else {
                fatalError("No workstation found with desired type!")
            }
            shortestRoute.append(nearestWorkstation.position)
            currentPosition = nearestWorkstation.position
        }
        
        shortestRoute.append(exit)
        
        return shortestRoute
    }
    
}
