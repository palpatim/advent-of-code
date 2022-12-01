import XCTest
import utils
@testable import day01

final class day01Tests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("part1.sample.txt", countingTopN: 1)
        XCTAssertEqual(actual, 24000)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("part1.real.txt", countingTopN: 1)
        XCTAssertEqual(actual, 74394)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("part2.sample.txt", countingTopN: 3)
        XCTAssertEqual(actual, 45000)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("part2.real.txt", countingTopN: 3)
        XCTAssertEqual(actual, 212836)
    }

}

// MARK: - Solution

class Solution {
    static func solve(
        _ fileName: String,
        countingTopN n: Int = 1
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw ParsingError("Unable to open \(fileName)")
        }

        var currentCarrier = CalorieCarrier()
        let carriers = PriorityQueue<CalorieCarrier> { a, b in
            a.calorieTotal > b.calorieTotal
        }

        for line in try String.lines(fromFile: fileURL) {
            guard line.isEmpty else {
                let item = Int(line)!
                currentCarrier.append(item)
                continue
            }
            carriers.enqueue(currentCarrier)
            currentCarrier = CalorieCarrier()
        }

        carriers.enqueue(currentCarrier)

        var total = 0
        for _ in 0 ..< n {
            guard let top = carriers.dequeue() else {
                continue
            }
            total += top.calorieTotal
        }
        return total
    }

}

// MARK: - Structures
struct CalorieCarrier {
    var calorieTotal = 0
    var items = [Int]()
    init(items: [Int] = []) {
        self.items = items
        self.calorieTotal = items.reduce(0, +)
    }

    mutating func append(_ item: Int) {
        items.append(item)
        calorieTotal += item
    }
}

extension CalorieCarrier: Hashable { }

// MARK: - Errors

struct ParsingError: Error {
    let message: String
    let underlyingError: Error?

    init(_ message: String, _ underlyingError: Error? = nil) {
        self.message = message
        self.underlyingError = underlyingError
    }
}
