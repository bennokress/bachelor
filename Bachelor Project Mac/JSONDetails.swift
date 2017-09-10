//
//  JSONDetails.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 03.09.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum JSONDetails: Int {
    case off
    case minimal
    case standard
    case full
}

extension JSONDetails: Comparable {

    // Example Usage: If detailLevel > JSONDetail.minimal { include key-value-pair XY }
    public static func < (a: JSONDetails, b: JSONDetails) -> Bool {
        return a.rawValue < b.rawValue
    }
    
}
