import Foundation
import utils

public struct day18 {
    public static func solve(_ input: String) -> SnailFishNumber {
        let numbers = parseInput(input)
        return numbers[1...].reduce(numbers[0]) { $0 + $1 }
    }

    public static func solvePart2(_ input: String) -> Int {
        let numbers = parseInput(input)
        var maxMagnitude = Int.min
        for outerIndex in 0 ..< numbers.count - 1 {
            let outerNumber = numbers[outerIndex]
            for innerIndex in (outerIndex + 1) ..< numbers.count {
                let innerNumber = numbers[innerIndex]

                var result = outerNumber + innerNumber
                maxMagnitude = max(maxMagnitude, result.magnitude)

                result = innerNumber + outerNumber
                maxMagnitude = max(maxMagnitude, result.magnitude)
            }
        }
        return maxMagnitude
    }

    private static func parseInput(_ input: String) -> [SnailFishNumber] {
        let lines = input.components(separatedBy: "\n")
        let numbers = lines
            .map { SnailFishNumber.fromPuzzleInput($0) }
        return numbers
    }
}

public typealias SnailFishNumber = BinaryTree<Int?>

extension SnailFishNumber {
    public func copy() -> SnailFishNumber {
        let puzzleInput = self.description
        return SnailFishNumber.fromPuzzleInput(puzzleInput)
    }
}

extension SnailFishNumber {
    public static func fromPuzzleInput(_ input: String) -> BinaryTree<Int?> {
        var stack = [SnailFishNumber]()
        for c in input {
            switch c {
            case "[":
                stack.push(SnailFishNumber(nil))
            case "]":
                let current = stack.pop()
                if let last = stack.last {
                    last.addChild(current)
                } else {
                    stack.push(current)
                }
            case ",":
                break
            default:
                let val = Int(String(c), radix: 16)!
                if let last = stack.last {
                    last.addChild(val)
                } else {
                    fatalError("No current tree to store value")
                }
            }
        }

        return stack[0]
    }

    public func addChild(_ element: Element) {
        addChild(BinaryTree<Element>(element))
    }

    public func addChild(_ node: SnailFishNumber) {
        if left == nil {
            left = node
            node.parent = self
        } else if right == nil {
            right = node
            node.parent = self
        } else {
            fatalError("No open values")
        }
    }

    public var magnitude: Int {
        if let value = value {
            return value
        }

        let leftMag = left?.magnitude ?? 0
        let rightMag = right?.magnitude ?? 0

        return (3 * leftMag) + (2 * rightMag)
    }

    func orderedNodes() -> [SnailFishNumber] {
        var result = [SnailFishNumber]()
        _ = traverse(.inOrder) {
            result.append($0)
            return false
        }
        return result
    }

    private func shouldExplode() -> Bool {
        isPairNode && depth >= 4
    }

    private func shouldSplit() -> Bool {
        // Look forward a bit; a number node should only be split after it
        // has been exploded to an appropriate depth
        !isPairNode && value ?? 0 > 9 && depth <= 4
    }

    private func shouldReduce() -> Bool {
        shouldExplode() || shouldSplit()
    }

    private func indexOfNextNodeToReduce(in nodes: [SnailFishNumber]) -> Int? {
        if let explode = nodes.firstIndex(where: { $0.shouldExplode() }) {
            return explode
        }

        return nodes.firstIndex { $0.shouldSplit() }
    }

//    private static func jprint(_ nodes: [SnailFishNumber], tag: String) {
//        var output = [String]()
//
//        for node in nodes {
//            guard let v = node.value else {
//                continue
//            }
//            output.append("(\(v), \(node.depth))")
//        }
//
//        print("\(tag)jprint: [\(output.joined(separator: ", "))]")
//    }

    public func reduce() {
        var nodes = orderedNodes()

        var counter = 0
        while let index = indexOfNextNodeToReduce(in: nodes) {
            let reduceNode = nodes[index]

//            let action = reduceNode.shouldExplode() ? "Explode (depth \(reduceNode.depth))" : "Split"
//            print("Step \(String(format: "%04d", counter))")
//            print("inorder nodes: \(nodes)")
//            print("\(action) idx \(String(format: "%03d", index)) (\(reduceNode))")
//            BinaryTree<Int?>.jprint(nodes, tag: "Start: ")
//            print("Start: \(self)")

            counter += 1
            if reduceNode.shouldExplode() {
                SnailFishNumber.explode(index, in: nodes)
            } else if reduceNode.shouldSplit() {
                SnailFishNumber.split(reduceNode)
            }
            nodes = orderedNodes()

//            BinaryTree<Int?>.jprint(nodes, tag: "Result: ")
//            print("Result: \(self)")
//            print("")
        }
    }

    private static func explode(_ nodeIndex: Int, in nodes: [SnailFishNumber]) {
        let node = nodes[nodeIndex]

        // Index of left child is nodeIndex - 1. We want to stop before that, so we'll
        // use an open range
        let leftStopIndex = nodeIndex - 1
        let leftValue = node.left!.value!

        for index in (0 ..< leftStopIndex).reversed() {
            guard nodes[index].value != nil else {
                continue
            }
            nodes[index].value! += leftValue
            break
        }
        node.left!.parent = nil
        node.left = nil

        // Index of right child is nodeIndex + 1. We want to start after that, so
        // we'll add one to it and clamp it to the max index
        let rightStartIndex = min(nodeIndex + 2, nodes.count - 1)
        let rightValue = node.right!.value!
        for index in rightStartIndex ..< nodes.count {
            guard nodes[index].value != nil else {
                continue
            }
            nodes[index].value! += rightValue
            break
        }
        node.right!.parent = nil
        node.right = nil

        node.value = 0
    }

    private static func split(_ node: SnailFishNumber) {
        let halfValue = node.value! / 2
        node.addChild(SnailFishNumber(halfValue))

        if node.value!.isMultiple(of: 2) {
            node.addChild(SnailFishNumber(halfValue))
        } else {
            node.addChild(SnailFishNumber(halfValue + 1))
        }

        node.value = nil
    }

    public static func +(
        _ lhs: SnailFishNumber,
        _ rhs: SnailFishNumber
    ) -> SnailFishNumber {
        let root = SnailFishNumber(nil)
        root.addChild(lhs.copy())
        root.addChild(rhs.copy())
        root.reduce()
        return root
    }

}


extension SnailFishNumber {
    var isPairNode: Bool {
        left?.value != nil && right?.value != nil
    }

    var leftStringValue: String {
        if let value = left?.value {
            return "\(value)"
        } else {
            return ""
        }
    }

    var rightStringValue: String {
        if let value = right?.value {
            return "\(value)"
        } else {
            return ""
        }
    }

}

extension SnailFishNumber: CustomStringConvertible {
    public var description: String {
        guard let value = value else {
            return "[\(left!.description),\(right!.description)]"
        }

        return "\(value)"
    }
}

struct Puzzle {
    public init(_ input: String) {

    }
}
