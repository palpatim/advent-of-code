import XCTest
import utils

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .totalVisible)
        XCTAssertEqual(actual, 21)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .totalVisible)
        XCTAssertEqual(actual, 1711)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .scenicScore)
        XCTAssertEqual(actual, 8)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .scenicScore)
        XCTAssertEqual(actual, 301392)
    }

}

// MARK: - Solution

enum Strategy {
    case totalVisible
    case scenicScore
}

class Solution {
    static func solve(
        _ fileName: String,
        strategy: Strategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var rows = [[Int]]()
        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }
            let chars = Array(line)
            let row = chars.map { Int(String($0))! }
            rows.append(row)
        }

        let grid: Grid<Int>
        do {
            grid = try Grid(rows: rows)
        } catch {
            fatalError(error.localizedDescription)
        }

        switch strategy {
        case .totalVisible: return solveForVisibleCells(grid: grid)
        case .scenicScore: return solveForScenicScore(grid: grid)
        }
    }

    static func solveForScenicScore(grid: Grid<Int>) -> Int {
        grid
            .cellArray
            .map { scenicScore(for: $0, in: grid) }
            .max()!
    }

    static func scenicScore(
        for cell: Grid<Int>.Cell,
        in grid: Grid<Int>
    ) -> Int {
        var distances = [Int]()
        for traversalDirection in Direction.cardinal {
            var distance = 0
            for neighbor in grid.cells(startingWith: cell, moving: traversalDirection) {
                guard neighbor.coordinate != cell.coordinate else {
                    continue
                }
                distance += 1
                if neighbor.value >= cell.value {
                    break
                }
            }
            distances.append(distance)
        }
        return distances.reduce(1, *)
    }

    static func solveForVisibleCells(grid: Grid<Int>) -> Int {
        var visibleCoordinates = Set<Coordinate>()

        visibleCoordinates.formUnion(
            getVisibleCoordinates(
                starting: grid.topLeft!,
                in: grid,
                edgeTraversalDirection: .e,
                sightlineDirection: .s
            )
        )

        visibleCoordinates.formUnion(
            getVisibleCoordinates(
                starting: grid.topLeft!,
                in: grid,
                edgeTraversalDirection: .s,
                sightlineDirection: .e
            )
        )

        visibleCoordinates.formUnion(
            getVisibleCoordinates(
                starting: grid.bottomRight!,
                in: grid,
                edgeTraversalDirection: .n,
                sightlineDirection: .w
            )
        )

        visibleCoordinates.formUnion(
            getVisibleCoordinates(
                starting: grid.bottomRight!,
                in: grid,
                edgeTraversalDirection: .w,
                sightlineDirection: .n
            )
        )

        return visibleCoordinates.count
    }

    static func getVisibleCoordinates(
        starting startingCell: Grid<Int>.Cell,
        in grid: Grid<Int>,
        edgeTraversalDirection: Direction,
        sightlineDirection: Direction
    ) -> Set<Coordinate> {
        var visibleCoordinates = Set<Coordinate>()

        for edgeCell in grid.cells(startingWith: startingCell, moving: edgeTraversalDirection) {
            var currentMax = -1
            for interiorCell in grid.cells(startingWith: edgeCell, moving: sightlineDirection) {
                if interiorCell.value > currentMax {
                    visibleCoordinates.insert(interiorCell.coordinate)
                    currentMax = interiorCell.value
                }
            }
        }

        return visibleCoordinates
    }

}

// MARK: - Extensions

extension Grid where Value: Comparable {

}
