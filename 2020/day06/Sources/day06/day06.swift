import Foundation

public enum day06 {
    public static func solvePart1(_ input: String) -> Int {
        let groups = parseInput(input)
        let sum = groups
            .map(day06.union)
            .map { $0.count }
            .reduce(0, +)
        return sum
    }

    public static func solvePart2(_ input: String) -> Int {
        let groups = parseInput(input)
        let sum = groups
            .map(day06.intersection)
            .map { $0.count }
            .reduce(0, +)
        return sum
    }

    private static func parseInput(_ input: String) -> [[Set<String>]] {
        var groups = [[Set<String>]]()
        let lines = input.components(separatedBy: .newlines)
        var currentGroup = [Set<String>]()
        for line in lines {
            if line.isEmpty {
                groups.append(currentGroup)
                currentGroup = [Set<String>]()
                continue
            }

            let answerArray = line.map { String($0) }
            let answerSet = Set<String>(answerArray)
            currentGroup.append(answerSet)
        }

        groups.append(currentGroup)
        return groups
    }

    public static func intersection<Element>(_ sets: [Set<Element>]) -> Set<Element> {
        let union = union(sets)
        let intersection = sets
            .reduce(union) { acc, curr in acc.intersection(curr) }
        return intersection
    }

    private static func union<Element>(_ sets: [Set<Element>]) -> Set<Element> {
        let union = sets
            .reduce(Set()) { $0.union($1) }
        return union
    }
}
