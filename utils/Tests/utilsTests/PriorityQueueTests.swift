import XCTest
@testable import utils

final class PriorityQueueTests: XCTestCase {
    func testPriorityQueue() {
        let q = PriorityQueue<Int>(prioritizingWith: <)
        [5, 3, 1, 2, 3, 4].forEach { q.enqueue($0) }

        var result = [Int]()
        while !q.isEmpty {
            result.append(q.dequeue()!)
        }

        XCTAssertEqual(result, [1, 2, 3, 3, 4, 5])
    }

}
