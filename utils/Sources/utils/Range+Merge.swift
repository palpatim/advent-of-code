//
//  Range+Merge.swift
//
//
//  Created by Schmelter, Tim on 12/15/22.
//

import Foundation

public extension ClosedRange where Bound: Comparable {
    mutating func mergeWith(_ other: ClosedRange<Bound>) {
        let newLowerBound = Swift.min(lowerBound, other.lowerBound)
        let newUpperBound = Swift.max(upperBound, other.upperBound)
        self = newLowerBound ... newUpperBound
    }

    func mergedWith(_ other: ClosedRange<Bound>) -> ClosedRange<Bound> {
        let newLowerBound = Swift.min(lowerBound, other.lowerBound)
        let newUpperBound = Swift.max(upperBound, other.upperBound)
        return newLowerBound ... newUpperBound
    }

    func intersection(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        guard overlaps(other) else {
            return nil
        }

        let newLowerBound = Swift.max(lowerBound, other.lowerBound)
        let newUpperBound = Swift.min(upperBound, other.upperBound)
        return newLowerBound ... newUpperBound
    }
}

public extension ClosedRange where Bound == Int {
    /// Splits receiver at the specified bound, and returns two separate ranges.
    ///
    /// If self does not contain `bound`, the return value will consist of self, unmodified.
    func splitting(at split: Bound) -> [ClosedRange<Bound>] {
        guard contains(split) else {
            return [self]
        }

        let lowerRange = lowerBound ... (split - 1)

        let upperRange = (split + 1) ... upperBound

        return [lowerRange, upperRange]
    }
}

public extension Range where Bound: BinaryInteger {
    func intersection(_ other: Range<Bound>) -> Range<Bound>? {
        guard overlaps(other) else {
            return nil
        }

        let newLowerBound = Swift.max(lowerBound, other.lowerBound)
        let newUpperBound = Swift.min(upperBound, other.upperBound)
        return newLowerBound ..< newUpperBound + 1
    }
}
