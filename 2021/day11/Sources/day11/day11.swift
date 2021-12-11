import Foundation

public struct day11 {
    public static func solvePart1(_ input: String, steps: Int) -> Int {
        let octopusMap = parseInput(input)
        let flashes = octopusMap.evolve(steps)
        return flashes
    }

    public static func solvePart2(_ input: String) -> Int {
        let octopusMap = parseInput(input)
        let cellCount = octopusMap.gridSize.height * octopusMap.gridSize.width

        var steps = 0
        while octopusMap.evolve() != cellCount {
            steps += 1
        }
        return steps + 1
    }

    private static func parseInput(_ input: String) -> OctopusMap {
        let lines = input.components(separatedBy: "\n")
        let rows = lines
            .map { [Octopus](puzzleInputLine: $0) }
        let octopusMap = OctopusMap(rows: rows)
        return octopusMap
    }
}

public class Octopus {
    public static let flashThreshold = 9

    let id: UUID
    var energyLevel: Int
    var neighbors: Set<Octopus>

    var willFlash: Bool {
        energyLevel > Octopus.flashThreshold
    }

    public init(_ energyLevel: Int) {
        self.id = UUID()
        self.energyLevel = energyLevel
        self.neighbors = []
    }

    /// Increment the energy level of all neighbors. Return a set of all neighbors who now exceed the flashThreshold because of this operation. In other words, if neighbor `n` exceeded the threshold prior to being incremented by this operation, they would *not* be included in the returned set
    public func incrementNeighbors() -> Set<Octopus> {
        var nowExceeds = Set<Octopus>()
        for neighbor in neighbors {
            neighbor.energyLevel += 1
            if neighbor.energyLevel == Octopus.flashThreshold + 1 {
                nowExceeds.insert(neighbor)
            }
        }
        return nowExceeds
    }
}

extension Octopus: Equatable {
    public static func ==(_ lhs: Octopus, _ rhs: Octopus) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Octopus: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

public class OctopusMap {
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
        Offset(x: 1, y: -1), // ne
        Offset(x: 1, y: 0), // e
        Offset(x: 1, y: 1), // se
        Offset(x: 0, y: 1), // s
        Offset(x: -1, y: 1), // sw
        Offset(x: -1, y: 0), // w
        Offset(x: -1, y: -1), // nw
    ]

    // Increases space usage, but makes iterating over cells much easier
    let cells: [Coordinate: Octopus]
    let gridSize: (height: Int, width: Int)

    func willFlash() -> [Octopus] {
        cells
            .values
            .filter { ($0 as Octopus).willFlash }
    }

    public init(rows: [[Octopus]]) {
        self.gridSize = (height: rows.count, width: rows[0].count)

        // We could do this in a single pass, but it's easier to read as two passes,
        // one to populate the coordinate map, one to link up the neighbors
        var cells = [Coordinate: Octopus]()
        for (y, row) in rows.enumerated() {
            for (x, cell) in row.enumerated() {
                cells[Coordinate(x: x, y: y)] = cell
            }
        }

        for (coordinate, cell) in cells {
            for offset in neighborOffsets {
                let neighborCoordinate = coordinate.applying(offset)
                guard let neighbor = cells[neighborCoordinate] else {
                    continue
                }
                cell.neighbors.insert(neighbor)
            }
        }

        self.cells = cells
    }

    public func evolve(_ steps: Int) -> Int {
        var flashes = 0
        for step in 0 ..< steps {
            flashes += evolve()
            print("Step \(step):\n\(debugDescription)\n")
        }
        return flashes
    }

    /// Evolves the map by one step, returning the number of flashes
    public func evolve() -> Int {
        incrementAll()
        evaluateFlashes()

        let willFlash = willFlash()
        willFlash.forEach { $0.energyLevel = 0 }

        return willFlash.count
    }

    private func incrementAll() {
        for y in 0 ..< gridSize.height {
            for x in 0 ..< gridSize.width {
                guard let octopus = cells[Coordinate(x: x, y: y)] else {
                    continue
                }
                octopus.energyLevel += 1
            }
        }
    }

    private func evaluateFlashes() {
        var hasFlashed = Set<Octopus>()
        var stack = willFlash()

        while !stack.isEmpty {
            let current = stack.removeLast()
            hasFlashed.insert(current)
            let newFlashes = current.incrementNeighbors()
            let unseenFlashes = newFlashes.filter { !hasFlashed.contains($0) }
            stack.append(contentsOf: unseenFlashes)
        }

    }

}

private extension String.Element {
    var intValue: Int? {
        Int(String(self))
    }
}

private extension Array where Element == Octopus {
    init(puzzleInputLine inputLine: String) {
        let elements = inputLine
            .map { Octopus($0.intValue!) }
        self.init(elements)
    }
}

extension OctopusMap: CustomDebugStringConvertible {
    public var debugDescription: String {
        var outputRows = [String]()
        for y in 0 ..< gridSize.height {
            var row = [String]()
            for x in 0 ..< gridSize.width {
                let val = String(cells[Coordinate(x: x, y: y)]!.energyLevel, radix: 16)
                row.append(val)
            }
            outputRows.append(row.joined())
        }
        return outputRows.joined(separator: "\n")
    }
}
