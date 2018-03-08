//
//  Bitstring.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.09.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Bitstring {
    
    /// Initializes a Bitstring from the given Bit array
    private init(from bits: [Bit]) {
        self.bits = bits
    }
    
    /// Inititalizes a random Bitstring with the given length
    init(length: Int = SimulationSettings.shared.workstationCount) {
        var bits: [Bit] = []
        length.times { bits.append(Bit.random) }
        self.bits = bits
    }
    
    /// Initializes a Bitstring by merging the provided Bitstrings with the given "mergeBitCount" indicating the number of Bits from factory 2
    init(from bitstring1: Bitstring, byMerging mergeBitCount: Int, from bitstring2: Bitstring) {
        guard mergeBitCount <= bitstring1.length else { fatalError("More bits should be flipped than available!") }
        if mergeBitCount == 0 {
            self.bits = bitstring1.bits
        } else {
            let cutIndex = bitstring1.length - mergeBitCount
            let bitIndices = 0 ... bitstring1.length - 1
            var crossoverBits: [Bit] = []
            for index in bitIndices {
                crossoverBits.append(index < cutIndex ? bitstring1.bits[index] : bitstring2.bits[index])
            }
            self.bits = crossoverBits
        }
    }
    
    /// Initializes a Bitstring by flipping the given number of mutated Bits in the specified Bitstring
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
    
    // MARK: - 🔨 Static Properties
    
    /// A random Bitstring with the length specified in the SimulationSettings
    static var random: Bitstring {
        return Bitstring()
    }
    
    // MARK: - 🔧 Properties
    
    /// The array representation of the Bitstring
    var bits: [Bit]
    
    // MARK: - ⚙️ Computed Properties
    
    /// The length of the Bitstring
    var length: Int { return bits.count }
    
    // MARK: - 📗 Functions
    
    /// Returns the Bitstring with the specified amount of Bits cut from the back
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
    
    /// Returns the pairwise distance of the Bitstring to the specified Bitstring. Returns nil if the length doesn't match
    func distance(to otherBitstring: Bitstring) -> Int? {
        guard self.length == otherBitstring.length else { return nil }
        var bitDistance = 0
        for i in 0 ... length - 1 {
            bitDistance += bits[i].distance(to: otherBitstring.bits[i])
        }
        return bitDistance
    }
    
    // MARK: - 📕 Mutating Functions
    
    /// Flips the Bit at the given index
    mutating func flip(at index: Int) {
        var bitstring = self.bits
        bitstring[index] = bitstring[index].flipped
        self.bits = bitstring
    }
    
}

// MARK: - 🔖 Equatable Conformance
extension Bitstring: Equatable {
    
    /// Two Bitstrings are considered equal if their pairwise Bit distance is zero
    static func == (lhs: Bitstring, rhs: Bitstring) -> Bool {
        return lhs.distance(to: rhs) == 0
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
