//
//  PriorityQueue.swift
//
//
//  Created by Schmelter, Tim on 12/17/21.
//

public class PriorityQueue<Value: Hashable> {
    public typealias Comparator = (Value, Value) -> Bool

    private var heap: [Value]
    private let comparator: Comparator

    public init(prioritizingWith comparator: @escaping Comparator) {
        heap = []
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
        heap.append(value)
        siftUp()
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
        while current > 0, isHigherPriority(at: current, than: parent) {
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
