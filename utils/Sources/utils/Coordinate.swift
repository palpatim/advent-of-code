//
//  Coordinate.swift
//
//
//  Created by Schmelter, Tim on 12/17/21.
//

import Foundation

public struct Coordinate {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    /// Initializes a Coordinate from a string of the form "<X Value>,<Y Value>"
    ///
    /// Example:
    /// ```
    /// let coordinate = Coordinate(stringValue: "2,3")
    /// // Coordinate { x: 2; y: 3 }
    /// ```
    public init(stringValue: any StringProtocol) {
        let components = stringValue.components(separatedBy: ",")
        x = Int(components[0])!
        y = Int(components[1])!
    }

    /// Initializes a Coordinate from a string of the form "x=<X Value>, y=<Y Value>"
    ///
    /// Example:
    /// ```
    /// let coordinate = Coordinate(coordinateString: "x=-2, y=15")
    /// // Coordinate { x: 2; y: 3 }
    /// ```
    public init(coordinateString: any StringProtocol) {
        let trimmed = coordinateString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")

        let components = trimmed.components(separatedBy: ",")
        let xAssignment = components[0].components(separatedBy: "=")
        let yAssignment = components[1].components(separatedBy: "=")

        guard
            let xStr = xAssignment.last,
            let x = Int(xStr),
            let yStr = yAssignment.last,
            let y = Int(yStr)
        else {
            fatalError("Invalid format: \(coordinateString)")
        }

        self.x = x
        self.y = y
    }

    public static func xy(_ x: Int, _ y: Int) -> Coordinate {
        Coordinate(x: x, y: y)
    }

    /// Returns the nearest direction to `other`, calculated where x-axis is 0
    public func direction(to other: Coordinate) -> Direction {
        let dX = Float(other.x - x)
        let dY = Float(other.y - y)
        let theta = atan2(dY, dX)
        return Direction(radians: theta)!
    }

    /// Returns the Euclidian distance to other
    public func distance(to other: Coordinate) -> Double {
        let dX = other.x - x
        let dY = other.y - y
        return Double((dX * dX) + (dY * dY)).squareRoot()
    }

    /// Returns true if `other` is adjacent to the receiver--that is, if the distance between them is <= 1
    public func isAdjacent(to other: Coordinate) -> Bool {
        let dX = abs(other.x - x)
        let dY = abs(other.y - y)
        return dX <= 1 && dY <= 1
    }

    /// Returns the Manhattan distance to other
    public func manhattanDistance(to other: Coordinate) -> Int {
        let dX = abs(other.x - x)
        let dY = abs(other.y - y)
        return dX + dY
    }
}

extension Coordinate: Equatable {}

extension Coordinate: Hashable {}

extension Coordinate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x),\(y))"
    }
}
