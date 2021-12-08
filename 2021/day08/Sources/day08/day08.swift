import Foundation

public struct day08 {
    public static func solve(
        _ input: String,
        countingNumbersIn targets: Set<Int>
    ) -> Int {
        let samples = parseInput(input)
        let targetCounts = Set(
            targets.map { Display.digits[$0]!.count }
        )

        let count = samples
            .map { $0.countOfDigitsWithSignalCounts(targetCounts) }
            .reduce(0, +)
        return count
    }

    public static func solvePart2(_ input: String) -> Int {
        return 0
    }

    private static func parseInput(_ input: String) -> [Sample] {
        let lines = input.components(separatedBy: "\n")
        let samples = lines.map { Sample(inputLine: $0) }
        return samples
    }
}

public enum Display {
    public static let digits: [Int: Set<Character>] = [
        0: ["a", "b", "c", "e", "f", "g"],
        1: ["c", "f"],
        2: ["a", "c", "d", "e", "g"],
        3: ["a", "c", "d", "f", "g"],
        4: ["b", "c", "d", "f"],
        5: ["a", "b", "d", "f", "g"],
        6: ["a", "b", "d", "e", "f", "g"],
        7: ["a", "c", "f"],
        8: ["a", "b", "c", "d", "e", "f", "g"],
        9: ["a", "b", "c", "d", "f", "g"],
    ]

    public static let digitsByCharacterSet: [Set<Character>: Int] = {
        let swapped = digits
            .reduce([Set<Character>: Int]()) { acc, curr in
                var new = acc
                new[curr.value] = curr.key
                return new
            }
        return swapped
    }()

    public static let digitsByCharacter: [Character: Set<Int>] = {
        let mapped = digits
            .reduce([Character: Set<Int>]()) { acc, curr in
                var new = acc
                let digit = curr.key
                curr.value.forEach { character in
                    new[character, default: Set<Int>()].insert(digit)
                }

                return new
            }
        return mapped
    }()
}

public struct Sample {
    public let samples: [Set<Character>]
    public let finalDisplay: [Set<Character>]

    public init(inputLine: String) {
        let components = inputLine.components(separatedBy: " | ")
        samples = components[0]
            .components(separatedBy: " ")
            .map { Set($0) }

        finalDisplay = components[1]
            .components(separatedBy: " ")
            .map { Set($0) }
    }

    public func countOfDigitsWithSignalCounts(_ signalCount: Set<Int>) -> Int {
        let count = finalDisplay
            .filter { signalCount.contains($0.count) }
            .count

        return count
    }

    public func deduceFinalOutputValue() -> Int {
        // Find 1, 4, 7, 8
        return 0
    }
}
