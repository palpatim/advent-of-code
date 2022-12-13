import Foundation

public enum day09 {
    public static func solvePart1(_ input: String) -> Int {
        let heightMap = parseInput(input)
        let totalRiskLevel = heightMap
            .tiles
            .values
            .filter { $0.isLowPoint }
            .map { $0.riskLevel }
            .reduce(0, +)
        return totalRiskLevel
    }

    public static func solvePart2(_ input: String) -> Int {
        let heightMap = parseInput(input)
        let largestBasinSizes = heightMap
            .basins
            .map { $0.count }
            .sorted { $1 < $0 }
            .prefix(3)

        return largestBasinSizes.reduce(1, *)
    }

    private static func parseInput(_ input: String) -> HeightMap {
        let lines = input.components(separatedBy: "\n")
        let rows = lines
            .map { [FloorTile](puzzleInputLine: $0) }
        let heightMap = HeightMap(rows: rows)
        return heightMap
    }
}

public class FloorTile {
    let id: UUID
    let height: Int
    var neighbors: Set<FloorTile>

    var riskLevel: Int {
        height + 1
    }

    var isLowPoint: Bool {
        neighbors.allSatisfy { $0.height > height }
    }

    public init(_ height: Int) {
        id = UUID()
        self.height = height
        neighbors = []
    }
}

extension FloorTile: Equatable {
    public static func == (_ lhs: FloorTile, _ rhs: FloorTile) -> Bool {
        return lhs.id == rhs.id
    }
}

extension FloorTile: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

public class HeightMap {
    public struct Offset {
        let x: Int
        let y: Int
    }

    public struct Coordinate: Hashable {
        let x: Int
        let y: Int

        func applying(_ offset: Offset) -> Coordinate {
            Coordinate(x: x + offset.x, y: y + offset.y)
        }
    }

    let neighborOffsets = [
        Offset(x: 0, y: -1), // n
        Offset(x: 1, y: 0), // e
        Offset(x: 0, y: 1), // s
        Offset(x: -1, y: 0), // w
    ]

    // Increases space usage, but makes iterating over tiles much easier
    let tiles: [Coordinate: FloorTile]
    let gridSize: (height: Int, width: Int)
    let basins: [Set<FloorTile>]

    public init(rows: [[FloorTile]]) {
        gridSize = (height: rows.count, width: rows[0].count)

        // We could do this in a single pass, but it's easier to read as two passes,
        // one to populate the coordinate map, one to link up the neighbors
        var tiles = [Coordinate: FloorTile]()
        for (y, row) in rows.enumerated() {
            for (x, tile) in row.enumerated() {
                tiles[Coordinate(x: x, y: y)] = tile
            }
        }

        for (coordinate, tile) in tiles {
            for offset in neighborOffsets {
                let neighborCoordinate = coordinate.applying(offset)
                guard let neighbor = tiles[neighborCoordinate] else {
                    continue
                }
                tile.neighbors.insert(neighbor)
            }
        }

        self.tiles = tiles

        var basins = [Set<FloorTile>]()
        var visited = Set<FloorTile>()

        // For each unvisited tile in the map, connect basins
        for tile in tiles.values {
            guard !visited.contains(tile) else {
                continue
            }

            // DFS from current tile to find all members of its basin
            var stack = [tile]
            var currentBasin = Set<FloorTile>()
            while !stack.isEmpty {
                let current = stack.removeLast()
                guard !visited.contains(current) else {
                    continue
                }
                visited.insert(current)

                guard current.height < 9 else {
                    continue
                }

                currentBasin.insert(current)
                let unvisitedNeighbors = current
                    .neighbors
                    .filter { !visited.contains($0) }
                stack.append(contentsOf: unvisitedNeighbors)
            }

            basins.append(currentBasin)
        }

        self.basins = basins
    }
}

private extension String.Element {
    var intValue: Int? {
        Int(String(self))
    }
}

private extension Array where Element == FloorTile {
    init(puzzleInputLine inputLine: String) {
        let elements = inputLine
            .map { FloorTile($0.intValue!) }
        self.init(elements)
    }
}
