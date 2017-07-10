//
//  Factory.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Factory: Identifiable, CustomPrintable {
    
    let id: Int
    let layout: FactoryLayout
    let fitness: Int
    
    init(id: Int, layout: FactoryLayout) {
        self.id = id
        self.layout = layout
        
        // Fitness Calculation
        let factoryCopy = RunnableFactory(layout: layout)
        self.fitness = factoryCopy.calculateFitness()
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
    
}

// MARK: Simulation
extension Factory {
    
//    var allRobotsFinished: Bool {
//        let unfinishedRobots = robots.filter { ($0.state != .finished) }
//        return unfinishedRobots.count == 0
//    }
//
//    var atLeastOneRobotBlocked: Bool {
//        let blockedRobots = robots.filter { ($0.state == .blocked) }
//        return blockedRobots.count > 0
//    }
    
    func hasEqualLayout(as otherFactory: Factory) -> Bool {
        return self.layout == otherFactory.layout
    }
    
}

extension Factory: CustomStringConvertible {
    
    var description: String {
        return "Factory #\(id) with \(fitness):\n\n\(layout.description)\n\n"
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
