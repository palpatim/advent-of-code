//
//  Vertex.swift
//  
//
//  Created by Schmelter, Tim on 12/12/22.
//

import Foundation

/// Note we're including the edges directly onto the Vertex type rather than modeling it as a separate structure.
/// 
/// Weighted Graph types adapted from Swift Algorithm Club:
/// https://www.raywenderlich.com/773-swift-algorithm-club-graphs-with-adjacency-list
public struct Vertex<Value> {
    public let value: Value
    public init(_ value: Value) {
        self.value = value
    }
}

extension Vertex: Equatable where Value: Equatable { }

extension Vertex: Hashable where Value: Hashable { }

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}
