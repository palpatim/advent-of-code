import Foundation

public enum day14 {
    public static func solve(_ input: String, count: Int) -> Int {
        let puzzle = parseInput(input)
        let result = iterate(puzzle: puzzle, count: count)

        return result.maxCount - result.minCount
    }

    private static func parseInput(_ input: String) -> Puzzle {
        let lines = input.components(separatedBy: "\n")
        enum ParseState { case template, pairRules }
        var parseState = ParseState.template
        var template = ""
        var pairRules = [String: Character]()

        for line in lines {
            switch parseState {
            case .template:
                guard !line.isEmpty else {
                    parseState = .pairRules
                    continue
                }
                template = line
            case .pairRules:
                let components = line.components(separatedBy: " -> ")
                pairRules[components[0]] = components[1].first!
            }
        }

        return Puzzle(template: template, pairRules: pairRules)
    }

    public static func pairs(from string: String) -> [String: Int] {
        var pairs = [String: Int]()
        var currentIndex = string.startIndex
        let stopIndex = string.index(before: string.endIndex)
        while currentIndex < stopIndex {
            let currentChar = string[currentIndex]

            let nextIndex = string.index(after: currentIndex)
            let nextChar = string[nextIndex]

            let pair = "\(currentChar)\(nextChar)"
            pairs[pair, default: 0] += 1

            currentIndex = nextIndex
        }
        return pairs
    }

    public static func characterCounts(
        from pairs: [String: Int],
        derivedFrom string: String
    ) -> [Character: Int] {
        var counts = pairs
            .reduce(into: [Character: Int]()) { acc, curr in
                acc[curr.key.last!, default: 0] += curr.value
            }
        let firstChar = string.first!
        counts[firstChar, default: 0] += 1
        return counts
    }

    private static func iterate(puzzle: Puzzle, count: Int) -> (minCount: Int, maxCount: Int) {
        var pairs = pairs(from: puzzle.template)

        for _ in 0 ..< count {
            var newPairs = [String: Int]()
            let pairsToIterate = pairs
            for (pair, count) in pairsToIterate {
                guard let characterToInsert = puzzle.pairRules[pair] else {
                    continue
                }
                let leftPair = "\(pair.first!)\(characterToInsert)"
                let rightPair = "\(characterToInsert)\(pair.last!)"
                newPairs[leftPair, default: 0] += count
                newPairs[rightPair, default: 0] += count
            }
            pairs = newPairs
        }

        let charCounts = characterCounts(from: pairs, derivedFrom: puzzle.template)

        let minCount = charCounts.values.min()!
        let maxCount = charCounts.values.max()!

        return (minCount: minCount, maxCount: maxCount)
    }
}

struct Puzzle {
    let template: String
    let pairRules: [String: Character]
}

public extension String {
    func characterCount() -> [Character: Int] {
        let result = reduce(into: [Character: Int]()) { acc, curr in
            acc[curr, default: 0] += 1
        }
        return result
    }
}
