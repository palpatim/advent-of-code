//
//  Offset.swift
//
//
//  Created by Schmelter, Tim on 12/17/21.
//

public struct Offset {
    public let x: Int
    public let y: Int
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public extension Coordinate {
    func applying(_ offset: Offset) -> Coordinate {
        Coordinate(x: x + offset.x, y: y + offset.y)
    }
}

public extension Direction {
    /// Returns an Offset of magnitude 1 along each axis
    var unitOffset: Offset {
        switch self {
        case .e: return Offset(x: 1, y: 0)
        case .ne: return Offset(x: 1, y: 1)
        case .n: return Offset(x: 0, y: 1)
        case .nw: return Offset(x: -1, y: 1)
        case .w: return Offset(x: -1, y: 0)
        case .sw: return Offset(x: -1, y: -1)
        case .s: return Offset(x: 0, y: -1)
        case .se: return Offset(x: 1, y: -1)
        }
    }
}
