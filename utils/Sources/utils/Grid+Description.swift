//
//  Grid+Description.swift
//
//
//  Created by Schmelter, Tim on 12/14/22.
//

import Foundation

extension Grid: CustomStringConvertible {
    public var description: String {
        description()
    }

    public func description(separatedBy separator: String = "\t") -> String {
        let firstRow = (-1 ..< gridSize.width)
            .map { $0 == -1 ? "" : "\($0)" }
            .joined(separator: separator)

        var rows = [firstRow]
        for row in 0 ..< gridSize.height {
            var rowElements = ["\(row)"]
            for col in 0 ..< gridSize.width {
                let coord = Coordinate(x: col, y: row)
                let element = cells[coord] != nil ? "\(cells[coord]!)" : "nil"
                rowElements.append(element)
            }
            rows.append(rowElements.joined(separator: separator))
        }

        return rows.joined(separator: "\n")
    }

    public func writeDescription(
        separatedBy separator: String = "\t",
        to path: any StringProtocol
    ) throws {
        try description(separatedBy: separator)
            .write(toFile: path, atomically: true, encoding: .utf8)
    }
}
