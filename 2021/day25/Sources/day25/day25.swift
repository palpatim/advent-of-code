import Foundation
import utils
import CloudKit

extension Grid: CustomDebugStringConvertible
where Value == Direction? {
    public var debugDescription: String {
        let rows = cellsInOrder
            .map { r in r.map { c in c.debugDescription }.joined() }
        return rows.joined(separator: "\n")
    }
}

extension Grid.Cell: CustomDebugStringConvertible where Value == Direction? {
    public var debugDescription: String {
        guard let value = value else {
            return "."
        }
        switch value {
        case .e: return ">"
        case .s: return "v"
        case .n: return "^"
        case .w: return "<"
        default: return "?"
        }
    }
}

public struct day25 {
    public static func solve(_ input: String) -> Int {
        var puzzle = parseInput(input)
        var count = 0
        var prevGrid: Grid<Direction?>
//        print("Initial state")
//        print(puzzle.grid)
        repeat {
            count += 1
            prevGrid = puzzle.grid
            puzzle.evolve()
//            print("Step \(count)")
//            print(puzzle.grid)
        } while puzzle.grid != prevGrid
        return count
    }

    public static func parseInput(_ input: String) -> Puzzle {
        let lines = input.components(separatedBy: "\n")
        let rows = lines
            .map { l in l.map { c in Direction(puzzleInput: c) } }
        let puzzle = try! Puzzle(rows)
        return puzzle
    }
}

extension Direction {
    init?(puzzleInput: Character) {
        switch puzzleInput {
        case ">": self = .e
        case "v": self = .s
        default: return nil
        }
    }
}

extension Grid: Equatable where Value: Equatable {
    public static func ==(_ lhs: Grid, _ rhs: Grid) -> Bool {
        return lhs.cells == rhs.cells
    }
}

extension Grid where Value == Direction? {
    public mutating func willTravel(cellAt coordinate: Coordinate) -> Bool {
        guard
            let currentDirection = cells[coordinate],
            currentDirection != nil,
            let nextCoordinate = nextCoordinate(afterCellAt: coordinate),
            let nextValue = cells[nextCoordinate],
            nextValue == nil
        else {
            return false
        }
        return true
    }

    public mutating func travel(cellAt coordinate: Coordinate) {
        guard
            let optionalDirection = cells[coordinate],
            let direction = optionalDirection,
            let nextCoordinate = nextCoordinate(afterCellAt: coordinate),
            let nextValue = cells[nextCoordinate],
            nextValue == nil
        else {
            return
        }

        let originalCoord = coordinate
        setValue(for: originalCoord, to: nil)
        setValue(for: nextCoordinate, to: direction)
    }

    public func nextCoordinate(
        afterCellAt coordinate: Coordinate
    ) -> Coordinate? {
        guard
            let optionalDirection = cells[coordinate],
            let direction = optionalDirection
        else {
            return nil
        }

        var newCoord = coordinate.applying(direction.unitOffset)
        switch newCoord.x {
        case Int.min ..< 0:
            newCoord = Coordinate(x: gridSize.width - 1, y: newCoord.y)
        case gridSize.width ... Int.max:
            newCoord = Coordinate(x: 0, y: newCoord.y)
        default:
            break
        }

        switch newCoord.y {
        case Int.min ..< 0:
            newCoord = Coordinate(x: newCoord.x, y: gridSize.height - 1)
        case gridSize.height ... Int.max:
            newCoord = Coordinate(x: newCoord.x, y: 0)
        default:
            break
        }

        return newCoord
    }

}

public struct Puzzle {
    var grid: Grid<Direction?>
    public init(_ rows: [[Direction?]]) throws {
        self.grid = try Grid(rows: rows)
    }

    public mutating func evolve(_ steps: Int) {
        for _ in 0 ..< steps {
            evolve()
        }
    }

    public mutating func evolve() {
        evolve(direction: .e)
        evolve(direction: .s)
    }

    private mutating func evolve(direction: Direction) {
        let travellers = grid
            .cells
            .filter { $0.value == direction }
            .keys
            .filter { grid.willTravel(cellAt: $0) }

        travellers.forEach { grid.travel(cellAt: $0) }

    }
}

extension Coordinate: Comparable {
    public static func <(_ lhs: Coordinate, _ rhs: Coordinate) -> Bool {
        guard lhs.y != rhs.y else {
            return lhs.x < rhs.x
        }
        return lhs.y < rhs.y
    }
}
