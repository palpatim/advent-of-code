import Foundation

public final class BinaryTree<Element> {
    public let value: Element

    public weak var parent: BinaryTree<Element>?
    public var left: BinaryTree<Element>?
    public var right: BinaryTree<Element>?

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

public extension BinaryTree {
    enum TraversalOrder {
        case preOrder
        case inOrder
        case postOrder
    }

    func traverse(_ order: TraversalOrder) -> [Element] {
        switch order {
        case .preOrder:
            return preOrderTraversal()
        case .inOrder:
            return inOrderTraversal()
        case .postOrder:
            return postOrderTraversal()
        }
    }

    private func inOrderTraversal() -> [Element] {
        var results = [Element]()

        if let left = left {
            results.append(contentsOf: left.inOrderTraversal())
        }

        results.append(value)

        if let right = right {
            results.append(contentsOf: right.inOrderTraversal())
        }

        return results
    }

    private func preOrderTraversal() -> [Element] {
        var results = [Element]()

        results.append(value)

        if let left = left {
            results.append(contentsOf: left.preOrderTraversal())
        }

        if let right = right {
            results.append(contentsOf: right.preOrderTraversal())
        }

        return results
    }

    private func postOrderTraversal() -> [Element] {
        var results = [Element]()

        if let left = left {
            results.append(contentsOf: left.postOrderTraversal())
        }

        if let right = right {
            results.append(contentsOf: right.postOrderTraversal())
        }

        results.append(value)

        return results
    }

}
