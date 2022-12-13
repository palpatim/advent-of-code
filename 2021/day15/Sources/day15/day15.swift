import Foundation
import utils

public enum day15 {
    public static func solve(
        _ input: String,
        tileCount: Int
    ) -> Int {
        let grid = parseInput(input, tileCount: tileCount)
        let allNodes = Array(grid.cells.values)
        let shortestDistance = grid.topLeft!.value.shortestDistance(
            to: grid.bottomRight!.value,
            considering: allNodes
        )
        return shortestDistance
    }

    public static func parseInput(_ input: String, tileCount: Int) -> Grid<Node<Int>> {
        let lines = input.components(separatedBy: "\n")

        func rollover(_ val: Int) -> Int {
            val > 9 ? 1 : val
        }

        var rows = [[Int]]()
        for line in lines {
            let initialCellCount = line.count
            var row = line.map { Int(character: $0)! }
            for _ in 1 ..< tileCount {
                let tileValues = row.suffix(initialCellCount).map { rollover($0 + 1) }
                row.append(contentsOf: tileValues)
            }
            rows.append(row)
        }

        let initialRowCount = rows.count

        for _ in 1 ..< tileCount {
            for initialValues in rows.suffix(initialRowCount) {
                let tileValues = initialValues.map { rollover($0 + 1) }
                rows.append(tileValues)
            }
        }

        let nodes = rows
            .map { row in row.map { Node($0) } }

        let grid = try! Grid(rows: nodes)
        for (coordinate, node) in grid.cells {
            for direction in Direction.cardinal {
                let offset = direction.unitOffset
                let neighborCoord = coordinate.applying(offset)
                guard let neighbor = grid.cells[neighborCoord] else {
                    continue
                }
                node.link(to: neighbor)
            }
        }

        return grid
    }
}

private extension Int {
    init?(character: Character) {
        self.init(String(character))
    }
}

public struct PriorityHolder: Hashable {
    let node: Node<Int>
    let tentativeDistance: Int
}

public extension Node {
    func shortestDistance(
        to target: Node<Value>,
        considering allNodes: [Node<Value>]
    ) -> Value where Value == Int {
        var visited = Set<Node<Value>>()

        var distanceFromStart = allNodes
            .reduce(into: [:]) { $0[$1] = Int.max }
        distanceFromStart[self] = 0

        let queue = PriorityQueue<PriorityHolder> {
            $0.tentativeDistance < $1.tentativeDistance
        }
        queue.enqueue(PriorityHolder(node: self, tentativeDistance: 0))

        while let nextItem = queue.dequeue() {
            guard !visited.contains(nextItem.node) else {
                continue
            }

            let currentNode = nextItem.node
            let currentDistance = distanceFromStart[currentNode]!
            let unvisitedNeighbors = currentNode
                .neighbors
                .filter { !visited.contains($0) }

            for neighbor in unvisitedNeighbors {
                let oldDistance = distanceFromStart[neighbor]!
                let tentativeDistance = min(oldDistance, currentDistance + neighbor.value)
                distanceFromStart[neighbor] = tentativeDistance
                queue.enqueue(PriorityHolder(node: neighbor, tentativeDistance: tentativeDistance))
            }

            visited.insert(currentNode)

            if visited.contains(target) {
                break
            }
        }

        return distanceFromStart[target]!
    }
}
