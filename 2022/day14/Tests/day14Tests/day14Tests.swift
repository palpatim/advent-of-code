import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", hasFloor: false)
        XCTAssertEqual(actual, 24)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", hasFloor: false)
        XCTAssertEqual(actual, 913)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", hasFloor: true)
        XCTAssertEqual(actual, 93)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", hasFloor: true)
        XCTAssertEqual(actual, 30762)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        hasFloor: Bool
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var rocks = [Coordinate: Contents]()
        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }

            var pointPairs = line.split(separator: " -> ").map { String($0) }
            var startPoint = Coordinate(stringValue: pointPairs.removeFirst())
            while !pointPairs.isEmpty {
                let endPoint = Coordinate(stringValue: pointPairs.first!)
                let segment = rockSegment(from: startPoint, to: endPoint)
                rocks.merge(segment) { current, _ in current }
                startPoint = Coordinate(stringValue: pointPairs.removeFirst())
            }
        }

        let gridBottom = rocks
            .keys
            .map { $0.y }
            .max()!

        if hasFloor {
            let floor = rockSegment(from: .xy(-2000, gridBottom + 2), to: .xy(2000, gridBottom + 2))
            rocks.merge(floor) { current, _ in current }
        }

        let grid = processSandfall(around: rocks)

        let sandCount = grid
            .cells
            .map { $0.value }
            .filter { $0 == .sand }
            .count

        return sandCount
    }

    static func writeGrid(_ grid: Grid<Contents>, slug: String = "") {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = docs.appending(path: "grid\(slug).txt")
        try! grid.writeDescription(to: path.path())
        print("Wrote grid to \(path)")
    }

    static func processSandfall(
        around rocks: [Coordinate: Contents]
    ) -> Grid<Contents> {
        var grid = Grid(discontiguousCells: rocks, fillingEmptyCellsWith: .air)
//        writeGrid(grid, slug: "-start")
        while processSingleSandfall(into: &grid) {
            // Do nothing
        }
        return grid
    }

    /// Returns true if the single sandfall came to rest somewhere on the grid, false if it fell off
    /// the bottom of the grid
    static func processSingleSandfall(
        into grid: inout Grid<Contents>
    ) -> Bool {
        let source = Coordinate(x: 500, y: 0)
        var sandUnit = source

        outer:
            while true
        {
            inner:
                for offset in [Offset.down, .downLeft, .downRight]
            {
                let dest = sandUnit.applying(offset)

                // Sand would fall off the edge of the grid, exit
                if grid.cell(at: dest) == nil {
                    return false
                }

                if canMove(to: dest, in: grid) {
                    sandUnit = sandUnit.applying(offset)
                    continue outer
                }
            }
            grid.setValue(for: sandUnit, to: .sand)

            // Sand can't move, but plugs the source. Record the position but return false to
            // indicate no further moves
            return sandUnit != source
        }
    }

    /// Evaluates whether sand at sandUnit can move by the specified offset.
    ///
    /// Returns true if the sand can move, false otherwise
    static func canMove(
        to dest: Coordinate,
        in grid: Grid<Contents>
    ) -> Bool {
        guard let cell = grid.cell(at: dest) else {
            fatalError("\(dest) is past the edge of the grid")
        }
        return cell.value == .air
    }

    static func rockSegment(
        from: Coordinate,
        to: Coordinate
    ) -> [Coordinate: Contents] {
        if from.x == to.x {
            return verticalRockSegment(from: from, to: to)
        } else {
            return horizontalRockSegment(from: from, to: to)
        }
    }

    static func verticalRockSegment(
        from: Coordinate,
        to: Coordinate
    ) -> [Coordinate: Contents] {
        var rocks = [Coordinate: Contents]()
        let fixedX = from.x
        let start = min(from.y, to.y)
        let end = max(from.y, to.y)
        for y in start ... end {
            rocks[Coordinate(x: fixedX, y: y)] = .rock
        }
        return rocks
    }

    static func horizontalRockSegment(
        from: Coordinate,
        to: Coordinate
    ) -> [Coordinate: Contents] {
        var rocks = [Coordinate: Contents]()
        let fixedY = from.y
        let start = min(from.x, to.x)
        let end = max(from.x, to.x)
        for x in start ... end {
            rocks[Coordinate(x: x, y: fixedY)] = .rock
        }
        return rocks
    }
}

// MARK: - Structures & Extensions

enum Contents: String, CustomStringConvertible {
    case air = "."
    case rock = "#"
    case sand = "o"

    var description: String { rawValue }
}

extension Offset {
    static var down: Offset {
        Offset(x: 0, y: 1)
    }

    static var downLeft: Offset {
        Offset(x: -1, y: 1)
    }

    static var downRight: Offset {
        Offset(x: 1, y: 1)
    }
}
