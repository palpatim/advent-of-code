//
//  AdjacencyListTests.swift
//
//
//  Created by Schmelter, Tim on 12/12/22.
//

import utils
import XCTest

final class AdjacencyListTests: XCTestCase {
    func testUndirected() async throws {
        let graph = AdjacencyList<Int>()
        let zero = graph.createVertex(data: 0)
        let one = graph.createVertex(data: 1)
        graph.add(
            .undirected,
            from: zero,
            to: one,
            weight: 0.0
        )

        XCTAssertEqual(graph.edges(from: zero)?.first?.destination, one)
        XCTAssertEqual(graph.edges(from: one)?.first?.destination, zero)
    }

    func testDirected() async throws {
        let graph = AdjacencyList<Int>()
        let zero = graph.createVertex(data: 0)
        let one = graph.createVertex(data: 1)
        graph.add(
            .directed,
            from: zero,
            to: one,
            weight: 0.0
        )

        XCTAssertEqual(graph.edges(from: zero)?.first?.destination, one)
        XCTAssertEqual(graph.edges(from: one)?.isEmpty, true)
    }

    func testUndirectedDistance() async throws {
        let graph = AdjacencyList<Int>()
        let zero = graph.createVertex(data: 0)
        let one = graph.createVertex(data: 1)
        let two = graph.createVertex(data: 2)
        graph.add(
            .directed,
            from: zero,
            to: one,
            weight: 1.0
        )
        graph.add(
            .directed,
            from: one,
            to: two,
            weight: 2.0
        )

        XCTAssertEqual(graph.shortestPath(from: zero, to: two)?.totalWeight, 3)
    }

    func testShortestPath_dijkstra() async throws {
        let graph = AdjacencyList<Int>()
        let zero = graph.createVertex(data: 0)
        let one = graph.createVertex(data: 1)
        let two = graph.createVertex(data: 2)
        graph.add(
            .directed,
            from: zero,
            to: one,
            weight: 1.0
        )
        graph.add(
            .directed,
            from: one,
            to: two,
            weight: 2.0
        )
        graph.add(
            .directed,
            from: zero,
            to: two,
            weight: 2.0
        )

        XCTAssertEqual(graph.shortestPath(from: zero, to: two)?.totalWeight, 2)
    }

    func testNoPath_dijkstra() async throws {
        let graph = AdjacencyList<Int>()
        let zero = graph.createVertex(data: 0)
        let one = graph.createVertex(data: 1)
        let two = graph.createVertex(data: 2)
        graph.add(
            .directed,
            from: zero,
            to: one,
            weight: 1.0
        )
        graph.add(
            .directed,
            from: two,
            to: one,
            weight: 2.0
        )

        XCTAssertNil(graph.shortestPath(from: zero, to: two))
    }

    func testShortestPath_bfs() async throws {
        let graph = AdjacencyList<Int>()
        let zero = graph.createVertex(data: 0)
        let one = graph.createVertex(data: 1)
        let two = graph.createVertex(data: 2)
        graph.add(
            .directed,
            from: zero,
            to: one
        )
        graph.add(
            .directed,
            from: one,
            to: two
        )
        graph.add(
            .directed,
            from: zero,
            to: two
        )

        // Paths returned by BFS include start vertex
        XCTAssertEqual(graph.bfs(from: zero, to: two).count, 2)
    }

    func testNoPath_bfs() async throws {
        let graph = AdjacencyList<Int>()
        let zero = graph.createVertex(data: 0)
        let one = graph.createVertex(data: 1)
        let two = graph.createVertex(data: 2)
        graph.add(
            .directed,
            from: zero,
            to: one,
            weight: 1.0
        )
        graph.add(
            .directed,
            from: two,
            to: one,
            weight: 2.0
        )

        XCTAssertEqual(graph.bfs(from: zero, to: two).count, 0)
    }

}
