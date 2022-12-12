import XCTest
import utils

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, -1)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, -1)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, -1)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, -1)
    }

}

// MARK: - Solution

class Solution {
    static func solve(
        _ fileName: String
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }

        }

        return Int.max
    }

}

// MARK: - Structures
