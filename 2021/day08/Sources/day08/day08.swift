import Foundation

public enum day08 {
    public static func solve(
        _ input: String,
        countingNumbersIn targets: Set<Int>
    ) -> Int {
        var samples = parseInput(input)
        for index in 0 ..< samples.count {
            samples[index].solve()
        }

        let count = samples
            .map { $0.countDigits(targets) }
            .reduce(0, +)
        return count
    }

    public static func solvePart2(_ input: String) -> Int {
        var samples = parseInput(input)
        for index in 0 ..< samples.count {
            samples[index].solve()
        }

        let sum = samples
            .map { $0.outputValue }
            .reduce(0, +)
        return sum
    }

    private static func parseInput(_ input: String) -> [Sample] {
        let lines = input.components(separatedBy: "\n")
        let samples = lines.map { Sample(inputLine: $0) }
        return samples
    }
}

public struct Sample {
    private let samples: [String]
    private let finalDisplay: [String]
    private var allStrings: [String] {
        samples + finalDisplay
    }

    private var samplesByDigit: [Int: String]
    private var digitsBySample: [String: Int]

    public var outputValue: Int {
        let digits = finalDisplay
            .compactMap { digitsBySample[$0] }
            .compactMap { String($0) }
            .joined()

        return Int(digits)!
    }

    public init(inputLine: String) {
        let components = inputLine.components(separatedBy: " | ")
        samples = components[0]
            .components(separatedBy: " ")
            .map(Sample.normalizeToKey(_:))

        finalDisplay = components[1]
            .components(separatedBy: " ")
            .map(Sample.normalizeToKey(_:))

        samplesByDigit = [:]
        digitsBySample = [:]
    }

    public func countDigits(_ targets: Set<Int>) -> Int {
        var targetStrings = Set<String>()
        for target in targets {
            guard let targetSample = samplesByDigit[target] else {
                continue
            }
            targetStrings.insert(targetSample)
        }

        let matchingSamples = finalDisplay.filter { targetStrings.contains($0) }

        return matchingSamples.count
    }

    private static func normalizeToKey(_ sample: String) -> String {
        let normalized = sample
            .sorted()
            .map(String.init(_:))
            .joined()
        return normalized
    }

    public mutating func solve() {
        // We know 1, 4, 7, 8 by their lengths
        if let candidate = allStrings.first(where: { $0.count == 2 }) {
            samplesByDigit[1] = candidate
        }

        if let candidate = allStrings.first(where: { $0.count == 4 }) {
            samplesByDigit[4] = candidate
        }

        if let candidate = allStrings.first(where: { $0.count == 3 }) {
            samplesByDigit[7] = candidate
        }

        if let candidate = allStrings.first(where: { $0.count == 7 }) {
            samplesByDigit[8] = candidate
        }

        // If we don't have at least 1, 4, and 7, we can't proceed.
        guard
            let one = samplesByDigit[1],
            let four = samplesByDigit[4],
            let seven = samplesByDigit[7]
        else {
            fatalError("Sample doesn't contain 1, 4, and 7")
        }

        // There are 3 digits that use 6 segments: 0, 6, 9. Of those,
        // 0 and 9 share all of 1's segments, but 6 does not.
        // Of 0 and 9, only 9 shares all segments with 4. Find all
        // unique digits of segment length 6, and derive them.
        let length6 = Set(allStrings.filter { $0.count == 6 })
        for s in length6 {
            let set = Set(s)
            guard set.isSuperset(of: Set(one)) else {
                samplesByDigit[6] = s
                continue
            }

            guard set.isSuperset(of: Set(four)) else {
                samplesByDigit[0] = s
                continue
            }

            samplesByDigit[9] = s
        }

        // Make sure we now have at least nine
        guard
            let nine = samplesByDigit[9]
        else {
            fatalError("Sample doesn't contain 9")
        }

        // Of the length 5 digits: only 3 shares all segments with 7. All of 5's segments
        // are contained by 9.
        let length5 = Set(allStrings.filter { $0.count == 5 })
        for s in length5 {
            let set = Set(s)
            if set.isSuperset(of: seven) {
                samplesByDigit[3] = s
                continue
            }

            if Set(nine).isSuperset(of: set) {
                samplesByDigit[5] = s
                continue
            }

            samplesByDigit[2] = s
        }

        digitsBySample = samplesByDigit
            .reduce([String: Int]()) { acc, curr in
                var new = acc
                new[curr.value] = curr.key
                return new
            }
    }
}
