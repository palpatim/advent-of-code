import utils
import XCTest

let shouldPrettyPrint: Bool = false

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, 18)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, 373)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", pickingUpSnacks: true)
        XCTAssertEqual(actual, 54)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", pickingUpSnacks: true)
        XCTAssertEqual(actual, 997)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        pickingUpSnacks: Bool = false
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var initialState = [SpacetimeCoordinate: CellContent]()
        let lines = try String.lines(fromFile: fileURL)
        for (y, line) in lines.enumerated() {
            guard !line.isEmpty else {
                continue
            }
            for (x, char) in line.enumerated() {
                let symbol = CellContent(rawValue: char)!
                initialState[.xyt(x, y, 0)] = symbol
            }
        }

        let startPositionX = lines[0].firstIndex(of: ".")!.utf16Offset(in: lines[0])
        let startPosition = Coordinate(x: startPositionX, y: 0)
        let exitPositionX = lines.last!.firstIndex(of: ".")!.utf16Offset(in: lines.last!)
        let exitPosition = Coordinate(x: exitPositionX, y: lines.endIndex - 1)

        let board = Board(startingState: initialState, startPosition: startPosition)
        let startVertex = board.vertexByElement[SpacetimeCoordinate(time: 0, coordinate: startPosition)]!

        let firstPath = board.bfs(from: startVertex) { $0.value.coordinate == exitPosition }
        // Path includes startVertex
        let firstPathLength = firstPath.count - 1

        if !pickingUpSnacks {
            return firstPathLength
        }

        let returnPath = board.bfs(from: firstPath.last!) { $0.value.coordinate == startPosition }
        let returnPathLength = returnPath.count - 1

        let finalPath = board.bfs(from: returnPath.last!) { $0.value.coordinate == exitPosition }
        let finalPathLength = finalPath.count - 1

        return firstPathLength + returnPathLength + finalPathLength
    }

}

// MARK: - Structures

extension Offset {
    static let wait = Offset(x: 0, y: 0)
}

struct BoardCell {
    let coordinate: Coordinate

    /// Array of states by time. Since the blizzards are cyclical, address state at time T by states[T % states.count]
}

class Board: AdjacencyList<SpacetimeCoordinate> {
    let boundingRect: Rect
    var states: [SpacetimeCoordinate: CellContent]
    var selfPosition: Coordinate

    init(startingState: [SpacetimeCoordinate: CellContent], startPosition: Coordinate) {
        self.states = [:]
        self.selfPosition = startPosition
        self.boundingRect = Board.boundingRect(of: startingState.keys.map({$0.coordinate}))
        super.init()

        // Blizzards will cycle on the dimensions of the empty space (total dimension - 1 for each wall)
        let lcm = lcm(boundingRect.width - 2, boundingRect.height - 2)

        var currentState = startingState
        createVertices(in: boundingRect, at: 0)

        for time in 0 ..< lcm {
            states.merge(currentState) { curr, other in curr }
            prettyPrint(at: time, header: "Time \(time)")

            let newState: [SpacetimeCoordinate: CellContent]
            let newTime: Int
            if time == lcm - 1 {
                newState = startingState
                newTime = 0
            } else {
                newState = Board.evolve(currentState, bounds: boundingRect)
                newTime = time + 1
                createVertices(in: boundingRect, at: newTime)
            }
            createEdges(from: currentState, to: newState)
            currentState = newState
        }
    }

    func createVertices(in boundingRect: Rect, at time: Int) {
        for x in boundingRect.topLeft.x ... boundingRect.bottomRight.x {
            for y in boundingRect.topLeft.y ... boundingRect.bottomRight.y {
                let stc = SpacetimeCoordinate(time: time, coordinate: .xy(x, y))
                createVertex(data: stc)
            }
        }
    }

    static func evolve(
        _ state: [SpacetimeCoordinate: CellContent],
        bounds: Rect
    ) -> [SpacetimeCoordinate: CellContent] {
        var newState = [SpacetimeCoordinate: CellContent]()
        for cell in state {
            switch cell.value {
            case .open:
                // Don't need to store open cells -- we'll represent these as 'nil' values within
                // the bounding rect
                continue
            case .wall:
                newState[cell.key.advanced()] = .wall
            case .blizzard(let blizzard):
                for dir in Blizzard.allCases {
                    if blizzard.contains(dir) {
                        let newCoord = cell
                            .key
                            .advanced(
                                withOffsetAndBounds: (
                                    offset: dir.coordinateOffset!,
                                    bounds: bounds
                                )
                            )

                        switch newState[newCoord] {
                        case .none:
                            newState[newCoord] = .blizzard(dir)
                        case .some(let cell):
                            switch cell {
                            case .wall:
                                fatalError("Unexpectedly ran blizzard into a wall")
                            case .open:
                                newState[newCoord] = .blizzard(dir)
                            case .blizzard(var blizzard):
                                blizzard.insert(dir)
                                newState[newCoord] = .blizzard(blizzard)
                            }
                        }
                    }
                }
            }
        }
        return newState
    }

    func createEdges(
        from oldState: [SpacetimeCoordinate: CellContent],
        to newState: [SpacetimeCoordinate: CellContent]
    ) {
        let candidateOffsets = [
            Offset.wait,
            Direction.e.coordinateOffset,
            Direction.s.coordinateOffset,
            Direction.w.coordinateOffset,
            Direction.n.coordinateOffset
        ]

        // Precalculate open cells for each state
        let oldTime = oldState.first!.key.time
        let newTime = newState.first!.key.time

        for y in boundingRect.topLeft.y ... boundingRect.bottomRight.y {
            for x in boundingRect.topLeft.x ... boundingRect.bottomRight.x {
                let oldCoord = SpacetimeCoordinate.xyt(x, y, oldTime)
                guard
                    oldState[oldCoord] == nil || oldState[oldCoord] == .open,
                    let oldVertex = vertexByElement[oldCoord]
                else {
                    continue
                }

                for newCoord in candidateOffsets
                    .map({
                        SpacetimeCoordinate(
                            time: newTime,
                            coordinate: oldCoord.coordinate.applying($0)
                        )
                    })
                {
                    guard
                        newState[newCoord] == nil || newState[newCoord] == .open,
                        let newVertex = vertexByElement[newCoord]
                    else {
                        continue
                    }

                    add(.directed, from: oldVertex, to: newVertex)
                }

            }
        }
    }

    static func boundingRect(
        of cells: any Sequence<Coordinate>
    ) -> Rect {
        let bounds = cells.reduce(into: [String: Int]()) { acc, curr in
            acc["minX"] = min(acc["minX", default: Int.max], curr.x)
            acc["minY"] = min(acc["minY", default: Int.max], curr.y)
            acc["maxX"] = max(acc["maxX", default: Int.min], curr.x)
            acc["maxY"] = max(acc["maxY", default: Int.min], curr.y)
        }

        return Rect(
            topLeft: .xy(bounds["minX"]!, bounds["minY"]!),
            bottomRight: .xy(bounds["maxX"]!, bounds["maxY"]!)
        )
    }

    static func dimensions(
        of rect: Rect
    ) -> (width: Int, height: Int) {
        return (
            width: rect.bottomRight.x - rect.topLeft.x + 1,
            height: rect.bottomRight.y - rect.topLeft.y + 1
        )
    }

    func prettyPrint(
        at time: Int,
        header: String? = nil,
        withPadding: Bool = false
    ) {
        guard shouldPrettyPrint else {
            return
        }
        var rows = [String]()

        let cells = states
            .filter { $0.key.time == time }

        let topLeftOffset = withPadding ? Direction.nw.coordinateOffset : Offset(x: 0, y: 0)
        let topLeft = boundingRect.topLeft.applying(topLeftOffset)

        let bottomRightOffset = withPadding ? Direction.se.coordinateOffset : Offset(x: 0, y: 0)
        let bottomRight = boundingRect.bottomRight.applying(bottomRightOffset)

        for y in topLeft.y ... bottomRight.y {
            var row = [Character]()
            for x in topLeft.x ... bottomRight.x {
                let symbol = cells[.xyt(x, y, time)] ?? .open
                row.append(symbol.rawValue)
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

struct Rect {
    let topLeft: Coordinate
    let bottomRight: Coordinate

    var width: Int {
        bottomRight.x - topLeft.x + 1
    }

    var height: Int {
        bottomRight.y - topLeft.y + 1
    }
}

struct SpacetimeCoordinate: Hashable {
    let time: Int
    let coordinate: Coordinate

    static func xyt(_ x: Int, _ y: Int, _ t: Int) -> SpacetimeCoordinate {
        SpacetimeCoordinate(time: t, coordinate: .xy(x, y))
    }

    /// Returns a new coordinate advanced by one unit of time, and optionally by an offset in space.
    ///
    /// Bounds defines the surrounding wall. We assume that the wall is contiguous and wrap when a coordinate hits the edge. This
    /// is safe because the exits are along the northern and southern walls, and there are no N-S blizzards in the exit columns.
    func advanced(
        withOffsetAndBounds offsetAndBounds: (offset: Offset, bounds: Rect)? = nil
    ) -> SpacetimeCoordinate {
        guard let offsetAndBounds else {
            return SpacetimeCoordinate(time: time + 1, coordinate: coordinate)
        }

        let (offset, bounds) = offsetAndBounds

        let candidateX = coordinate.x + offset.x
        let newX: Int
        switch candidateX {
        case Int.min ..< 1: newX = bounds.bottomRight.x - 1
        case bounds.bottomRight.x ..< Int.max: newX = 1
        default: newX = candidateX
        }

        let candidateY = coordinate.y + offset.y
        let newY: Int
        switch candidateY {
        case Int.min ..< 1: newY = bounds.bottomRight.y - 1
        case bounds.bottomRight.y ..< Int.max: newY = 1
        default: newY = candidateY
        }

        return SpacetimeCoordinate(time: time + 1, coordinate: .xy(newX, newY))
    }
}



struct Blizzard: OptionSet {
    let rawValue: Int
    static let e = Blizzard(rawValue: 1 << 0)
    static let s = Blizzard(rawValue: 1 << 1)
    static let w = Blizzard(rawValue: 1 << 2)
    static let n = Blizzard(rawValue: 1 << 3)
}

extension Blizzard: CaseIterable {
    static var allCases: [Blizzard] {
        [.e, .s, .w, .n]
    }
}

extension Blizzard {
    var coordinateOffset: Offset? {
        switch self {
        case .e: return Direction.e.coordinateOffset
        case .w: return Direction.w.coordinateOffset
        case .s: return Direction.s.coordinateOffset
        case .n: return Direction.n.coordinateOffset
        default: return nil
        }
    }
}

enum CellContent: Hashable {
    // Use this to track entrance & exit. Open cells in the middle of the board may not stay open
    // as the board evolves over time, so we'll just represent those as nil values.
    case open

    // Permanently blocked cells
    case wall

    // Travelling obstacles. A cell may contain more than one blizzard, each travelling in a
    // different direction
    case blizzard(Blizzard)
}

extension CellContent: RawRepresentable {
    init?(rawValue: Character) {
        switch rawValue {
        case ".": self = .open
        case "#": self = .wall
        case ">": self = .blizzard(.e)
        case "v": self = .blizzard(.s)
        case "<": self = .blizzard(.w)
        case "^": self = .blizzard(.n)
        default: return nil
        }
    }

    // Used to pretty-print the grid
    var rawValue: Character {
        switch self {
        case .open: return "."
        case .wall: return "#"
        case .blizzard(.e): return ">"
        case .blizzard(.s): return "v"
        case .blizzard(.w): return "<"
        case .blizzard(.n): return "^"
        default: return "*"
        }
    }
}

func gcd(_ a: Int, _ b: Int) -> Int {
    var tmp = 0
    var maxVal = max(a, b)
    var minVal = min(a, b)

    while minVal != 0 {
        tmp = maxVal
        maxVal = minVal
        minVal = tmp % maxVal
    }
    return maxVal
}

func lcm(_ a: Int, _ b: Int) -> Int {
    return a / gcd(a, b) * b
}
