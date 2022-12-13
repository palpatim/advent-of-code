import Foundation

public enum day09 {
    public static func solvePart1(
        _ input: String,
        preambleLength: Int
    ) -> Int {
        let numbers = parseInput(input)
        let result = findElementsWithoutMatchingSum(in: numbers, windowSize: preambleLength)
        return result[0]
    }

    public static func solvePart2(
        _ input: String,
        preambleLength: Int
    ) -> Int {
        let numbers = parseInput(input)
        let result = findElementsWithoutMatchingSum(in: numbers, windowSize: preambleLength)
        let target = result[0]
        print("Searching for range summing to \(target)")

        let range = contiguousRange(in: numbers, summingTo: target)
        let min = numbers[range].min()!
        let max = numbers[range].max()!
        return min + max
    }

    private static func contiguousRange(
        in numbers: [Int],
        summingTo target: Int
    ) -> ClosedRange<Int> {
        print("Searching \(numbers.count) elements for \(target)")
        for startIndex in 0 ..< numbers.count - 1 {
            var endIndex = startIndex + 1
            var currentSum = numbers[startIndex]

            while endIndex < numbers.count, currentSum < target {
                currentSum += numbers[endIndex]
                if currentSum == target {
                    print("Found \(startIndex)...\(endIndex)=\(currentSum)")
                    return startIndex ... endIndex
                }
                endIndex += 1
            }
            print("Searched \(startIndex)...\(endIndex); sum=\(currentSum)")
        }
        fatalError("No solution found")
    }

    private static func parseInput(_ input: String) -> [Int] {
        let lines = input.components(separatedBy: "\n")
        let numbers = lines.map { Int($0)! }
        return numbers
    }

    private static func findElementsWithoutMatchingSum(
        in numbers: [Int],
        windowSize: Int
    ) -> [Int] {
        var result = [Int]()
        var windowRange = 0 ..< windowSize
        while windowRange.upperBound < numbers.count {
            defer {
                windowRange.slide(by: 1)
            }

            let slice = numbers[windowRange]
            let target = numbers[windowRange.upperBound]
            guard findNElements(
                n: 2,
                in: slice,
                summingTo: target
            ) != nil else {
                result.append(target)
                continue
            }
        }
        return result
    }

    private static func findNElements<T: RandomAccessCollection>(
        n: Int,
        in input: T,
        summingTo target: Int
    ) -> [Int]? where T.Element == Int {
        var visited = Set<Int>()
        var result: [Int]?

        for element in input {
            let complement = target - element

            if n == 2 {
                if visited.contains(complement) {
                    result = [element, complement]
                    break
                } else {
                    visited.insert(element)
                }
            } else {
                if let interimResult = findNElements(
                    n: n - 1,
                    in: input.filter { $0 != element },
                    summingTo: complement
                ) {
                    result = interimResult
                    result!.append(element)
                    break
                }
            }
        }

        return result
    }
}

extension Range where Index: SignedInteger {
    mutating func slide(by increment: Range.Index) {
        self = lowerBound + increment ..< upperBound + increment
    }
}

extension RandomAccessCollection where Element == Int {
    func sum() -> Int {
        reduce(0, +)
    }
}
