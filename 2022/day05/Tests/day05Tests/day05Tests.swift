import RegexBuilder
import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .single)
        XCTAssertEqual(actual, "CMZ")
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .single)
        XCTAssertEqual(actual, "NTWZZWHFV")
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .multiple)
        XCTAssertEqual(actual, "MCD")
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .multiple)
        XCTAssertEqual(actual, "BRZGFVBTJ")
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        strategy: MoveStrategy
    ) async throws -> String {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var moves = [StackMove]()
        var stacks = [[Character]](repeating: [], count: 9)
        for line in try String.lines(fromFile: fileURL) {
            if line.starts(with: "move") {
                moves.append(parseMove(from: line, strategy: strategy))
            } else {
                parseStacks(from: line, into: &stacks)
            }
        }

        for move in moves {
            process(move, into: &stacks)
        }

        let topMostItems = stacks
            .filter { !$0.isEmpty }
            .map { $0.last! }

        return String(topMostItems)
    }

    static func process(_ move: StackMove, into stacks: inout [[Character]]) {
        switch move.strategy {
        case .single:
            for _ in 0 ..< move.moveCount {
                let payload = stacks[move.source].popLast()!
                stacks[move.dest].append(payload)
            }
        case .multiple:
            let payload = stacks[move.source].popLast(move.moveCount)
            stacks[move.dest].append(contentsOf: payload)
        }
    }

    static func parseStacks(from line: String, into stacks: inout [[Character]]) {
        guard line.contains("[") else {
            return
        }

        var isParsingStack = false
        var stackIndex = -1
        for (index, char) in line.enumerated() {
            switch char {
            case "[":
                isParsingStack = true
                stackIndex = index / 4
            case "]":
                isParsingStack = false
                stackIndex = -1
            default:
                if isParsingStack {
                    stacks[stackIndex].insert(char, at: 0)
                }
            }
        }
    }

    static func parseMove(from line: String, strategy: MoveStrategy) -> StackMove {
        let moveCountRef = Reference(Int.self)
        let sourceRef = Reference(Int.self)
        let destRef = Reference(Int.self)

        let regex = Regex {
            "move "

            Capture(as: moveCountRef) {
                OneOrMore(.digit)
            } transform: { match in
                Int(match)!
            }

            " from "

            Capture(as: sourceRef) {
                OneOrMore(.digit)
            } transform: { match in
                Int(match)!
            }

            " to "

            Capture(as: destRef) {
                OneOrMore(.digit)
            } transform: { match in
                Int(match)!
            }
        }

        guard let result = line.firstMatch(of: regex) else {
            fatalError("Unexpected move format: \(line)")
        }
        return StackMove(
            source: result[sourceRef] - 1,
            dest: result[destRef] - 1,
            moveCount: result[moveCountRef],
            strategy: strategy
        )
    }
}

// MARK: - Structures

enum MoveStrategy {
    case single
    case multiple
}

struct StackMove {
    let source: Int
    let dest: Int
    let moveCount: Int
    let strategy: MoveStrategy
}

// MARK: - Extensions

extension Array {
    /// Removes and returns the last `count` elements of the collection
    /// - Parameter count: number of elements to remove
    /// - Returns: a SubSequence containing the removed elements
    mutating func popLast(_ count: Int) -> Self.SubSequence {
        let suffix = suffix(count)
        self = Array(prefix(self.count - count))
        return suffix
    }
}
