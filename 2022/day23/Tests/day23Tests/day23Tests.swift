import utils
import OrderedCollections
import XCTest

let shouldPrettyPrint = false

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .fixedCount(10))
        XCTAssertEqual(actual, 110)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .fixedCount(10))
        XCTAssertEqual(actual, 4000)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .reportEnd)
        XCTAssertEqual(actual, 20)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .reportEnd)
        XCTAssertEqual(actual, 1040)
    }
}

// MARK: - Solution

enum Strategy {
    case fixedCount(Int)
    case reportEnd
}

enum Solution {
    static func solve(
        _ fileName: String,
        strategy: Strategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var cells = Set<Coordinate>()

        let lines = try String.lines(fromFile: fileURL)
        for (rowIndex, row) in lines.enumerated() {
            for (colIndex, value) in row.enumerated() {
                guard value == "#" else {
                    continue
                }
                cells.insert(.xy(colIndex, rowIndex))
            }
        }

        let maxCount: Int
        switch strategy {
        case .fixedCount(let count):
            maxCount = count
        case .reportEnd:
            maxCount = 10_000
        }

        prettyPrint(cells, header: "== Initial State ==")
        var iterations = 0
        for _ in 0 ..< maxCount {
            iterations += 1
            let shouldContinue = evolve(cells: &cells, scanIndex: iterations - 1)
            prettyPrint(cells, header: "== End of round \(iterations) ==")
            guard shouldContinue else {
                break
            }
        }

        switch strategy {
        case .fixedCount:
            let dimensions = dimensions(for: cells)
            let area = (dimensions.width + 1) * (dimensions.height + 1)
            return area - cells.count
        case .reportEnd:
            return iterations
        }
    }

    static func evolve(cells: inout Set<Coordinate>, scanIndex: Int) -> Bool {

        // key is the proposed destination cell, value is an array of Elves who proposed moving
        // to that cell. If the array has only one value, the move succeeds, otherwise it fails
        var proposals = [Coordinate: [Coordinate]]()

        // Step 1:
        for cell in cells {
            // each Elf considers the eight positions adjacent to themself. If no other Elves are in one of those eight positions, the Elf does not do anything during this round.
            guard neighbors(of: cell, in: cells).count > 0 else {
                continue
            }

            // Otherwise, the Elf looks in each of four directions in the following order and proposes moving one step in the first valid direction
            for scanIndex in scanIndex ..< (scanIndex + Scan.allScans.count) {
                let scan = Scan.allScans[scanIndex % Scan.allScans.count]
                let targets = scan.scanDirections
                    .map { cell.applying($0.coordinateOffset) }
                guard cells.intersection(targets).count == 0 else {
                    continue
                }
                let proposal = cell.applying(scan.destination.coordinateOffset)
                proposals[proposal, default: []].append(cell)
                break
            }
        }

        // If no Elves need to move, signal that no more evolutions are needed
        guard !proposals.isEmpty else {
            return false
        }

        // Simultaneously, each Elf moves to their proposed destination tile if they were the only Elf to propose moving to that position. If two or more Elves propose moving to the same position, none of those Elves move.
        for (destination, movers) in proposals {
            guard
                movers.count == 1,
                let mover = movers.first
            else {
                continue
            }
            cells.remove(mover)
            cells.insert(destination)
        }

        return true
    }

    static func boundingRect(
        of cells: Set<Coordinate>
    ) -> (topLeft: Coordinate, bottomRight: Coordinate) {
        let bounds = cells.reduce(into: [String: Int]()) { acc, curr in
            acc["minX"] = min(acc["minX", default: Int.max], curr.x)
            acc["minY"] = min(acc["minY", default: Int.max], curr.y)
            acc["maxX"] = max(acc["maxX", default: Int.min], curr.x)
            acc["maxY"] = max(acc["maxY", default: Int.min], curr.y)
        }

        return (
            topLeft: .xy(bounds["minX"]!, bounds["minY"]!),
            bottomRight: .xy(bounds["maxX"]!, bounds["maxY"]!)
        )
    }

    static func dimensions(for cells: Set<Coordinate>) -> (width: Int, height: Int) {
        let bounds = boundingRect(of: cells)
        return (
            width: bounds.bottomRight.x - bounds.topLeft.x,
            height: bounds.bottomRight.y - bounds.topLeft.y
        )
    }

    static func neighbors(of coordinate: Coordinate, in cells: Set<Coordinate>) -> Set<Coordinate> {
        var neigboringCoordinates = Set(
            Direction
                .allCases
                .map { coordinate.applying($0.coordinateOffset) }
        )
        neigboringCoordinates.formIntersection(cells)
        return neigboringCoordinates
    }

    static func prettyPrint(
        _ cells: Set<Coordinate>,
        header: String? = nil,
        withPadding: Bool = false
    ) {
        guard shouldPrettyPrint else {
            return
        }
        var rows = [String]()
        let bounds = boundingRect(of: cells)

        let topLeftOffset = withPadding ? Direction.nw.coordinateOffset : Offset(x: 0, y: 0)
        let topLeft = bounds.topLeft.applying(topLeftOffset)

        let bottomRightOffset = withPadding ? Direction.se.coordinateOffset : Offset(x: 0, y: 0)
        let bottomRight = bounds.bottomRight.applying(bottomRightOffset)

        for y in topLeft.y ... bottomRight.y {
            var row = [Character]()
            for x in topLeft.x ... bottomRight.x {
                let symbol = cells.contains(.xy(x, y)) ? Character("#") : Character(".")
                row.append(symbol)
            }
            rows.append(String(row))
        }
        if let header {
            print(header)
        }
        print(rows.joined(separator: "\n"))
        print("")
    }
}

// MARK: - Structures

struct Scan {
    static var allScans: [Scan] {
        [.n, .s, .w, .e]
    }

    static let n = Scan(destination: .n, scanDirections: [.n, .ne, .nw])
    static let s = Scan(destination: .s, scanDirections: [.s, .se, .sw])
    static let w = Scan(destination: .w, scanDirections: [.w, .nw, .sw])
    static let e = Scan(destination: .e, scanDirections: [.e, .ne, .se])

    let destination: Direction
    let scanDirections: [Direction]
}
