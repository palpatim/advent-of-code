//
//  Coordinate.swift
//  
//
//  Created by Schmelter, Tim on 12/17/21.
//

import Foundation

public struct Coordinate: Hashable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init(stringValue: String) {
        let components = stringValue.components(separatedBy: ",")
        self.x = Int(components[0])!
        self.y = Int(components[1])!
    }

    /// Returns the Euclidian distance to other
    public func distance(to other: Coordinate) -> Double {
        let dX = other.x - self.x
        let dY = other.y - self.y
        return Double((dX * dX) + (dY * dY)).squareRoot()
    }

    /// Returns true if `other` is adjacent to the receiver--that is, if the distance between them is <= 1
    public func isAdjacent(to other: Coordinate) -> Bool {
        let dX = abs(other.x - self.x)
        let dY = abs(other.y - self.y)
        return dX <= 1 && dY <= 1
    }

    /// Returns the nearest direction to `other`, calculated where x-axis is 0
    public func direction(to other: Coordinate) -> Direction {
        let dX = Float(other.x - self.x)
        let dY = Float(other.y - self.y)
        let theta = atan2(dY, dX)
        return Direction(radians: theta)!
    }

}

extension Coordinate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x),\(y))"
    }
}

private extension Direction {
}
