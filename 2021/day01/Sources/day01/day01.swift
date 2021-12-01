import Foundation
import OpenGL

public struct day01 {
    public static func solve(
        _ input: String,
        windowSize: Int = 1
    ) -> Int {
        let numbers = parseInput(input)
        let increases = findIncreases(in: numbers, windowSize: windowSize)
        return increases
    }

    static func parseInput(_ input: String) -> [Int] {
        let lines = input.components(separatedBy: "\n")
        let numbers = lines.map { Int($0)! }
        return numbers
    }

    private static func findIncreases(
        in input: [Int],
        windowSize: Int
    ) -> Int {
        guard input.count > windowSize + 1 else {
            fatalError("Input must have at least 2 windows")
        }

        var increases = 0
        var prevWindowSum = input[0 ..< windowSize].reduce(0, +)
        for currentIndex in windowSize ..< input.count {
            let startIndex = currentIndex - windowSize + 1
            let currentWindowSlice = input[startIndex ... currentIndex]
            let currentWindowSum = currentWindowSlice.reduce(0, +)
            if currentWindowSum > prevWindowSum {
                increases += 1
            }
            prevWindowSum = currentWindowSum
        }
        return increases
    }
}
