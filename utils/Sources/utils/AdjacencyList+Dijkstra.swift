//
//  AdjacencyList+Dijkstra.swift
//  
//
//  Created by Schmelter, Tim on 12/12/22.
//

import Foundation

extension AdjacencyList {
    /// Returns an array of edges representing the shortest path from `source` to `destination`
    ///
    /// This method uses Dijkstra's algorithm to find the lowest-cost path between the two vertices.
    ///
    /// - Parameters:
    ///   - source: the source vertex
    ///   - destination: the desetination vertex
    /// - Returns: an array of edges, or nil if there is no path between the vertices
    public func shortestPath(
        from source: Vertex<Element>,
        to destination: Vertex<Element>
    ) -> [Edge<Element>]? {
        var visits = [source: Visit<Element>.source]

        let priorityQueue = PriorityQueue<Vertex<Element>> {
            self.distance(to: $0, in: visits) < self.distance(to: $1, in: visits)
        }
        priorityQueue.enqueue(source)

        while let visitedVertex = priorityQueue.dequeue() {
            if visitedVertex == destination {
                return path(to: destination, in: visits)
            }

            let neighbors = edges(from: visitedVertex) ?? []
            for edge in neighbors {
                let weight = edge.weight

                if visits[edge.destination] != nil {
                    let distanceToVisited = distance(to: visitedVertex, in: visits)
                    let distanceToDestination = distance(to: edge.destination, in: visits)
                    if distanceToVisited + weight < distanceToDestination {
                        visits[edge.destination] = .edge(edge)
                        priorityQueue.enqueue(edge.destination)
                    }
                } else {
                    visits[edge.destination] = .edge(edge)
                    priorityQueue.enqueue(edge.destination)
                }
            }
        }

        return nil
    }

    private func path(
        to destination: Vertex<Element>,
        in tree: [Vertex<Element> : Visit<Element>]
    ) -> [Edge<Element>] {
        var currentVertex = destination
        var path = [Edge<Element>]()

        while
            let visit = tree[currentVertex],
            case .edge(let edge) = visit
        {
            path = [edge] + path
            currentVertex = edge.source
        }
        return path
    }

    private func distance(
        to destination: Vertex<Element>,
        in tree: [Vertex<Element> : Visit<Element>]
    ) -> Double {
        let path = path(to: destination, in: tree)
        return path.totalWeight
    }
}

public enum Visit<Element: Hashable> {
    case source
    case edge(Edge<Element>)
}

public protocol EdgeValue<Value> {
    associatedtype Value
    var weight: Double { get }
}

extension Edge: EdgeValue {}

public extension Array where Array.Element: EdgeValue {
    var totalWeight: Double {
        map { $0.weight }
            .reduce(0.0, +)
    }
}
