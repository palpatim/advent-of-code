import Foundation

public struct day15 {
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

        let grid = Grid(rows: nodes)
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

public class Node<Value: Hashable> {
    private let id: UUID
    public let value: Value
    public private(set) var neighbors: Set<Node<Value>>

    public init(_ value: Value) {
        self.id = UUID()
        self.value = value
        self.neighbors = []
    }

    /// Sets up a bi-directional link between the receiver and `neighbor`.
    public func link(to neighbor: Node<Value>) {
        neighbors.insert(neighbor)
        neighbor.neighbors.insert(self)
    }
}

extension Node: Equatable {
    public static func ==(_ lhs: Node, _ rhs: Node) -> Bool {
        lhs.id == rhs.id
    }
}

extension Node: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension Node {
    public func shortestDistance(
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

extension Node: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(value): \(neighbors.map({"\($0.value)"}).joined(separator: ","))"
    }
}

public struct PriorityHolder: Hashable {
    let node: Node<Int>
    let tentativeDistance: Int
}

public struct Grid<Value> {
    let cells: [Coordinate: Value]
    let gridSize: (height: Int, width: Int)

    public init(rows: [[Value]]) {
        self.gridSize = (height: rows.count, width: rows[0].count)

        var cells = [Coordinate: Value]()
        for (y, row) in rows.enumerated() {
            for (x, cell) in row.enumerated() {
                cells[Coordinate(x: x, y: y)] = cell
            }
        }

        self.cells = cells
    }

    public init(cells: [Coordinate: Value]) {
        self.cells = cells
        let maxX = cells
            .keys
            .map { $0.x }
            .max()!

        let maxY = cells
            .keys
            .map { $0.y }
            .max()!

        self.gridSize = (height: maxY + 1, width: maxX + 1)
    }
}

public extension Grid {
    /// Return value for accessors
    struct Cell {
        let coordinate: Coordinate
        let value: Value
    }

    func cell(at coordinate: Coordinate) -> Cell? {
        guard let value = cells[coordinate] else {
            return nil
        }

        return Cell(coordinate: coordinate, value: value)
    }

    /// Returns the cell at 0,0, if any
    var topLeft: Cell? {
        cell(at: Coordinate(x: 0, y: 0))
    }

    /// Returns the cell at the bottom right of the grid, if any
    var bottomRight: Cell? {
        let bottomRightCoord = Coordinate(
            x: gridSize.width - 1,
            y: gridSize.height - 1
        )
        return cell(at: bottomRightCoord)
    }
}

public struct Coordinate: Hashable {
    let x: Int
    let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init(stringValue: String) {
        let components = stringValue.components(separatedBy: ",")
        self.x = Int(components[0])!
        self.y = Int(components[1])!
    }

    func applying(_ offset: Offset) -> Coordinate {
        Coordinate(x: x + offset.x, y: y + offset.y)
    }
}

extension Coordinate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(x),\(y))"
    }
}

public struct Offset {
    let x: Int
    let y: Int
}

public enum Direction: CaseIterable {
    case n, ne, e, se, s, sw, w, nw

    public static var cardinal: [Direction] {
        [.n, .e, .s, .w]
    }
}

public extension Direction {
    /// Returns an Offset of magnitude 1 along each axis
    var unitOffset: Offset {
        switch self {
        case .n: return Offset(x: 0, y: -1)
        case .ne: return Offset(x: 1, y: -1)
        case .e: return Offset(x: 1, y: 0)
        case .se: return Offset(x: 1, y: 1)
        case .s: return Offset(x: 0, y: 1)
        case .sw: return Offset(x: -1, y: 1)
        case .w: return Offset(x: -1, y: 0)
        case .nw: return Offset(x: -1, y: -1)
        }
    }
}

// Heap-based PriorityQueue, adapted from
// https://stackoverflow.com/questions/42919469/efficient-way-to-implement-priority-queue-in-javascript/42919752#42919752
public class PriorityQueue<Value: Hashable> {
    public typealias Comparator = (Value, Value) -> Bool

    private var heap: [Value]
    private let comparator: Comparator

    public init(prioritizingWith comparator: @escaping Comparator) {
        self.heap = []
        self.comparator = comparator
    }

    public var count: Int {
        heap.count
    }

    public var isEmpty: Bool {
        heap.isEmpty
    }

    public func peek() -> Value? {
        heap.first
    }

    public func append(_ value: Value) {
        heap.append(value);
        siftUp();
    }

    public func dequeue() -> Value? {
        guard !isEmpty else {
            return nil
        }

        guard count > 1 else {
            return heap.removeLast()
        }

        heap.swapAt(0, count - 1)
        let result = heap.removeLast()
        siftDown()
        return result
    }

    public func enqueue(_ element: Value) {
        heap.append(element)
        siftUp()
    }

    public func contains(_ element: Value) -> Bool {
        heap.contains(element)
    }

    // Internal helpers

    private func parentIndex(of index: Int) -> Int {
        (index - 1) >> 1
    }

    private func leftChildIndex(of index: Int) -> Int {
        (index << 1) + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        (index << 1) + 2
    }

    private func isHigherPriority(at source: Int, than comparison: Int) -> Bool {
        let validRange = 0 ..< count
        guard validRange.contains(source), validRange.contains(comparison) else {
            return false
        }
        let lhs = heap[source]
        let rhs = heap[comparison]
        return comparator(lhs, rhs)
    }

    private func highestPriorityIndexOf(_ lhs: Int, _ rhs: Int) -> Int {
        let validRange = 0 ..< count
        guard validRange.contains(lhs), validRange.contains(rhs) else {
            if validRange.contains(lhs) {
                return lhs
            } else if validRange.contains(rhs) {
                return rhs
            } else {
                fatalError("Indexes out of range: \(lhs), \(rhs)")
            }
        }

        if isHigherPriority(at: lhs, than: rhs) {
            return lhs
        } else {
            return rhs
        }
    }

    private func siftUp() {
        siftUp(from: heap.count - 1)
    }

    private func siftUp(from index: Int) {
        var current = index
        var parent = parentIndex(of: current)
        while current > 0 && isHigherPriority(at: current, than: parent) {
            heap.swapAt(current, parent)
            current = parent
            parent = parentIndex(of: current)
        }
    }

    private func siftDown() {
        siftDown(from: 0)
    }

    private func siftDown(from index: Int) {
        var current = index
        var leftIndex = leftChildIndex(of: current)
        var rightIndex = rightChildIndex(of: current)

        while
            (leftIndex < count && isHigherPriority(at: leftIndex, than: current))
                || (rightIndex < count && isHigherPriority(at: rightIndex, than: current))
        {
            let maxChildIndex = highestPriorityIndexOf(leftIndex, rightIndex)
            heap.swapAt(current, maxChildIndex)

            current = maxChildIndex
            leftIndex = leftChildIndex(of: current)
            rightIndex = rightChildIndex(of: current)
        }
    }
}
