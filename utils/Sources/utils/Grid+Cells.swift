//
//  Grid+Cells.swift
//
//
//  Created by Schmelter, Tim on 12/12/22.
//

import Foundation

public extension Grid {
    /// Return value for accessors
    struct Cell {
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

    /// The cell at 0,0, if any
    var topLeft: Cell? {
        cell(at: Coordinate(x: 0, y: 0))
    }

    /// The cell at the bottom right (max X, max Y) of the grid
    var bottomRight: Cell? {
        let bottomRightCoord = Coordinate(
            x: gridSize.width - 1,
            y: gridSize.height - 1
        )
        return cell(at: bottomRightCoord)
    }

    /// Return the cell at the specified coordinate, if any
    ///
    /// - Parameter coordinate: the coordinate
    /// - Returns: the cell at the specified coordinate
    func cell(at coordinate: Coordinate) -> Cell? {
        guard let value = cells[coordinate] else {
            return nil
        }

        return Cell(coordinate: coordinate, value: value)
    }

    func cell(at coordinates: Int...) -> Cell? {
        precondition(coordinates.count == 2, "Only two variadic arguments supported")
        return cell(at: .xy(coordinates[0], coordinates[1]))
    }

    /// Return the cell the specified offset away from the starting cell, if any
    ///
    /// - Parameters:
    ///   - offset: the offset
    ///   - startingCell: the starting cell
    /// - Returns: the cell at the specified offset, if any
    func cell(offset: Offset, awayFrom startingCell: Cell) -> Cell? {
        let newCoordinate = startingCell.coordinate.applying(offset)
        return cell(at: newCoordinate)
    }

    /// Return the cell one unit away in the specified direction, if any
    ///
    /// - Parameters:
    ///   - direction: direction to scan
    ///   - cell: starting cell
    func cell(_ direction: Direction, of startingCell: Cell) -> Cell? {
        return cell(offset: direction.unitOffset, awayFrom: startingCell)
    }

    @available(*, deprecated, message: "Use cellArray")
    var cellsInOrder: [[Cell]] {
        var rows = [[Cell]]()
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

    var cellArray: [Cell] {
        var cells = [Cell]()
        for y in 0 ..< gridSize.height {
            for x in 0 ..< gridSize.width {
                let coord = Coordinate(x: x, y: y)
                if let cell = cell(at: coord) {
                    cells.append(cell)
                }
            }
        }
        return cells
    }

    /// Returns an array of cells starting with `start`, moving in `direction`.
    ///
    /// - Parameters:
    ///   - start: starting cell
    ///   - direction: direction to move
    func cells(
        startingWith start: Cell,
        moving direction: Direction
    ) -> [Cell] {
        var result = [start]
        var current = start
        while
            let next = cell(
                offset: direction.unitOffset,
                awayFrom: current
            )
        {
            result.append(next)
            current = next
        }
        return result
    }

    mutating func setValue(
        for coordinate: Coordinate,
        to value: Value
    ) {
        cells[coordinate] = value
    }
}

extension Grid.Cell: Equatable where Value: Equatable {}

extension Grid.Cell: Hashable where Value: Hashable {}
