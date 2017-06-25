//
//  ActionPrintable.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 25.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

protocol ActionPrintable {
    
    func actionPrint(fast: String?, short: String, detailed: [String])
    
}

extension ActionPrintable {
    
    func actionPrint(fast: String? = nil, short: String, detailed: [String]) {
        switch SimulationSettings.shared.actionInformationLevel {
        case .fast:
            if let fastInfo = fast { print(fastInfo) }
        case .readable:
            print(short)
        case .extensive:
            for info in detailed { print(info) }
        case .off:
            break
        }
    }
    
}
