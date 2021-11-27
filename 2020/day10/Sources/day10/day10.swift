import Foundation

public struct day10 {

    public static func solvePart1(
        _ input: String
    ) -> Int {
        let numbers = parseInput(input)
        let result = solvePart1(numbers)
        return result
    }

    public static func solvePart2(
        _ input: String
    ) -> Int {
        let numbers = parseInput(input)
        let seatAdaptor = 0
        let deviceAdaptor = numbers.max()! + 3
        let allAdaptors = [seatAdaptor, deviceAdaptor] + numbers
        return calculatePathsFromMinToMax(numbers: allAdaptors)
    }

    private static func parseInput(_ input: String) -> [Int] {
        let lines = input.components(separatedBy: "\n")
        let numbers = lines.map { Int($0)! }
        return numbers
    }

    private static func solvePart1(_ numbers: [Int]) -> Int {
        // Pre-initialize "3" to 1, to account for the device having a built-in
        // adaptor 3 higher than the max
        var increments = [1: 0, 2: 0, 3: 1]
        var currentSource = 0
        for n in numbers.sorted() {
            let increment = n - currentSource
            increments[increment]! += 1
            currentSource = n
        }
        return increments[1]! * increments[3]!
    }

    private static func calculatePathsFromMinToMax(
        numbers: [Int]
    ) -> Int {
        let root = makeGraph(numbers: numbers)
        let pathCount = root.pathCount
        return pathCount
    }

    private static func makeGraph(numbers: [Int]) -> MemoizingNode<Int> {
        let min = numbers.min()!
        var nodes = [Int: MemoizingNode<Int>]()

        for number in numbers {
            let node = MemoizingNode(number)
            nodes[number] = node
            let upstream = (number - 3 ... number - 1)
            for candidate in upstream {
                guard let upstreamAdapter = nodes[candidate] else {
                    continue
                }
                upstreamAdapter.children.append(node)
                if upstreamAdapter.children.count > 3 {
                    fatalError("Logic error: Shouldn't have more than 3 children")
                }
            }

            let downstream = (number + 1 ... number + 3)
            for candidate in downstream {
                guard let downstreamAdapter = nodes[candidate] else {
                    continue
                }
                node.children.append(downstreamAdapter)
                if node.children.count > 3 {
                    fatalError("Logic error: Shouldn't have more than 3 children")
                }
            }

        }

        return nodes[min]!
    }
}

class MemoizingNode<T> {
    let value: T
    var children: [MemoizingNode<T>]

    // Memoize the path count
    private var _pathCount: Int?
    var pathCount: Int {
        if let _pathCount = _pathCount {
             return _pathCount
        }

        if children.isEmpty {
            _pathCount = 1
            return 1
        }

        _pathCount = children
                .map { $0.pathCount }
                .reduce(0, +)
        return _pathCount!
    }

    public init(_ value: T) {
        self.value = value
        self.children = []
    }
}

extension MemoizingNode: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(value) -> \(children.map { $0.value })"
    }
}
