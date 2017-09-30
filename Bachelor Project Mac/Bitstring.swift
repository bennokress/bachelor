//
//  Bitstring.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.09.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Bitstring: Codable {
    
    var bits: [Bit]
    
    var length: Int { return bits.count }
    
    init(length: Int) {
        var bits: [Bit] = []
        length.times { bits.append(Bit.random) }
        self.bits = bits
    }
    
    init(from bitstring1: Bitstring, and bitstring2: Bitstring, mergedAfter cutIndex: Int) {
        guard cutIndex < bitstring1.length else { fatalError("Cut Index is out of range!") }
        if cutIndex == 0 {
            self.bits = bitstring1.bits
        } else {
            let bitIndices = 0 ... bitstring1.length - 1
            var crossoverBits: [Bit] = []
            for i in bitIndices {
                crossoverBits.append(i < cutIndex ? bitstring1.bits[i] : bitstring2.bits[i])
            }
            self.bits = crossoverBits
        }
    }
    
    init(from bitstring: Bitstring, mutatedBitsCount: Int) {
        guard mutatedBitsCount <= bitstring.length else { fatalError("More Bits to be flipped than available!") }
        if mutatedBitsCount == 0 {
            self.bits = bitstring.bits
        } else {
            var mutatedBitstring = bitstring.bits
            let mutationIndices = Array(0 ... bitstring.length - 1).shuffled[0 ... mutatedBitsCount - 1]
            for i in mutationIndices { mutatedBitstring[i] = mutatedBitstring[i].flipped }
            self.bits = mutatedBitstring
        }
    }
    
    mutating func flip(at index: Int) {
        var bitstring = self.bits
        bitstring[index] = bitstring[index].flipped
        self.bits = bitstring
    }
    
}

extension Bitstring: Equatable {
    
    static func == (lhs: Bitstring, rhs: Bitstring) -> Bool {
        return lhs.bits == rhs.bits
    }
    
}

extension Bitstring: CustomStringConvertible {
    
    var description: String {
        var string = ""
        for bit in bits { string.append(bit.description) }
        return string
    }
    
}
