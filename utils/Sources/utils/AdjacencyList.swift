//
//  AdjacencyList.swift
//  
//
//  Created by Schmelter, Tim on 12/12/22.
//

import Foundation

/// Weighted Graph types adapted from Swift Algorithm Club:
/// https://www.raywenderlich.com/773-swift-algorithm-club-graphs-with-adjacency-list
open class AdjacencyList<Element: Hashable> {
    public var adjacencyDict = [Vertex<Element>: [Edge<Element>]]()
    public init() {}
}

extension AdjacencyList: Graphable {
    public typealias Element = Element

    public func add(
        _ type: EdgeType,
        from source: Vertex<Element>,
        to destination: Vertex<Element>,
        weight: Double = 1.0
    ) {
        switch type {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(vertices: (source, destination), weight: weight)
        }
    }

    public func weight(
        from source: Vertex<Element>,
        to destination: Vertex<Element>
    ) -> Double? {
        guard let edges = adjacencyDict[source] else {
            return nil
        }

        guard let edge = edges.first(where: { $0.destination == destination }) else {
            return nil
        }

        return edge.weight
    }

    public func edges(from source: Vertex<Element>) -> [Edge<Element>]? {
        return adjacencyDict[source]
    }

    public var description: CustomStringConvertible {
        var result = ""
        for (vertex, edges) in adjacencyDict {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }

    public func createVertex(data: Element) -> Vertex<Element> {
        let vertex = Vertex(data)

        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }

        return vertex
    }

    private func addDirectedEdge(
        from source: Vertex<Element>,
        to destination: Vertex<Element>,
        weight: Double = 1.0
    ) {
        let edge = Edge(
            source: source,
            destination: destination,
            weight: weight
        )
        adjacencyDict[source]?.append(edge)
    }

    private func addUndirectedEdge(
        vertices: (Vertex<Element>, Vertex<Element>),
        weight: Double = 1.0
    ) {
        let (source, destination) = vertices
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }

}
