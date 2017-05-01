//
//  Extensions.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

extension Int {
    
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0 ..< self {
                f()
            }
        }
    }
    
    func times(f: @autoclosure () -> ()) {
        if self > 0 {
            for _ in 0 ..< self {
                f()
            }
        }
    }
    
}
