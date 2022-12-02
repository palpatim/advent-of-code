import XCTest
import utils
@testable import day03

final class day03Tests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solvePart1("part1.sample.txt")
        XCTAssertEqual(actual, 157)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solvePart1("part1.real.txt")
        XCTAssertEqual(actual, 8039)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solvePart2("part2.sample.txt")
        XCTAssertEqual(actual, 70)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solvePart2("part2.real.txt")
        XCTAssertEqual(actual, 2510)
    }
}

// MARK: - Solution

class Solution {
    static func solvePart1(
        _ fileName: String
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var sharedItemPriority = 0

        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }

            guard line.count.isMultiple(of: 2) else {
                fatalError("Unexpected line length: \(line)")
            }

            let midpoint = line.count / 2
            let start = line.prefix(midpoint)
            let startChars = Set(start)

            let end = line.suffix(midpoint)
            let endChars = Set(end)

            let sharedItems = startChars.intersection(endChars)

            guard sharedItems.count == 1 else {
                fatalError("""
                Unexpected sharedItems count:
                line: \(line)
                start: \(start)
                end: \(end)
                sharedItems: \(sharedItems)
                """)
            }

            let priority = sharedItems
                .map { $0.rucksackPriority }
                .reduce(0, +)
            sharedItemPriority += Int(priority)
        }

        return sharedItemPriority
    }

    static func solvePart2(
        _ fileName: String
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var sharedItemPriority = 0

        var currentGroup = [String]()

        func solveCurrentGroup() {
            let itemSets = currentGroup
                .map { Set($0) }
            let sharedItems = itemSets[0]
                .intersection(itemSets[1])
                .intersection(itemSets[2])
            let priority = sharedItems
                .map { $0.rucksackPriority }
                .reduce(0, +)
            sharedItemPriority += Int(priority)
        }

        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }

            currentGroup.append(line)

            if currentGroup.count == 3 {
                solveCurrentGroup()
                currentGroup = []
            }
        }

        return sharedItemPriority
    }

}

// MARK: - Structures

extension Character {
    var rucksackPriority: UInt8 {
        // Safe to do this since all incoming chars are ASCII [a-zA-Z]
        let ascii_self = self.asciiValue!

        let ascii_a = Character("a").asciiValue!
        let ascii_z = Character("z").asciiValue!
        let ascii_A = Character("A").asciiValue!

        let priority: UInt8
        if ascii_a <= ascii_self, ascii_self <= ascii_z {
            priority = ascii_self - ascii_a + 1
        } else {
            priority = ascii_self - ascii_A + 27
        }

        return priority
    }
}
