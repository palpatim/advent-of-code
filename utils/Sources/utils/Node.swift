//
//  Node.swift
//  
//
//  Created by Schmelter, Tim on 12/17/21.
//
import Foundation

open class Node<Value: Hashable> {
    private let id: UUID
    public let value: Value
    public private(set) var neighbors: Set<Node<Value>>

    public init(_ value: Value) {
        self.id = UUID()
        self.value = value
        self.neighbors = []
    }

    /// Sets up a bi-directional link between the receiver and `neighbor`.
    public func link(to neighbor: Node<Value>) {
        neighbors.insert(neighbor)
        neighbor.neighbors.insert(self)
    }
}

extension Node: Equatable {
    public static func ==(_ lhs: Node, _ rhs: Node) -> Bool {
        lhs.id == rhs.id
    }
}

extension Node: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension Node: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(value): \(neighbors.map({"\($0.value)"}).joined(separator: ","))"
    }
}

// MARK: - Extensions

extension Node where Value: Numeric {
    var sum: Value {
        let neighborSum = neighbors
            .map { $0.value }
            .reduce(0, +)

        return neighborSum + value
    }
}
