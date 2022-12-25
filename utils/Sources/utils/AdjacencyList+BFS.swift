//
//  AdjacencyList+BFS.swift
//  
//
//  Created by Schmelter, Tim on 12/25/22.
//

import DequeModule
import Foundation

extension AdjacencyList {
    public func bfs(
        from source: Vertex<Element>,
        to destination: Vertex<Element>
    ) -> [Vertex<Element>] {
        bfs(from: source) { $0 == destination }
    }
    
    /// Performs a breadth-first search on the graph, returning the path from source to the stopping node.
    ///
    /// The returned array contains the elements in order from source vertex to the stopping vertex, inclusive. If no path exists,
    /// the array will be empty, not even including the starting vertex.
    public func bfs(
        from source: Vertex<Element>,
        stoppingWhen condition: (Vertex<Element>) -> Bool
    ) -> [Vertex<Element>] {

        var queue = Deque<[Vertex<Element>]>(arrayLiteral: [source])
        var visited = Set<Vertex<Element>>()

        while !queue.isEmpty {
            let currentPath = queue.removeFirst()
            let currentVertex = currentPath.last!

            guard !visited.contains(currentVertex) else {
                continue
            }
            visited.insert(currentVertex)

            if condition(currentVertex) {
                return currentPath
            }

            guard let edges = edges(from: currentVertex) else {
                continue
            }

            let candidates = edges
                .map { $0.destination }
                .filter { !visited.contains($0) }

            for candidate in candidates {
                var newPath = currentPath
                newPath.append(candidate)
                queue.append(newPath)
            }
        }

        return []
    }
}
