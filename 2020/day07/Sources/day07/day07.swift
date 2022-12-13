import Foundation
import XCTest

public enum day07 {
    public static func solvePart1(
        _ input: String,
        queryColor: String
    ) -> Int {
        let bagGraph = parseInput(input)
        return bagGraph.countContainers(of: queryColor)
    }

    public static func solvePart2(
        _ input: String,
        queryColor: String
    ) -> Int {
        let bagGraph = parseInput(input)
        return bagGraph.countAllContained(of: queryColor)
    }

    /// Given a list of input rules, parse each line into an overall dependency graph.
    private static func parseInput(_ input: String) -> BagGraph {
        let lines = input.split(separator: "\n")
        let bagGraph = BagGraph()
        for line in lines {
            let colorAndRemainder = line.components(
                separatedBy: " bags contain "
            )
            guard let color = colorAndRemainder.first,
                  let remainder = colorAndRemainder.last
            else {
                preconditionFailure("Invalid input: \(line)")
            }

            let rules = remainder
                .components(separatedBy: ", ")
                .compactMap { BagGraph.BagRule(rawValue: $0) }

            bagGraph.color(color, contains: rules)
        }
        return bagGraph
    }
}

typealias Bag = Vertex<String>

/// Weighted Graph types adapted from Swift Algorithm Club: https://www.raywenderlich.com/773-swift-algorithm-club-graphs-with-adjacency-list
public class Edge<T: Hashable> {
    public let source: Vertex<T>
    public let destination: Vertex<T>
    public let weight: Int
    public init(
        source: Vertex<T>,
        destination: Vertex<T>,
        weight: Int = 0
    ) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

public extension Edge {
    enum EdgeDirection {
        case incoming, outgoing
    }

    func displayValue(for direction: EdgeDirection) -> String {
        switch direction {
        case .incoming:
            return "<--(\(weight))-- \(source)"
        case .outgoing:
            return "--(\(weight))--> \(destination)"
        }
    }
}

extension Edge: Equatable {
    public static func == (lhs: Edge, rhs: Edge) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension Edge: Hashable {
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}

extension BagGraph: CustomDebugStringConvertible {
    public var debugDescription: String {
        var output = [String]()
        for key in allBags.keys.sorted() {
            let bag = allBags[key]!
            output.append("\(bag.value)")
            for edge in bag.outgoingEdges {
                output.append(" \(edge.displayValue(for: .outgoing))")
            }
            for edge in bag.incomingEdges {
                output.append(" \(edge.displayValue(for: .incoming))")
            }
        }
        return output.joined(separator: "\n")
    }
}

public extension BagGraph {
    struct BagRule {
        let count: Int
        let color: String

        public init(
            count: Int,
            color: String
        ) {
            self.count = count
            self.color = color
        }

        public init?(rawValue: String) {
            let firstSpaceIndex = rawValue.firstIndex(of: " ")!
            let countString = rawValue[..<firstSpaceIndex]

            /// The rawValue may say something like "contain no other bags". Let the failable
            /// Int initializer catch that.
            guard let count = Int(countString) else {
                return nil
            }

            let remainderStartIndex = rawValue.index(after: firstSpaceIndex)
            let remainder = rawValue[remainderStartIndex...]
            let bagIndex = remainder.range(of: " bag")!.lowerBound
            let color = remainder[..<bagIndex]

            self.count = count
            self.color = String(color)
        }
    }
}

extension Dictionary {
    mutating func getOrSetDefault(_ key: Key, default: Value) -> Value {
        if let value = self[key] {
            return value
        }
        self[key] = `default`
        return `default`
    }
}

public class BagGraph {
    public typealias Bag = Vertex<String>

    private var allBags = [String: Bag]()

    public func color(_ color: String, contains rules: [BagRule]) {
        let container = allBags.getOrSetDefault(color, default: Bag(color))
        for rule in rules {
            let destination = allBags.getOrSetDefault(rule.color, default: Bag(rule.color))
            container.addEdge(to: destination, weight: Int(rule.count))
        }
    }

    /// Starting at the bag of the specified `color` count all containers
    public func countContainers(of color: String) -> Int {
        guard let innermostBag = allBags[color] else {
            return 0
        }

        var count = 0
        var visited = Set([innermostBag.value])

        // BFS
        var queue = innermostBag
            .incomingEdges
            .map { $0.source }
            .filter { !visited.contains($0.value) }
        while !queue.isEmpty {
            let bag = queue.removeFirst()
            guard !visited.contains(bag.value) else {
                continue
            }
            visited.insert(bag.value)
            count += 1
            let newBags = bag
                .incomingEdges
                .map { $0.source }
                .filter { !visited.contains($0.value) }
            queue.append(contentsOf: newBags)
        }
        return count
    }

    /// Starting at the bag of the specified `color` count all containers. Assumes no circular references
    public func countAllContained(of color: String) -> Int {
        guard let outermostBag = allBags[color] else {
            return 0
        }

        var count = 0

        // BFS
        var queue = [outermostBag]
        while !queue.isEmpty {
            let bag = queue.removeFirst()
            // Brute force solution: We'll insert one bag into the queue for each contained bag. Would be better to keep track of the multipliers
            for edge in bag.outgoingEdges {
                let newBags = [Bag](
                    repeating: edge.destination,
                    count: edge.weight
                )
                count += edge.weight
                queue.append(contentsOf: newBags)
            }
        }
        return count
    }
}

/// Note we're including the edges directly onto the Vertex type rather than modeling it as a separate structure. We're also going to cheat and add an `incomingEdges` map to make it easier to traverse
public class Vertex<T: Hashable> {
    public let value: T
    public private(set) var outgoingEdges: Set<Edge<T>>
    public private(set) var incomingEdges: Set<Edge<T>>
    public init(_ color: T) {
        value = color
        outgoingEdges = []
        incomingEdges = []
    }

    public func addEdge(
        to destination: Vertex<T>,
        weight: Int
    ) {
        outgoingEdges.insert(
            Edge(source: self, destination: destination, weight: weight)
        )
        destination.incomingEdges.insert(
            Edge(source: self, destination: destination, weight: weight)
        )
    }

    public func addUndirectedEdges(
        to destination: Vertex<T>,
        weight: Int
    ) {
        addEdge(to: destination, weight: weight)
        destination.addEdge(to: self, weight: weight)
    }
}

extension Vertex: Equatable {
    public static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension Vertex: Hashable {
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}
