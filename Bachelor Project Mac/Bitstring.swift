//
//  Bitstring.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.09.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Bitstring: Codable {
    
    static var random: Bitstring {
        return Bitstring()
    }
    
    var bits: [Bit]
    
    var length: Int { return bits.count }
    
    private init(from bits: [Bit]) {
        self.bits = bits
    }
    
    init(length: Int = SimulationSettings.shared.workstationCount) {
        var bits: [Bit] = []
        length.times { bits.append(Bit.random) }
        self.bits = bits
    }
    
    init(from bitstring1: Bitstring, and bitstring2: Bitstring, mergedWith switchBits: Int) {
        guard switchBits <= bitstring1.length else { fatalError("More bits should be flipped than available!") }
        if switchBits == 0 {
            self.bits = bitstring1.bits
        } else {
            let cutIndex = bitstring1.length - switchBits
            let bitIndices = 0 ... bitstring1.length - 1
            var crossoverBits: [Bit] = []
            for index in bitIndices {
                crossoverBits.append(index < cutIndex ? bitstring1.bits[index] : bitstring2.bits[index])
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
    
    func removing(numberOfBits removableBitsCount: Int) -> Bitstring {
        guard removableBitsCount <= self.length else { fatalError("More Bits to be removed than available!") }
        if removableBitsCount == 0 {
            return Bitstring(from: self.bits)
        } else {
            var minimizedBitstring: [Bit] = []
            let maxIndex = self.length - 1
            let keepIndices = Array(0 ... maxIndex).shuffled[0 ... maxIndex - removableBitsCount].sorted()
            for i in keepIndices { minimizedBitstring.append(self.bits[i]) }
            return Bitstring(from: minimizedBitstring)
        }
    }
    
    func distance(to otherBitstring: Bitstring) -> Int? {
        guard self.length == otherBitstring.length else { return nil }
        var bitDistance = 0
        for i in 0 ... length - 1 {
            bitDistance += bits[i].distance(to: otherBitstring.bits[i])
        }
        return bitDistance
    }
    
}

// MARK: - 🔖 Equatable Conformance
extension Bitstring: Equatable {
    
    static func == (lhs: Bitstring, rhs: Bitstring) -> Bool {
        return lhs.bits == rhs.bits
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Bitstring: CustomStringConvertible {
    
    var description: String {
        var string = ""
        for bit in bits { string.append(bit.description) }
        return string
    }
    
}
