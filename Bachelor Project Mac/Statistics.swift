//
//  Statistics.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 10.09.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class Statistics: Encodable {
    
    private init() { }
    static var shared = Statistics()
    
    private var evolution: [Generation] = []
    
    func save(_ generation: Generation) {
        evolution.append(generation)
    }
    
    func createJSON() {
        // TODO: Save to file instead of console
        self.printToConsole()
    }

}
