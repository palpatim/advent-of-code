import Foundation

public enum day13 {
    public enum FoldDirections {
        case horizontal, vertical
    }

    public static func solve(
        _ input: String,
        foldCount: Int
    ) -> Int {
        let puzzle = parseInput(input)
        let instructions = Array(puzzle.foldInstructions.prefix(foldCount))
        let foldedGrid = foldGrid(puzzle: puzzle, foldInstructions: instructions)
        let count = foldedGrid.values.count
        foldedGrid.printGrid()
        return count
    }

    private static func parseInput(_ input: String) -> Puzzle {
        let lines = input.components(separatedBy: "\n")

        var foldInstructions = [Puzzle.FoldInstructions]()
        var coordinates = [String]()

        enum ParseState { case coordinates, foldInstructions }
        var parseState = ParseState.coordinates
        for line in lines {
            switch parseState {
            case .coordinates:
                guard !line.isEmpty else {
                    parseState = .foldInstructions
                    continue
                }
                coordinates.append(line)
            case .foldInstructions:
                let components = line.components(separatedBy: "=")
                if components[0].hasSuffix("x") {
                    foldInstructions.append(.x(Int(components[1])!))
                } else {
                    foldInstructions.append(.y(Int(components[1])!))
                }
            }
        }

        let values = coordinates
            .map { Grid<Bool>.Coordinate(stringValue: $0) }
            .reduce(into: [:]) { values, coordinate in
                values[coordinate] = true
            }

        let grid = Grid(values: values)
        let puzzle = Puzzle(grid: grid, foldInstructions: foldInstructions)
        return puzzle
    }

    private static func foldGrid(
        puzzle: Puzzle,
        foldInstructions: [Puzzle.FoldInstructions]
    ) -> Grid<Bool> {
        let foldedValues = puzzle.grid.values
            .reduce(into: [Grid<Bool>.Coordinate: Bool]()) { values, oldValue in
                var foldedX = oldValue.key.x
                var foldedY = oldValue.key.y

                for instruction in foldInstructions {
                    switch instruction {
                    case let .x(value):
                        foldedX = foldedX > value
                            ? 2 * value - foldedX
                            : foldedX
                    case let .y(value):
                        foldedY = foldedY > value
                            ? 2 * value - foldedY
                            : foldedY
                    }
                }

                let foldedCoordinate = Grid<Bool>.Coordinate(
                    x: foldedX,
                    y: foldedY
                )

                values[foldedCoordinate] = true
            }

        let foldedGrid = Grid<Bool>(values: foldedValues)
        return foldedGrid
    }
}

public struct Puzzle {
    enum FoldInstructions {
        case x(Int)
        case y(Int)
    }

    let grid: Grid<Bool>
    let foldInstructions: [FoldInstructions]
}

public struct Grid<T> {
    let neighborOffsets = [
        Offset(x: 0, y: -1), // n
        Offset(x: 1, y: -1), // ne
        Offset(x: 1, y: 0), // e
        Offset(x: 1, y: 1), // se
        Offset(x: 0, y: 1), // s
        Offset(x: -1, y: 1), // sw
        Offset(x: -1, y: 0), // w
        Offset(x: -1, y: -1), // nw
    ]

    // Might slightly increase space usage over a 2d array,
    // but makes iterating and accessing cells much easier
    let values: [Coordinate: T]
    let gridSize: (height: Int, width: Int)

    public init(rows: [[T]]) {
        gridSize = (height: rows.count, width: rows[0].count)

        // We could do this in a single pass, but it's easier to read as two passes,
        // one to populate the coordinate map, one to link up the neighbors
        var values = [Coordinate: T]()
        for (y, row) in rows.enumerated() {
            for (x, cell) in row.enumerated() {
                values[Coordinate(x: x, y: y)] = cell
            }
        }

        self.values = values
    }

    public init(values: [Coordinate: T]) {
        self.values = values
        let maxX = values
            .keys
            .map { $0.x }
            .max()!

        let maxY = values
            .keys
            .map { $0.y }
            .max()!

        gridSize = (height: maxY + 1, width: maxX + 1)
    }
}

public extension Grid {
    struct Offset {
        let x: Int
        let y: Int
    }
}

public extension Grid {
    struct Coordinate: Hashable {
        let x: Int
        let y: Int

        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }

        public init(stringValue: String) {
            let components = stringValue.components(separatedBy: ",")
            x = Int(components[0])!
            y = Int(components[1])!
        }

        func applying(_ offset: Offset) -> Coordinate {
            Coordinate(x: x + offset.x, y: y + offset.y)
        }
    }
}

public extension Grid {
    func printGrid() {
        var rows = [String]()
        for y in 0 ..< gridSize.height {
            var row = [String]()
            for x in 0 ..< gridSize.width {
                let coordinate = Coordinate(x: x, y: y)
                guard values[coordinate] != nil else {
                    row.append(" ")
                    continue
                }
                row.append("█")
            }
            rows.append(row.joined())
        }

        print(rows.joined(separator: "\n"))
    }
}
