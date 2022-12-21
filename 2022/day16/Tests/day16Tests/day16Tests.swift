import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", puzzlePart: .first)
        XCTAssertEqual(actual, 1651)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", puzzlePart: .first)
        XCTAssertEqual(actual, 1595)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", puzzlePart: .second)
        XCTAssertEqual(actual, 1707)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", puzzlePart: .second)
        XCTAssertEqual(actual, 2189)
    }
}

// MARK: - Solution

enum PuzzlePart {
    case first
    case second
}

enum Solution {
    static func solve(
        _ fileName: String,
        puzzlePart: PuzzlePart
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var valves = [Valve]()

        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }

            let regex = #/Valve (?<valveIdRef>\w+) has flow rate=(?<valveRateRef>\d+); tunnels? leads? to valves? (?<destIdsRef>.*)/#

            guard let result = line.wholeMatch(of: regex) else {
                fatalError("Unexpected line format: \(line)")
            }

            let valveId = String(result.valveIdRef)
            let valveRate = Int(result.valveRateRef)!
            let destinations = result.destIdsRef.split(separator: ", ").map { String($0) }

            valves.append(Valve(id: valveId, flowRate: valveRate, destinations: destinations))
        }

        // Floyd Warshall to calculate distances.
        var distances = valves
            .reduce(into: [String: [String: Double]]()) { acc, valve1 in
                acc[valve1.id] = valves
                    .reduce(into: [String: Double]()) { acc, valve2 in
                        let distance: Double
                        if valve1 == valve2 {
                            distance = 0
                        } else if valve1.destinations.contains(valve2.id) {
                            distance = 1
                        } else {
                            distance = Double.infinity
                        }
                        acc[valve2.id] = distance
                    }
            }

        for k in valves.map({ $0.id }) {
            for i in valves.map({ $0.id }) {
                for j in valves.map({ $0.id }) {
                    distances[i]![j] = min(distances[i]![j]!, distances[i]![k]! + distances[k]![j]!)
                }
            }
        }

        // Optimization: Don't have to consider zero-flows, just use them as distance
        // modifiers between non-zero valves
        let idsToConsider = valves
            .filter { $0.flowRate > 0 }
            .map { $0.id }
            .toSet()

        // Optimization: Calculate paths as bitmaps. Don't have to consider order since we don't
        // actually have to return the path. The max value for a given set of paths wins. Courtesy
        // of https://github.com/juanplopes/advent-of-code-2022/blob/main/day16.py. Without this,
        // comparing paths takes several minutes.
        let bitmap = idsToConsider
            .sorted()
            .enumerated()
            .reduce(into: [String: Int]()) { bitmap, node in
                bitmap[node.1] = 1 << node.0
            }

        let flowsById = valves
            .reduce(into: [String: Int]()) { acc, el in
                acc[el.id] = el.flowRate
            }

        var fullPaths = [Int: Int]()

        let startingTime = puzzlePart == .first ? 30 : 26

        var stack = [
            State(
                node: "AA",
                timeRemaining: startingTime,
                flowSoFar: 0,
                pathBitmask: 0,
                nodesRemaining: idsToConsider
            ),
        ]

        // DFS through non-zero valves
        var iterationCount = 0
        var pushCount = 0
        while !stack.isEmpty {
            iterationCount += 1
            let state = stack.popLast()!
            // Consider all partial paths, so that we can solve part 2
            fullPaths[state.pathBitmask] = max(fullPaths[state.pathBitmask] ?? 0, state.flowSoFar)

            guard !state.nodesRemaining.isEmpty else {
                continue
            }

            for dest in state.nodesRemaining {
                let newTimeRemaining = state.timeRemaining - Int(distances[state.node]![dest]!) - 1
                guard newTimeRemaining > 0 else {
                    continue
                }

                let newFlow = state.flowSoFar + (newTimeRemaining * flowsById[dest]!)
                let newPath = state.pathBitmask | bitmap[dest]!

                var newNodesRemaining = state.nodesRemaining
                newNodesRemaining.remove(dest)

                let newState = State(
                    node: dest,
                    timeRemaining: newTimeRemaining,
                    flowSoFar: newFlow,
                    pathBitmask: newPath,
                    nodesRemaining: newNodesRemaining
                )

                pushCount += 1
                stack.push(newState)
            }
        }

        let max: Int
        switch puzzlePart {
        case .first:
            max = fullPaths
                .values
                .max()!
        case .second:
            var bestMaxFlow = 0

            for selfPath in fullPaths {
                let selfFlow = selfPath.value
                for elephantPath in fullPaths {
                    guard selfPath.key & elephantPath.key == 0 else {
                        continue
                    }
                    let totalFlow = selfFlow + elephantPath.value
                    if totalFlow > bestMaxFlow {
                        bestMaxFlow = totalFlow
                    }
                }
            }
            max = bestMaxFlow
        }

        return max
    }

    static func pathToBitmask(path: Set<String>, bitmap: [String: Int]) -> Int {
        let result = path
            .map { bitmap[$0] ?? 0 }
            .reduce(0, |)
        return result
    }
}

// MARK: - Structures

struct State: Equatable, Hashable {
    let node: String
    let timeRemaining: Int
    let flowSoFar: Int
    let pathBitmask: Int
    let nodesRemaining: Set<String>
}

struct Valve: Hashable {
    let id: String
    let flowRate: Int
    let destinations: [String]
}

public extension Dictionary where Key == String, Value == [String: Int] {
    func matrixDistance(from start: Key, to end: Key) -> Int {
        self[start]![end]!
    }
}

extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        Set(self)
    }

    func appending(_ newElement: Element) -> Self {
        var new = self
        new.append(newElement)
        return new
    }

    func removing(firstInstanceOf element: Element) -> Self {
        var new = self
        if let idx = new.firstIndex(of: element) {
            new.remove(at: idx)
        }
        return new
    }
}

extension Set {
    func intersects(_ other: Self) -> Bool {
        !intersection(other).isEmpty
    }
}
