//
//  Coordinate3D.swift
//  
//
//  Created by Schmelter, Tim on 12/9/22.
//

public struct Coordinate3D: Hashable {
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
        self.x = Int(components[0])!
        self.y = Int(components[1])!
        self.z = Int(components[2])!
    }

}

extension Coordinate3D: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x),\(y),\(z)"
    }
}
