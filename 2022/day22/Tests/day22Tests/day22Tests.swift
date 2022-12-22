import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, 6032)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, 3590)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, -1)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, -1)
    }
}

// MARK: - Solution

enum BoardShape {
    case plane
    case cube
}

enum Solution {
    static func solve(
        _ fileName: String,
        boardShape: BoardShape = .plane
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var gridLines = [String]()
        var instructions = ""
        var isParsingGridLines = true
        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                isParsingGridLines = false
                continue
            }

            if isParsingGridLines {
                gridLines.append(line)
            } else {
                instructions = line
            }
        }

        var board = Board(gridLines, boardShape: boardShape)

        traverse(&board, following: instructions)
        print(board.grid.description(separatedBy: "", headers: false))
        return board.finalPassword
    }

    static func traverse(
        _ board: inout Board,
        following rawInstructions: String
    ) {
        let instructions = parsePathInstruction(rawInstructions)
        for instruction in instructions {
            switch instruction {
            case .turn(let direction):
                board.turn(direction)
            case .move(let count):
                board.moveForward(count)
            }
        }
    }

    static func parsePathInstruction(_ instructions: String) -> [PathInstruction] {
        var results = [PathInstruction]()
        var partialNumber = [Character]()
        for char in instructions {
            if char.lowercased() == "l" || char.lowercased() == "r" {
                if !partialNumber.isEmpty {
                    let stringValue = String(partialNumber)
                    let moveCount = Int(stringValue)!
                    results.append(.move(moveCount))
                    partialNumber = []
                }
                results.append(.turn(RelativeDirection(rawValue: String(char))!))
            } else {
                partialNumber.append(char)
            }
        }

        if !partialNumber.isEmpty {
            let stringValue = String(partialNumber)
            let moveCount = Int(stringValue)!
            results.append(.move(moveCount))
            partialNumber = []
        }

        return results
    }
}

// MARK: - Structures

enum PathInstruction {
    case move(Int)
    case turn(RelativeDirection)
}

struct Board {
    var grid: Grid<BoardElement>

    let boardShape: BoardShape

    // Precalculate rows & columns for easy horizontal & vertical wrapping (via circular indexing).
    // Grid appears to be set up so that a given column has only one contiguous travel area:
    //  0123456
    // 0    ...
    // 1    ...
    // 2 ......
    // 3 ......
    // 4 ......
    //
    // As opposed to multiples (see that col 0 has two continguous regions:
    //  012345
    // 0   ...
    // 1   ...
    // 2......
    // 3......
    // 4......
    // 5   ...
    // 6......
    // 7......
    //
    // E.g., in the second example column 0 has contiguous regions from row 2-4 and 6-7. We're
    // assuming that's forbidden

    /// The contiguous horizontal travel region for each row of the grid.
    ///
    /// Travel regions include any non-null cell, even if it contains a wall. For example, in this grid:
    /// ```
    ///  012
    /// 0 #.
    /// 1...
    /// ```
    ///
    /// - `contiguousRows[0] == [(1,0), (2,0)]`
    /// - `contiguousRows[1] == [(0,1), (1,1), (2,1)]`
    var contiguousRows: [[Coordinate]]

    /// The contiguous vertical travel region for each column of the grid.
    ///
    /// Travel regions include any non-null cell, even if it contains a wall. For example, in this grid:
    /// ```
    ///  012
    /// 0 #.
    /// 1...
    /// ```
    ///
    /// - `contiguousColumns[0] == [(0,1)]`
    /// - `contiguousColumns[1] == [(1,0), (1,1)]`
    var contiguousColumns: [[Coordinate]]

    var travellerPosition: Coordinate
    var facingDirection: RelativeDirection

    init(_ lines: [String], boardShape: BoardShape) {
        self.boardShape = boardShape

        let rowCount = lines.count
        let colCount = lines.map { $0.count }.max()!

        var cells = [Coordinate: BoardElement]()
        let rawElements = lines.map { Array($0) }
        for y in 0 ... rowCount {
            for x in 0 ... colCount {
                let rawElement = rawElements[nullableIndex: y]?[nullableIndex: x] ?? " "
                let boardElement = BoardElement(rawValue: rawElement)!
                cells[.xy(x, y)] = boardElement
            }
        }

        var grid = try! Grid(cells: cells)
        self.grid = grid

        let travellerPosition = grid
            .cellArray
            .first { $0.value == .open }!
            .coordinate

        self.travellerPosition = travellerPosition
        self.facingDirection = .right
        grid.setValue(for: travellerPosition, to: .travellerPath(facing: .right))

        // Precalculate contiguous regions
        var contiguousRows = [[Coordinate]]()
        for row in grid.rows {
            var contiguousCellsInRow = [Coordinate]()
            for cell in row {
                guard cell.value != .null else {
                    continue
                }
                contiguousCellsInRow.append(cell.coordinate)
            }
            contiguousRows.append(contiguousCellsInRow)
        }
        self.contiguousRows = contiguousRows

        var contiguousColumns = [[Coordinate]]()
        for col in grid.columns {
            var contiguousCellsInColumn = [Coordinate]()
            for cell in col {
                guard cell.value != .null else {
                    continue
                }
                contiguousCellsInColumn.append(cell.coordinate)
            }
            contiguousColumns.append(contiguousCellsInColumn)
        }
        self.contiguousColumns = contiguousColumns
    }

    var finalPassword: Int {
        let rowScore = (travellerPosition.y + 1) * 1_000
        let colScore = (travellerPosition.x + 1) * 4
        let facingScore = RelativeDirection.allCases.firstIndex(of: facingDirection)!
        return rowScore + colScore + facingScore
    }

    mutating func turn(_ leftOrRight: RelativeDirection) {
        facingDirection.turn(oneStep: leftOrRight)
        grid.setValue(for: travellerPosition, to: .travellerPath(facing: facingDirection))
    }

    mutating func moveForward(_ count: Int) {
        let travelArea: [Coordinate]
        let offset: Int
        switch facingDirection {
        case .left, .right:
            travelArea = contiguousRows[travellerPosition.y]
            offset = facingDirection.unitOffset.x
        case .up, .down:
            travelArea = contiguousColumns[travellerPosition.x]
            offset = facingDirection.unitOffset.y
        }

        guard offset != 0 else {
            fatalError("Offset unexpectedly zero")
        }

        var currentIndex = travelArea.firstIndex { $0 == travellerPosition }!
        for _ in 0 ..< count {
            currentIndex += offset
            let destinationCoordinate = travelArea[circular: currentIndex]
            guard
                let cell = grid.cell(at: destinationCoordinate),
                cell.value != .null && cell.value != .wall
            else {
                // Hit an obstruction, revert the index offset so the current index is correct
                currentIndex -= offset
                break
            }
            grid.setValue(for: destinationCoordinate, to: .travellerPath(facing: facingDirection))
        }

        travellerPosition = travelArea[circular: currentIndex]
    }
}

enum BoardElement: RawRepresentable {
    case null, open, wall, travellerPath(facing: RelativeDirection)

    init?(rawValue: Character) {
        switch rawValue.lowercased() {
        case " ": self = .null
        case "#": self = .wall
        case ".": self = .open
        case ">": self = .travellerPath(facing: .right)
        case "v": self = .travellerPath(facing: .down)
        case "<": self = .travellerPath(facing: .left)
        case "^": self = .travellerPath(facing: .up)
        default: return nil
        }
    }

    var rawValue: Character {
        switch self {
        case .null: return " "
        case .open: return "."
        case .wall: return "#"
        case .travellerPath(let facing):
            switch facing {
            case .right: return ">"
            case .down: return "v"
            case .left: return "<"
            case .up: return "^"
            }
        }
    }

}

extension BoardElement: CustomStringConvertible {
    var description: String { String(rawValue) }
}
