import XCTest
import utils

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", condition: .forwardFromKnownStartingPoint)
        XCTAssertEqual(actual, 31)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", condition: .forwardFromKnownStartingPoint)
        XCTAssertEqual(actual, 380)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", condition: .backwardToUnknownStartingPoint)
        XCTAssertEqual(actual, 29)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", condition: .backwardToUnknownStartingPoint)
        XCTAssertEqual(actual, 375)
    }

}

// MARK: - Solution

enum Condition {
    case forwardFromKnownStartingPoint
    case backwardToUnknownStartingPoint
}

class Solution {
    static func solve(
        _ fileName: String,
        condition: Condition
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let lines = try String.lines(fromFile: fileURL)

        let cellValues = lines.map { Array($0) }
        let grid = try Grid(rows: cellValues)

        let graph = AdjacencyList<Coordinate>()

        // Pre-create vertices and create a map to address them by coordinate
        let verticesByCoordinate = grid
            .cellArray
            .map { $0.coordinate }
            .reduce(into: [:]) { partialResult, coordinate in
                partialResult[coordinate] = graph.createVertex(data: coordinate)
            }

        var start: Vertex<Coordinate>!
        var destinationResolver: ((Vertex<Coordinate>) -> Bool)!

        if condition == .backwardToUnknownStartingPoint {
            destinationResolver = { grid.cell(at: $0.value)?.value == "a" }
        }
        for cell in grid.cellArray {
            if cell.value == "S" {
                if condition == .forwardFromKnownStartingPoint {
                    start = verticesByCoordinate[cell.coordinate]!
                }
            }

            if cell.value == "E" {
                let vertex = verticesByCoordinate[cell.coordinate]!
                switch condition {
                case .backwardToUnknownStartingPoint:
                    start = vertex
                case .forwardFromKnownStartingPoint:
                    destinationResolver = { $0 == vertex }
                }
            }

            for dir in [Direction.n, .s, .e, .w] {
                if
                    let neighbor = grid.cell(dir, of: cell),
                    canTravel(from: cell.value, to: neighbor.value, during: condition),
                    let startVertex = verticesByCoordinate[cell.coordinate],
                    let neighborVertex = verticesByCoordinate[neighbor.coordinate]
                {
                    graph.add(.directed, from: startVertex, to: neighborVertex)
                }
            }
        }

        let totalWeight = graph
            .shortestPath(from: start, stoppingWhen: destinationResolver)!
            .totalWeight

        return Int(totalWeight)
    }

    static func elevation(of character: Character) -> Int {
        switch character {
        case "S": return Int(Character("a").asciiValue!)
        case "E": return Int(Character("z").asciiValue!)
        default: return Int(character.asciiValue!)
        }
    }

    static func canTravel(
        from start: Character,
        to dest: Character,
        during condition: Condition
    ) -> Bool {
        switch condition {
        case .forwardFromKnownStartingPoint:
            return elevation(of: dest) - elevation(of: start) <= 1
        case .backwardToUnknownStartingPoint:
            return elevation(of: start) - elevation(of: dest) <= 1
        }
    }
}

// MARK: - Structures
