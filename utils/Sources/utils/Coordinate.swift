//
//  Coordinate.swift
//  
//
//  Created by Schmelter, Tim on 12/17/21.
//

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

}

extension Coordinate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x),\(y))"
    }
}
