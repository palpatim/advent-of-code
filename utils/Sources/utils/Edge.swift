//
//  Edge.swift
//
//
//  Created by Schmelter, Tim on 12/12/22.
//

import Foundation

/// Weighted Graph types adapted from Swift Algorithm Club:
/// https://www.raywenderlich.com/773-swift-algorithm-club-graphs-with-adjacency-list
public struct Edge<Value> {
    public let source: Vertex<Value>
    public let destination: Vertex<Value>
    public let weight: Double
    public init(
        source: Vertex<Value>,
        destination: Vertex<Value>,
        weight: Double = 1.0
    ) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

extension Edge: CustomDebugStringConvertible {
    public var debugDescription: String {
        "- (\(weight.formatted(.number))) -> \(destination)"
    }
}

extension Edge: Equatable where Value: Equatable {}

extension Edge: Hashable where Value: Hashable {}
