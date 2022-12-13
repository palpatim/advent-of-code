//
//  Grid.swift
//
//
//  Created by Schmelter, Tim on 12/17/21.
//

public struct Grid<Value> {
    public internal(set) var cells: [Coordinate: Value]

    // Overloading a Coordinate to store the gridSize since non-nominal types cannot conform to
    // protocols
    private let _gridSize: Coordinate
    public var gridSize: (height: Int, width: Int) {
        (height: _gridSize.y, width: _gridSize.x)
    }

    public init(rows: [[Value]]) throws {
        let height = rows.count
        let width = rows[0].count
        _gridSize = .xy(width, height)

        var cells = [Coordinate: Value]()

        for (y, row) in rows.enumerated() {
            guard row.count == width else {
                throw GridError.inconsistentSize(
                    message: "Row \(y) has width \(row.count), expected \(width)"
                )
            }
            for (x, cell) in row.enumerated() {
                cells[.xy(x, y)] = cell
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

        _gridSize = .xy(maxX + 1, maxY + 1)
    }

    /// Creates a grid from discontiguous cells.
    ///
    /// This method creates a grid from 0,0 to the bottom-rightmost coordinate. Any coordinates that don't have
    /// a specified value will be filled in with
    /// - Parameters:
    ///   - discontiguousCells: map of coordinates to values used to construct the populated portions of the grid
    ///   - empty: value to fill for cells without a specified entry
    public init(
        discontiguousCells: [Coordinate: Value],
        fillingEmptyCellsWith empty: Value
    ) {
        let cellsMinX = discontiguousCells
            .keys
            .map { $0.x }
            .min()!
        let minX = min(0, cellsMinX)

        let maxX = discontiguousCells
            .keys
            .map { $0.x }
            .max()!

        let cellsMinY = discontiguousCells
            .keys
            .map { $0.y }
            .min()!
        let minY = min(0, cellsMinY)

        let maxY = discontiguousCells
            .keys
            .map { $0.y }
            .max()!

        var cells = [Coordinate: Value]()

        for y in minY ... maxY {
            for x in minX ... maxX {
                let coord = Coordinate(x: x, y: y)
                cells.updateValue(discontiguousCells[coord] ?? empty, forKey: coord)
            }
        }
        _gridSize = .xy(maxX - minX + 1, maxY - minY + 1)
        self.cells = cells
    }
}

public enum GridError: Error {
    case inconsistentSize(message: String)
    case discontiguousCells(message: String)
}

extension Grid: Equatable where Value: Equatable {}

extension Grid: Hashable where Value: Hashable {}
