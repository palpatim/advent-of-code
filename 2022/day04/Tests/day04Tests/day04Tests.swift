@testable import day04
import utils
import XCTest

final class day04Tests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve(
            "sample.txt", { a, b in
                a.isSupersetOf(b) || b.isSupersetOf(a)
            }
        )
        XCTAssertEqual(actual, 2)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve(
            "real.txt", { a, b in
                a.isSupersetOf(b) || b.isSupersetOf(a)
            }
        )
        XCTAssertEqual(actual, 496)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt") { $0.overlaps($1) }
        XCTAssertEqual(actual, 4)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt") { $0.overlaps($1) }
        XCTAssertEqual(actual, 847)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        _ overlapComparison: (ClosedRange<Int>, ClosedRange<Int>) -> Bool
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var containsCount = 0
        for line in try String.lines(fromFile: fileURL) {
            let pair = line.components(separatedBy: ",")
            let ranges = pair
                .map { $0.components(separatedBy: "-") }
                .map { Int($0[0])! ... Int($0[1])! }

            if overlapComparison(ranges[0], ranges[1]) {
                containsCount += 1
            }
        }

        return containsCount
    }
}

// MARK: - Extensions

extension ClosedRange<Int> {
    func isSupersetOf(_ other: ClosedRange<Bound>) -> Bool {
        let startContains = lowerBound <= other.lowerBound
        let endContains = other.upperBound <= upperBound
        return startContains && endContains
    }
}

// MARK: - Structures
