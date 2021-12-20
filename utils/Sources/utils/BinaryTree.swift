import Foundation

public final class BinaryTree<Element> {
    public var value: Element

    public weak var parent: BinaryTree<Element>?
    public var left: BinaryTree<Element>?
    public var right: BinaryTree<Element>?

    public var height: Int {
        let selfHeight = left != nil || right != nil ? 1 : 0
        let childHeight = max(left?.height ?? 0, right?.height ?? 0)
        return selfHeight + childHeight
    }

    public var depth: Int {
        guard let parent = parent else {
            return 0
        }
        return 1 + parent.depth
    }

    public var head: BinaryTree<Element> {
        if let parent = parent {
            return parent.head
        }
        return self
    }

    public init(_ value: Element) {
        self.value = value
    }
}

extension BinaryTree: Equatable where Element: Equatable {
    public static func == (lhs: BinaryTree<Element>, rhs: BinaryTree<Element>) -> Bool {
        if lhs.value != rhs.value {
            return false
        }

        let leftSidesAreEqual: Bool
        if let lhsLeft = lhs.left, let rhsLeft = rhs.left {
            leftSidesAreEqual = lhsLeft == rhsLeft
        } else if lhs.left == nil && rhs.left == nil {
            leftSidesAreEqual = true
        } else {
            return false
        }

        if !leftSidesAreEqual {
            return false
        }

        let rightSidesAreEqual: Bool
        if let lhsRight = lhs.right, let rhsRight = rhs.right {
            rightSidesAreEqual = lhsRight == rhsRight
        } else if lhs.right == nil && rhs.right == nil {
            rightSidesAreEqual = true
        } else {
            return false
        }

        return rightSidesAreEqual
    }
}

/// Yes it works but don't do it, since there is no way to get parent references in using regular Codable
/// conformance.
extension BinaryTree: Codable where Element: Codable { }

public extension BinaryTree where Element: Codable {
    static func binaryTree(from jsonData: Data) throws -> BinaryTree<Element> {
        let jsonDecoder = JSONDecoder()
        let tree = try jsonDecoder.decode(BinaryTree<Element>.self, from: jsonData)

        var q = [BinaryTree<Element>]()
        q.append(tree)

        while !q.isEmpty {
            let current = q.removeFirst()

            if let left = current.left {
                left.parent = current
                q.append(left)
            }

            if let right = current.right {
                right.parent = current
                q.append(right)
            }
        }

        return tree
    }
}

extension BinaryTree {
    public enum TraversalOrder {
        case preOrder
        case inOrder
        case postOrder
    }

    private struct TraversalResult {
        let elements: [Element]
        let shouldStop: Bool
    }

    /// Traverse the tree starting with the receiver. Returns elements in the specified order. If the `shouldStop` closure is supplied, it will be invoked for every node. If the closure returns `true`, traversal will stop after that node's value has been appended to the returned list of elements.
    ///
    /// - Parameters:
    ///   - order: the order in which to traverse the tree
    ///   - shouldStop: if specified, stop traversal when this closure returns `true`
    /// - Returns: The elements of the tree in the specified order
    public func traverse(
        _ order: TraversalOrder,
        shouldStop: ((BinaryTree<Element>) -> Bool)? = nil
    ) -> [Element] {

        switch order {
        case .preOrder:
            return preOrderTraversal(shouldStop: shouldStop).elements
        case .inOrder:
            return inOrderTraversal(shouldStop: shouldStop).elements
        case .postOrder:
            return postOrderTraversal(shouldStop: shouldStop).elements
        }
    }

    private func inOrderTraversal(
        shouldStop: ((BinaryTree<Element>) -> Bool)?
    ) -> TraversalResult {
        var elements = [Element]()

        if let left = left {
            let result = left.inOrderTraversal(shouldStop: shouldStop)
            elements.append(contentsOf: result.elements)
            guard !result.shouldStop else {
                let traversalResult = TraversalResult(
                    elements: elements, shouldStop: true
                )
                return traversalResult
            }
        }

        elements.append(value)
        if let shouldStop = shouldStop, shouldStop(self) {
            let traversalResult = TraversalResult(
                elements: elements, shouldStop: true
            )
            return traversalResult

        }

        if let right = right {
            let result = right.inOrderTraversal(shouldStop: shouldStop)
            elements.append(contentsOf: result.elements)
            guard !result.shouldStop else {
                let traversalResult = TraversalResult(
                    elements: elements, shouldStop: true
                )
                return traversalResult
            }
        }

        let traversalResult = TraversalResult(
            elements: elements, shouldStop: false
        )
        return traversalResult
    }

    private func preOrderTraversal(
        shouldStop: ((BinaryTree<Element>) -> Bool)?
    ) -> TraversalResult {
        var elements = [Element]()

        elements.append(value)
        if let shouldStop = shouldStop, shouldStop(self) {
            let traversalResult = TraversalResult(
                elements: elements, shouldStop: true
            )
            return traversalResult

        }

        if let left = left {
            let result = left.preOrderTraversal(shouldStop: shouldStop)
            elements.append(contentsOf: result.elements)
            guard !result.shouldStop else {
                let traversalResult = TraversalResult(
                    elements: elements, shouldStop: true
                )
                return traversalResult
            }
        }

        if let right = right {
            let result = right.preOrderTraversal(shouldStop: shouldStop)
            elements.append(contentsOf: result.elements)
            guard !result.shouldStop else {
                let traversalResult = TraversalResult(
                    elements: elements, shouldStop: true
                )
                return traversalResult
            }
        }

        let traversalResult = TraversalResult(
            elements: elements, shouldStop: false
        )
        return traversalResult
    }

    private func postOrderTraversal(
        shouldStop: ((BinaryTree<Element>) -> Bool)?
    ) -> TraversalResult {
        var elements = [Element]()

        if let left = left {
            let result = left.postOrderTraversal(shouldStop: shouldStop)
            elements.append(contentsOf: result.elements)
            guard !result.shouldStop else {
                let traversalResult = TraversalResult(
                    elements: elements, shouldStop: true
                )
                return traversalResult
            }
        }

        if let right = right {
            let result = right.postOrderTraversal(shouldStop: shouldStop)
            elements.append(contentsOf: result.elements)
            guard !result.shouldStop else {
                let traversalResult = TraversalResult(
                    elements: elements, shouldStop: true
                )
                return traversalResult
            }
        }

        elements.append(value)
        if let shouldStop = shouldStop, shouldStop(self) {
            let traversalResult = TraversalResult(
                elements: elements, shouldStop: true
            )
            return traversalResult

        }

        let traversalResult = TraversalResult(
            elements: elements, shouldStop: false
        )
        return traversalResult
    }

}
