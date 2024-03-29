//
//  Range+Centered.swift
//
//
//  Created by Schmelter, Tim on 12/10/22.
//

import Foundation

public extension Range where Bound: BinaryInteger {
    static func range(of size: Bound, centeredOn center: Bound) -> Range<Bound> {
        let lowerBound = center - size.quotientAndRemainder(dividingBy: 2).quotient
        var upperBound = center + size.quotientAndRemainder(dividingBy: 2).quotient
        if !size.isMultiple(of: 2) {
            upperBound += 1
        }
        return lowerBound ..< upperBound
    }
}

public extension Range where Bound: FloatingPoint {
    static func range(of size: Bound, centeredOn center: Bound) -> Range<Bound> {
        let lowerBound = center - (size / 2)
        let upperBound = center + (size / 2)
        return lowerBound ..< upperBound
    }
}
