import Foundation

public enum day03 {
    public enum RuleSet {
        case part1, part2
    }

    public static func solve(_ input: String, ruleSet: RuleSet = .part1) -> Int {
        let puzzleInput = parseInput(input)
        switch ruleSet {
        case .part1:
            return solvePart1(puzzleInput)
        case .part2:
            return solvePart2(puzzleInput)
        }
    }

    private static func solvePart1(_ puzzleInput: PuzzleInput) -> Int {
        let gammaRate = gammaRate(puzzleInput: puzzleInput)
        let epsilonRate = gammaRateToEspilonRate(gammaRate, puzzleInput: puzzleInput)
        return gammaRate * epsilonRate
    }

    private static func solvePart2(_ puzzleInput: PuzzleInput) -> Int {
        let oxygenRate = oxygenRate(puzzleInput: puzzleInput)
        let co2Rate = co2Rate(puzzleInput: puzzleInput)
        return oxygenRate * co2Rate
    }

    private static func parseInput(_ input: String) -> PuzzleInput {
        let lines = input.components(separatedBy: "\n")
        let numbers = lines.map { Int($0, radix: 2)! }
        let bitmapSize = lines[0].count

        return PuzzleInput(bitmapSize: bitmapSize, numbers: numbers)
    }

    private static func gammaRate(puzzleInput: PuzzleInput) -> Int {
        let gammaRateBitString = (0 ..< puzzleInput.bitmapSize)
            .map { puzzleInput.mostCommonBit(at: $0) }
            .map { $0 ? "1" : "0" }
            .joined()

        let gammaRate = Int(gammaRateBitString, radix: 2)!
        return gammaRate
    }

    private static func gammaRateToEspilonRate(
        _ gammaRate: Int,
        puzzleInput: PuzzleInput
    ) -> Int {
        let bitmapMask = Int(pow(2.0, Double(puzzleInput.bitmapSize)) - 1.0)
        let epsilonRate = ~gammaRate & bitmapMask
        return epsilonRate
    }

    private static func oxygenRate(puzzleInput: PuzzleInput) -> Int {
        var puzzleInput = puzzleInput
        for index in 0 ..< puzzleInput.bitmapSize {
            let numbers = puzzleInput.numbers
            let mostCommonBit = puzzleInput.mostCommonBit(at: index)

            let filteredNumbers = numbers.filter {
                puzzleInput
                    .numbersByBitsAtPosition[index]![mostCommonBit]!
                    .contains($0)
            }

            if filteredNumbers.count == 1 {
                return filteredNumbers.first!
            }

            puzzleInput = PuzzleInput(bitmapSize: puzzleInput.bitmapSize, numbers: filteredNumbers)
        }
        fatalError("No solution found")
    }

    private static func co2Rate(puzzleInput: PuzzleInput) -> Int {
        var puzzleInput = puzzleInput
        for index in 0 ..< puzzleInput.bitmapSize {
            let numbers = puzzleInput.numbers
            let mostCommonBit = puzzleInput.mostCommonBit(at: index)
            let leastCommonBit = !mostCommonBit

            let filteredNumbers = numbers.filter {
                puzzleInput
                    .numbersByBitsAtPosition[index]![leastCommonBit]!
                    .contains($0)
            }

            if filteredNumbers.count == 1 {
                return filteredNumbers.first!
            }

            puzzleInput = PuzzleInput(bitmapSize: puzzleInput.bitmapSize, numbers: filteredNumbers)
        }
        fatalError("No solution found")
    }
}

public struct PuzzleInput {
    public typealias PositionIndex = Int
    public typealias BitValue = Bool
    public typealias BitPositionMap = [PositionIndex: [BitValue: Set<Int>]]

    let bitmapSize: Int
    let numbers: [Int]

    let numbersByBitsAtPosition: BitPositionMap

    public init(bitmapSize: Int, numbers: [Int]) {
        self.bitmapSize = bitmapSize
        self.numbers = numbers

        var numbersByBitsAtPosition = BitPositionMap()
        for index in 0 ..< bitmapSize {
            numbersByBitsAtPosition[index] = [true: [], false: []]
        }

        for number in numbers {
            let bitmap = String(number, radix: 2)
                .paddingToLeft(upTo: bitmapSize, using: "0")
                .map { $0 == "1" }
            for (index, bit) in bitmap.enumerated() {
                numbersByBitsAtPosition[index]![bit]!.insert(number)
            }
        }

        self.numbersByBitsAtPosition = numbersByBitsAtPosition
    }

    public func mostCommonBit(at position: PositionIndex) -> BitValue {
        let positionValues = numbersByBitsAtPosition[position]!
        return positionValues[true]!.count >= positionValues[false]!.count
    }
}

// https://stackoverflow.com/a/52447981/603369
extension RangeReplaceableCollection where Self: StringProtocol {
    func paddingToLeft(upTo length: Int, using element: Element = " ") -> SubSequence {
        return repeatElement(element, count: Swift.max(0, length - count)) + suffix(Swift.max(count, count - length))
    }
}
