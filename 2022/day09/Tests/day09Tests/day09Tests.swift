import XCTest
import utils

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", ropeLength: 2)
        XCTAssertEqual(actual, 88)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", ropeLength: 2)
        XCTAssertEqual(actual, 6522)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", ropeLength: 9)
        XCTAssertEqual(actual, 1)
    }

    func testPart2Other() async throws {
        let actual = try await Solution.solve("sample.txt", ropeLength: 10)
        XCTAssertEqual(actual, 36)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", ropeLength: 10)
        XCTAssertEqual(actual, 2717)
    }

}

// MARK: - Solution

class Solution {
    static func solve(
        _ fileName: String,
        ropeLength: Int
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let head = LinkedList(Coordinate(x: 0, y: 0))

        var cur = head
        for _ in 0 ..< ropeLength - 1 {
            cur.next = LinkedList(Coordinate(x: 0, y: 0))
            cur = cur.next!
        }
        var tailVisited = Set([Coordinate(x: 0, y: 0)])

        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }
            let components = line.components(separatedBy: " ")

            let dir = Direction(relativeDirection: components[0])
            let magnitude = Int(components[1])!

            // Process moves
            for _ in 0 ..< magnitude {
                head.value = head.value.applying(dir.unitOffset)
                cur = head
                while
                    cur.next != nil
                {
                    let prev = cur
                    cur = cur.next!
                    if !prev.value.isAdjacent(to: cur.value) {
                        let dir = cur.value.direction(to: prev.value)
                        cur.value = cur.value.applying(dir.unitOffset)
                    }
                    if cur.isTail {
                        tailVisited.insert(cur.value)
                    }
                }
            }
        }

        return tailVisited.count
    }

}

// MARK: - Extensions

extension Direction {
    init(relativeDirection: String) {
        switch relativeDirection {
        case "L": self = .w
        case "R": self = .e
        case "U": self = .n
        case "D": self = .s
        default: fatalError("Unrecognized direction: \(relativeDirection)")
        }
    }
}
