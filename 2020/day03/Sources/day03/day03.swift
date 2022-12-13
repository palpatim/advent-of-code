public enum day03 {
    public static func solvePart1(_ input: String) -> Int {
        let terrainMap = parseInput(input)
        let pattern = TraversalPattern(right: 3, down: 1)
        let count = traverseAndCountObstacles(terrainMap, pattern: pattern)
        return count
    }

    public static func solvePart2(_ input: String) -> Int {
        let terrainMap = parseInput(input)
        let product = [
            TraversalPattern(right: 1, down: 1),
            TraversalPattern(right: 3, down: 1),
            TraversalPattern(right: 5, down: 1),
            TraversalPattern(right: 7, down: 1),
            TraversalPattern(right: 1, down: 2),
        ]
        .map { traverseAndCountObstacles(terrainMap, pattern: $0) }
        .reduce(1, *)
        return product
    }

    private static func parseInput(_ input: String) -> TerrainMap {
        let inputLines = input.split(separator: "\n")
        let terrainMap = inputLines.map { parseLine(String($0)) }
        return terrainMap
    }

    private static func parseLine(_ line: String) -> TerrainMapRow {
        let result = line.map { $0 == "#" }
        return result
    }

    // Assumes a rectangular grid
    private static func traverseAndCountObstacles(
        _ terrainMap: TerrainMap,
        pattern: TraversalPattern
    ) -> Int {
        let mapHeight = terrainMap.count
        let mapWidth = terrainMap[0].count
        var currentRowIndex = 0
        var currentColIndex = 0
        var obstacleCount = 0
        while currentRowIndex < (mapHeight - pattern.down) {
            currentRowIndex += pattern.down
            let currentRow = terrainMap[currentRowIndex]
            currentColIndex = (currentColIndex + pattern.right) % mapWidth
            let currentCell = currentRow[currentColIndex]
            if currentCell {
                obstacleCount += 1
            }
        }

        return obstacleCount
    }
}

public struct TraversalPattern {
    // Assume pattern is right, then down
    let right: Int
    let down: Int
}

typealias TerrainMapRow = [Bool]
typealias TerrainMap = [TerrainMapRow]
