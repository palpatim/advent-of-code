//
//  Grid.swift
//  
//
//  Created by Schmelter, Tim on 12/17/21.
//

public struct Grid<Value> {
    public enum GridError: Error {
        case inconsistentSize(message: String)
        case discontiguousCells(message: String)
    }

    public private(set) var cells: [Coordinate: Value]
    public let gridSize: (height: Int, width: Int)

    public var cellsInOrder: [[Grid.Cell]] {
        var rows = [[Grid.Cell]]()
        for y in 0 ..< gridSize.height {
            var row = [Cell]()
            for x in 0 ..< gridSize.width {
                let coord = Coordinate(x: x, y: y)
                row.append(Cell(coordinate: coord, value: cells[coord]!))
            }
            rows.append(row)
        }
        return rows
    }

    public init(rows: [[Value]]) throws {
        self.gridSize = (height: rows.count, width: rows[0].count)

        var cells = [Coordinate: Value]()

        for (y, row) in rows.enumerated() {
            guard row.count == gridSize.width else {
                throw GridError.inconsistentSize(
                    message: "Row \(y) has width \(row.count), expected \(gridSize.width)"
                )
            }
            for (x, cell) in row.enumerated() {
                cells[Coordinate(x: x, y: y)] = cell
            }
        }

        self.cells = cells
    }

    public init(cells: [Coordinate: Value]) throws {
        self.cells = cells

        let maxX = cells
            .keys
            .map { $0.x }
            .max()!

        let maxY = cells
            .keys
            .map { $0.y }
            .max()!

        for expectedY in 0 ... maxY {
            for expectedX in 0 ... maxX {
                let coord = Coordinate(x: expectedX, y: expectedY)
                guard cells[coord] != nil else {
                    throw GridError.discontiguousCells(
                        message: "No cell \(coord)"
                    )
                }
            }
        }

        self.gridSize = (height: maxY + 1, width: maxX + 1)
    }

    public mutating func setValue(
        for coordinate: Coordinate,
        to value: Value
    ) {
        cells[coordinate] = value
    }
}

extension Grid {
    /// Return value for accessors
    public struct Cell {
        public let coordinate: Coordinate
        public let value: Value
        public init(
            coordinate: Coordinate,
            value: Value
        ) {
            self.coordinate = coordinate
            self.value = value
        }
    }

    public func cell(at coordinate: Coordinate) -> Cell? {
        guard let value = cells[coordinate] else {
            return nil
        }

        return Cell(coordinate: coordinate, value: value)
    }

    /// Returns the cell at 0,0, if any
    public var topLeft: Cell? {
        cell(at: Coordinate(x: 0, y: 0))
    }

    /// Returns the cell at the bottom right of the grid, if any
    public var bottomRight: Cell? {
        let bottomRightCoord = Coordinate(
            x: gridSize.width - 1,
            y: gridSize.height - 1
        )
        return cell(at: bottomRightCoord)
    }
}
