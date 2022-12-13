import Foundation

public enum day10 {
    public static func solvePart1(_ input: String) -> Int {
        let lines = parseInput(input)
        return scoreCorrupted(lines: lines)
    }

    public static func solvePart2(_ input: String) -> Int {
        let lines = parseInput(input)
        return scoreIncomplete(lines: lines)
    }

    private static func parseInput(_ input: String) -> [String] {
        let lines = input.components(separatedBy: "\n")
        return lines
    }

    private static func scoreCorrupted(lines: [String]) -> Int {
        let score = lines
            .map { Syntax.score($0) }
            .compactMap {
                guard case let .corrupted(c) = $0 else {
                    return nil
                }
                return Syntax.scoreByIllegalCharacter[c]!
            }
            .reduce(0, +)

        return score
    }

    private static func scoreIncomplete(lines: [String]) -> Int {
        let scores = lines
            .map { Syntax.score($0) }
            .compactMap { score -> Int? in
                guard case let .incomplete(characters) = score else {
                    return nil
                }
                return Syntax.scoreIncomplete(characters: characters)
            }
            .sorted()

        return scores[scores.count / 2]
    }
}

public enum Syntax {
    public enum Score {
        case valid
        case corrupted(Character)
        case incomplete([Character])
    }

    public static let delimiterPairsByOpen: [Character: Character] = [
        "(": ")",
        "[": "]",
        "{": "}",
        "<": ">",
    ]

    public static let delimiterClosers = Set(delimiterPairsByOpen.values)

    public static let scoreByIllegalCharacter: [Character: Int] = [
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137,
    ]

    public static let scoreByIncompleteCharacter: [Character: Int] = [
        ")": 1,
        "]": 2,
        "}": 3,
        ">": 4,
    ]

    public static func score(_ input: String) -> Score {
        var closingCharStack = [Character]()
        for c in input {
            // Skip non-delimiters
            guard
                delimiterClosers.contains(c) ||
                delimiterPairsByOpen[c] != nil
            else {
                continue
            }

            // Push paired closing delimiters for any encountered opening delimiters
            if let closingDelimiter = delimiterPairsByOpen[c] {
                closingCharStack.append(closingDelimiter)
                continue
            }

            // We now know that c must be a closing delimiter
            guard !closingCharStack.isEmpty, c == closingCharStack.removeLast() else {
                return .corrupted(c)
            }
        }

        guard closingCharStack.isEmpty else {
            return .incomplete(closingCharStack.reversed())
        }

        return .valid
    }

    public static func scoreIncomplete(characters: [Character]) -> Int {
        var score = 0
        for c in characters {
            score *= 5
            score += scoreByIncompleteCharacter[c]!
        }
        return score
    }
}

public extension Dictionary where Value: Hashable {
    var valueKeyPairs: [Value: Key] {
        let reversed = reduce([Value: Key]()) { acc, curr in
            var new = acc
            new[curr.value] = curr.key
            return new
        }
        return reversed
    }
}
