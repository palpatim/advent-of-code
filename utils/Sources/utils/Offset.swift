//
//  Offset.swift
//
//
//  Created by Schmelter, Tim on 12/17/21.
//

// MARK: - Offset

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
    /// Returns an Offset of magnitude 1 along each axis, where x increases west-to-east and y increases south-to-north
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

    /// Returns an Offset of magnitude 1 along each axis, where x increases west-to-east and y increases north-to-south.
    var coordinateOffset: Offset {
        switch self {
        case .e: return Offset(x: 1, y: 0)
        case .ne: return Offset(x: 1, y: -1)
        case .n: return Offset(x: 0, y: -1)
        case .nw: return Offset(x: -1, y: -1)
        case .w: return Offset(x: -1, y: 0)
        case .sw: return Offset(x: -1, y: 1)
        case .s: return Offset(x: 0, y: 1)
        case .se: return Offset(x: 1, y: 1)
        }
    }
}

public extension RelativeDirection {
    /// Returns an Offset of magnitude 1 along each axis. `x` increases from left to right. `y` increases from top to bottom.
    var unitOffset: Offset {
        switch self {
        case .right: return Offset(x: 1, y: 0)
        case .down: return Offset(x: 0, y: 1)
        case .left: return Offset(x: -1, y: 0)
        case .up: return Offset(x: 0, y: -1)
        }
    }
}

// MARK: - Offset3D

public struct Offset3D {
    public let x: Int
    public let y: Int
    public let z: Int
    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public extension Coordinate3D {
    func applying(_ offset: Offset3D) -> Coordinate3D {
        Coordinate3D(x: x + offset.x, y: y + offset.y, z: z + offset.z)
    }
}

public enum Direction3D: CaseIterable {
    case posX, negX, posY, negY, posZ, negZ

    public var offset: Offset3D {
        switch self {
        case .posX: return Offset3D(x: 1, y: 0, z: 0)
        case .negX: return Offset3D(x: -1, y: 0, z: 0)
        case .posY: return Offset3D(x: 0, y: 1, z: 0)
        case .negY: return Offset3D(x: 0, y: -1, z: 0)
        case .posZ: return Offset3D(x: 0, y: 0, z: 1)
        case .negZ: return Offset3D(x: 0, y: 0, z: -1)
        }
    }
}
