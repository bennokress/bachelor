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
    var layout: FactoryLayout
    var state: FactoryState // TODO: Is this really neccessary?
    
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
    
    var fitness: Int {
        return run()
    }
    
}

// MARK: Simulation
extension Factory {
    
    var allRobotsFinishedOrBlocked: Bool {
        // FIXME: Implement!
//        return robots.map { ($0.state != .finished) || ($0.state != .blocked) }.count == 0
        return true
    }
    
    func hasEqualLayout(as otherFactory: Factory) -> Bool {
        // FIXME: Implement!
        // All workstations have the same position and type (at that position) -> true
        return false
    }
    
    /// Runs the simulation until all robots are either blocked or finished. Returns the rounds needed (fitness).
    fileprivate func run() -> Int {
        var factoryCopy = self
        repeat {
            factoryCopy.simulateNextStep()
        } while !allRobotsFinishedOrBlocked
        return 0
    }
    
    private mutating func simulateNextStep() {
        for robot in robots {
            var modifiableRobot = robot
            var modifiedRobot = modifiableRobot.performStep(in: layout)
            layout.modifyRobot(robot, to: &modifiedRobot)
        }
    }
    
}

extension Factory: CustomStringConvertible {
    
    var description: String {
        return "Factory #\(id) with fitness \(fitness):\n\n\(layout.description)\n\n"
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
