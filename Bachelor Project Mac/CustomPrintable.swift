//
//  CustomPrintable.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 03.05.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

protocol CustomPrintable {
    
    func debug()
    func extensivePrint()
    
}

extension CustomPrintable {
    
    func debug() {
        switch SimulationSettings.shared.debugLevel {
        case .fast:
            dump(self)
        case .readable:
            print(self)
        case .extensive:
            extensivePrint()
        case .off:
            break
        }
    }
    
    func extensivePrint() {
        print(self)
    }
    
}
