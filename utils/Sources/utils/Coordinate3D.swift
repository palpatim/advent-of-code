//
//  Coordinate3D.swift
//
//
//  Created by Schmelter, Tim on 12/9/22.
//

public struct Coordinate3D {
    public let x: Int
    public let y: Int
    public let z: Int

    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(stringValue: String) {
        let components = stringValue.components(separatedBy: ",")
        x = Int(components[0])!
        y = Int(components[1])!
        z = Int(components[2])!
    }
}

extension Coordinate3D: Equatable {}

extension Coordinate3D: Hashable {}

extension Coordinate3D: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x),\(y),\(z))"
    }
}
