import XCTest
import utils

final class aocTests: XCTestCase {
    func testAdditionalShortCount() async throws {
        XCTAssertEqual(
            Solution.processRawSignal("bvwbjplbgvbhsrlpgdmjqwftvncz", uniqueCount: 4),
            5
        )

        XCTAssertEqual(
            Solution.processRawSignal("nppdvjthqldpwncqszvftbrmjlhg", uniqueCount: 4),
            6
        )

        XCTAssertEqual(
            Solution.processRawSignal("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", uniqueCount: 4),
            10
        )

        XCTAssertEqual(
            Solution.processRawSignal("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", uniqueCount: 4),
            11
        )
    }

    func testAdditionalLongCount() async throws {
        XCTAssertEqual(
            Solution.processRawSignal("bvwbjplbgvbhsrlpgdmjqwftvncz", uniqueCount: 14),
            23
        )

        XCTAssertEqual(
            Solution.processRawSignal("nppdvjthqldpwncqszvftbrmjlhg", uniqueCount: 14),
            23
        )

        XCTAssertEqual(
            Solution.processRawSignal("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", uniqueCount: 14),
            29
        )

        XCTAssertEqual(
            Solution.processRawSignal("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", uniqueCount: 14),
            26
        )

    }

    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", uniqueCount: 4)
        XCTAssertEqual(actual, 7)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", uniqueCount: 4)
        XCTAssertEqual(actual, 1282)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", uniqueCount: 14)
        XCTAssertEqual(actual, 19)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", uniqueCount: 14)
        XCTAssertEqual(actual, 3513)
    }

}

// MARK: - Solution

class Solution {
    static func solve(
        _ fileName: String,
        uniqueCount: Int
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let rawSignal = try String(contentsOf: fileURL)
        return processRawSignal(rawSignal, uniqueCount: uniqueCount)
    }

    static func processRawSignal(_ rawSignal: String, uniqueCount: Int) -> Int {
        let signal = Array(rawSignal)
        for idx in 0 ..< signal.count {
            let chars = Set(signal[idx ..< idx + uniqueCount])
            if chars.count == uniqueCount {
                return idx + uniqueCount
            }
        }

        return Int.max
    }
}

// MARK: - Structures
