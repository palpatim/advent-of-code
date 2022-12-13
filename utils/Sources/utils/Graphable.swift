//
//  Graphable.swift
//
//
//  Created by Schmelter, Tim on 12/12/22.
//

import Foundation

/// Weighted Graph types adapted from Swift Algorithm Club:
/// https://www.raywenderlich.com/773-swift-algorithm-club-graphs-with-adjacency-list
public protocol Graphable<Element> {
    associatedtype Element: Hashable

    var description: CustomStringConvertible { get }

    func createVertex(data: Element) -> Vertex<Element>

    func add(
        _ type: EdgeType,
        from source: Vertex<Element>,
        to destination: Vertex<Element>,
        weight: Double
    )

    func weight(
        from source: Vertex<Element>,
        to destination: Vertex<Element>
    ) -> Double?

    func edges(
        from source: Vertex<Element>
    ) -> [Edge<Element>]?
}
