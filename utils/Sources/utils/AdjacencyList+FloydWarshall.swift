//
//  AdjacencyList+FloydWarshall.swift
//  
//
//  Created by Schmelter, Tim on 12/26/22.
//

import Foundation

extension AdjacencyList {
    /// Returns a Dictionary keyed by vertex element, where each dictionary value is a dictionary of distances to other nodes in the
    /// graph.
    ///
    /// This method calcluates the distance matrix using the
    /// [Floyd-Warshall algorithm](https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm).
    public func distancesByVertex() -> [Vertex<Element>: [Vertex<Element>: Double]] {
        var distances = [Vertex<Element>: [Vertex<Element>: Double]]()
        for (vertex1, edges) in adjacencyDict {
            distances[vertex1] = [:]
            for vertex2 in adjacencyDict.keys {
                let distance: Double
                if vertex1 == vertex2 {
                    distance = 0
                } else if let edge = edges.first(where: { $0.destination == vertex2 }) {
                    distance = edge.weight
                } else {
                    distance = Double.infinity
                }
                distances[vertex1]![vertex2] = distance
            }
        }

        for k in adjacencyDict.keys {
            for i in adjacencyDict.keys {
                for j in adjacencyDict.keys {
                    distances[i]![j] = min(distances[i]![j]!, distances[i]![k]! + distances[k]![j]!)
                }
            }
        }

        return distances
    }
}
