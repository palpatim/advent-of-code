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
        self._gridSize = .xy(width, height)

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

        self._gridSize = .xy(maxX + 1, maxY + 1)
    }

}

public enum GridError: Error {
    case inconsistentSize(message: String)
    case discontiguousCells(message: String)
}

extension Grid: Equatable where Value: Equatable { }

extension Grid: Hashable where Value: Hashable { }
