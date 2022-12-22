import utils
import Collections
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", cubeShape: .unfolded, cubeSize: 4)
        XCTAssertEqual(actual, 6032)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", cubeShape: .unfolded, cubeSize: 50)
        XCTAssertEqual(actual, 3590)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", cubeShape: .folded, cubeSize: 4)
        XCTAssertEqual(actual, 5031)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", cubeShape: .folded, cubeSize: 50)
        XCTAssertEqual(actual, -1)
    }
}

// MARK: - Solution

enum CubeShape {
    case unfolded
    case folded
}

enum Solution {
    static func solve(
        _ fileName: String,
        cubeShape: CubeShape,
        cubeSize: Int
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

        var board = Board(gridLines, cubeShape: cubeShape, cubeSize: cubeSize)

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

    let cube: Cube

    var travellerPosition: Coordinate
    var facingDirection: RelativeDirection

    init(_ lines: [String], cubeShape: CubeShape, cubeSize: Int) {
        // We'll use a Cube for navigating
        self.cube = Cube(cubeSize, cubeShape: cubeShape)

        let rowCount = cubeSize * 3
        let colCount = cubeSize * 4

        var cells = [Coordinate: BoardElement]()
        let rawElements = lines.map { Array($0) }
        for y in 0 ... rowCount {
            for x in 0 ... colCount {
                let rawElement = rawElements[nullableIndex: y]?[nullableIndex: x] ?? " "
                let boardElement = BoardElement(rawValue: rawElement)!
                cells[.xy(x, y)] = boardElement
            }
        }

        // We'll store the cells & values in a Grid since it's easy to print and access values by
        // coords
        var grid = try! Grid(cells: cells)
        self.grid = grid

        let travellerPosition = grid
            .cellArray
            .first { $0.value == .open }!
            .coordinate

        self.travellerPosition = travellerPosition
        self.facingDirection = .right
        grid.setValue(for: travellerPosition, to: .travellerPath(facing: .right))
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
        for _ in 0 ..< count {
            let (destination, newDirection) = cube.move(
                from: travellerPosition,
                toward: facingDirection
            )

            guard
                let cell = grid.cell(at: destination),
                cell.value != .null && cell.value != .wall
            else {
                break
            }
            travellerPosition = destination
            facingDirection = newDirection
            grid.setValue(for: travellerPosition, to: .travellerPath(facing: facingDirection))
        }
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

/// A 3D cube
///
/// Orientation is the "up-right-flat" direction for that cube face, unfolded: that is, the
/// direction decreases y, increases x, leaves z unchanged while that cube face is unfolded.
/// We cast it as a unit vector in "absolute" space with the camera positioned looking
/// head-on to the cube:
///
///                1-top
///                  |
///              +---v--+.
///              |`.    | `.
///              |  `+--+---+
///     3-left --->  |  | <-|-- 6-right
///              +---+--+   |
///               `. |   `. |
///                 `+--^---+
///                     |
///                   4-front
///
///     2-back is furthest from the camera (not indicated)
///     5-bottom is at the bottom of the cube (not indicated)
///
///
///         increasing Z
///        ↗
///      ╱
///     +━━→ increasing X
///     ┃
///     ↓
///     increasing Y
///
/// Flattened into a grid, a Cube looks like this, where each side is a square grid of `size`:
/// ```
///                 1 1 1 1
///                 1 1 1 1
///                 1 1 1 1
///                 1 1 1 1
/// 2 2 2 2 3 3 3 3 4 4 4 4
/// 2 2 2 2 3 3 3 3 4 4 4 4
/// 2 2 2 2 3 3 3 3 4 4 4 4
/// 2 2 2 2 3 3 3 3 4 4 4 4
///                 5 5 5 5 6 6 6 6
///                 5 5 5 5 6 6 6 6
///                 5 5 5 5 6 6 6 6
///                 5 5 5 5 6 6 6 6
/// ```
///
/// From this, you can see that the first "populated" cell isn't at the top right of the grid
struct Cube {
    struct Face: Equatable {
        let rows: Range<Int>
        let cols: Range<Int>
        let upRightFlatVector: Offset3D

        /// An OrderedSet of grid coordinates that make up the Face.
        ///
        /// The set is ordered starting at the top-leftmost grid coordinate of the face.
        let coordinates: OrderedSet<Coordinate>

        init(rows: Range<Int>, cols: Range<Int>, upRightFlatVector: Offset3D) {
            self.rows = rows
            self.cols = cols
            self.upRightFlatVector = upRightFlatVector

            var coordinates = [Coordinate]()
            for row in rows {
                for col in cols {
                    coordinates.append(.xy(col, row))
                }
            }
            self.coordinates = OrderedSet(coordinates)
        }
    }

    let size: Int
    let cubeShape: CubeShape
    let top: Face
    let back: Face
    let left: Face
    let front: Face
    let bottom: Face
    let right: Face
    var neighbors: [Coordinate: [RelativeDirection: Coordinate]]!

    var allFaces: [Face] {
        [top, back, left, front, bottom, right]
    }

    init(_ size: Int, cubeShape: CubeShape) {
        self.size = size
        self.cubeShape = cubeShape

        top = Face(
            rows: 0 ..< size,
            cols: size * 2 ..< size * 3,
            upRightFlatVector: Offset3D(x: 1, y: 0, z: 1)
        )

        back = Face(
            rows: size ..< size * 2,
            cols: 0 ..< size,
            upRightFlatVector: Offset3D(x: -1, y: -1, z: 0)
        )

        left = Face(
            rows: size ..< size * 2,
            cols: size ..< size * 2,
            upRightFlatVector: Offset3D(x: 0, y: -1, z: -1)
        )

        front = Face(
            rows: size ..< size * 2,
            cols: size * 2 ..< size * 3,
            upRightFlatVector: Offset3D(x: 1, y: -1, z: 0)
        )

        bottom = Face(
            rows: size * 2 ..< size * 3,
            cols: size * 2 ..< size * 3,
            upRightFlatVector: Offset3D(x: 1, y: 0, z: -1)
        )

        right = Face(
            rows: size * 2 ..< size * 3,
            cols: size * 3 ..< size * 4,
            upRightFlatVector: Offset3D(x: 0, y: 1, z: -1)
        )

        self.neighbors = nil
        self.neighbors = Cube.calculateAllNeighbors(for: self)
    }

    static func calculateAllNeighbors(
        for cube: Cube
    ) -> [Coordinate: [RelativeDirection: Coordinate]] {
        var result = [Coordinate: [RelativeDirection: Coordinate]]()

        // Populate all results with naive offsets to catch the inner cells, and the
        // non-wrapping directions of the edge cells
        for face in cube.allFaces {
            for coord in face.coordinates {
                result[coord] = [:]
                for dir in RelativeDirection.allCases {
                    result[coord]![dir] = coord.applying(dir.unitOffset)
                }
            }
        }

        // Fix up edges
        switch cube.cubeShape {
        case .folded: fixEdgeNeighborsInFoldedCube(cube, updating: &result)
        case .unfolded: fixEdgeNeighborsInUnfoldedCube(cube, updating: &result)
        }

        return result
    }

    /// Fix up wrapping edges.
    ///
    /// In order:
    /// 1. top face, top edge
    /// 2. bottom face, bottom edge
    /// 3. top face, left edge
    /// 4. top face, right edge
    /// 5. back face, top edge
    /// 6. back face, bottom edge
    /// 7. back face, left edge
    /// 8. front face, right edge
    /// 9. left face, top edge
    /// 10. left face, bottom edge
    /// 11. bottom face, left edge
    /// 12. right face, right edge
    /// 13. right face, top edge
    /// 14. right face, bottom edge
    ///
    /// ```
    ///     1111
    ///     1111
    ///     1111
    ///     1111
    /// 222233334444
    /// 222233334444
    /// 222233334444
    /// 222233334444
    ///     55556666
    ///     55556666
    ///     55556666
    ///     55556666
    /// ```
    static func fixEdgeNeighborsInUnfoldedCube(
        _ cube: Cube,
        updating result: inout [Coordinate: [RelativeDirection: Coordinate]]
    ) {
        var source = [Coordinate]()
        var destination = [Coordinate]()

        // 1. top face, top edge
        source = cube.top.coordinates.filter { $0.y == cube.top.rows.first! }
        destination = cube.bottom.coordinates.filter { $0.y == cube.bottom.rows.last! }
        updateNeighbors(result: &result, direction: .up, mapping: source, to: destination)

        // 2. bottom face, bottom edge
        updateNeighbors(result: &result, direction: .down, mapping: destination, to: source)

        // 3. top face, left edge
        source = cube.top.coordinates.filter { $0.x == cube.top.cols.first! }
        destination = cube.top.coordinates.filter { $0.x == cube.top.cols.last! }
        updateNeighbors(result: &result, direction: .left, mapping: source, to: destination)

        // 4. top face, right edge
        updateNeighbors(result: &result, direction: .right, mapping: destination, to: source)

        // 5. back face, top edge
        source = cube.back.coordinates.filter { $0.y == cube.back.rows.first! }
        destination = cube.back.coordinates.filter { $0.y == cube.back.rows.last! }
        updateNeighbors(result: &result, direction: .up, mapping: source, to: destination)

        // 6. back face, bottom edge
        updateNeighbors(result: &result, direction: .down, mapping: destination, to: source)

        // 7. back face, left edge
        source = cube.back.coordinates.filter { $0.x == cube.back.cols.first! }
        destination = cube.front.coordinates.filter { $0.x == cube.front.cols.last! }
        updateNeighbors(result: &result, direction: .left, mapping: source, to: destination)

        // 8. front face, right edge
        updateNeighbors(result: &result, direction: .right, mapping: destination, to: source)

        // 9. left face, top edge
        source = cube.left.coordinates.filter { $0.y == cube.left.rows.first! }
        destination = cube.left.coordinates.filter { $0.y == cube.left.rows.last! }
        updateNeighbors(result: &result, direction: .up, mapping: source, to: destination)

        // 10. left face, bottom edge
        updateNeighbors(result: &result, direction: .down, mapping: destination, to: source)

        // 11. bottom face, left edge
        source = cube.bottom.coordinates.filter { $0.x == cube.bottom.cols.first! }
        destination = cube.right.coordinates.filter { $0.x == cube.right.cols.last! }
        updateNeighbors(result: &result, direction: .left, mapping: source, to: destination)

        // 12. right face, right edge
        updateNeighbors(result: &result, direction: .right, mapping: destination, to: source)

        // 13. right face, top edge
        source = cube.right.coordinates.filter { $0.y == cube.right.rows.first! }
        destination = cube.right.coordinates.filter { $0.y == cube.right.rows.last! }
        updateNeighbors(result: &result, direction: .up, mapping: source, to: destination)

        // 14. right face, bottom edge
        updateNeighbors(result: &result, direction: .down, mapping: destination, to: source)
    }

    static func updateNeighbors(
        result: inout [Coordinate: [RelativeDirection: Coordinate]],
        direction: RelativeDirection,
        mapping source: [Coordinate],
        to destination: [Coordinate]
    ) {
        for index in 0 ..< source.count {
            result[source[index]]![direction] = destination[index]
        }
    }

    static func fixEdgeNeighborsInFoldedCube(
        _ cube: Cube,
        updating result: inout [Coordinate: [RelativeDirection: Coordinate]]
    ) {
        fatalError("Not yet implemented")
    }

    /// Returns the Face containing `coordinate`.
    func faceContaining(_ coordinate: Coordinate) -> Face {
        allFaces
            .first { $0.coordinates.contains(coordinate) }!
    }

    func move(
        from coordinate: Coordinate,
        toward direction: RelativeDirection
    ) -> (Coordinate, RelativeDirection) {
        switch cubeShape {
        case .folded:
            return foldedMove(from: coordinate, toward: direction)
        case .unfolded:
            return unfoldedMove(from: coordinate, toward: direction)
        }
    }

    private func foldedMove(
        from: Coordinate,
        toward direction: RelativeDirection
    ) -> (Coordinate, RelativeDirection) {
        fatalError("Not yet implemented")
    }

    private func unfoldedMove(
        from coordinate: Coordinate,
        toward direction: RelativeDirection
    ) -> (Coordinate, RelativeDirection) {
        let destination = neighbors[coordinate]![direction]!
        return (destination, direction)
    }
}
