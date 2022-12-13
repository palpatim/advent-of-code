import Foundation

public enum day07 {
    public enum RuleSet {
        case part1, part2
    }

    public static func solve(_ input: String, ruleSet: RuleSet) -> Int {
        let positions = parseInput(input)
        print("\(positions.count) values")

        if ruleSet == .part1 {
            let median = positions.median()
            return linearFuelConsumption(numbers: positions, to: median)
        } else {
            return triangularFuelConsumptionBruteForce(numbers: positions)
        }
    }

    private static func parseInput(_ input: String) -> [Int] {
        let numbers = input.components(separatedBy: ",").map { Int($0)! }
        return numbers
    }

    private static func linearFuelConsumption(numbers: [Int], to position: Int) -> Int {
        let totalFuel = numbers.reduce(0) { $0 + abs($1 - position) }
        return totalFuel
    }

    private static func triangularFuelConsumptionBruteForce(numbers: [Int]) -> Int {
        let maxIndex = numbers.max()!
        var itemsAtPosition = [Int](repeating: 0, count: maxIndex + 1)
        for num in numbers {
            itemsAtPosition[num] += 1
        }

        var totalFuelAtPosition = [Int](repeating: 0, count: maxIndex + 1)
        for destination in 0 ..< totalFuelAtPosition.count {
            for (position, itemCount) in itemsAtPosition.enumerated() {
                guard itemCount > 0 else {
                    continue
                }

                let fuelCost = triangular(abs(position - destination))
                let totalCost = fuelCost * itemCount
                totalFuelAtPosition[destination] += totalCost
            }
        }

        return totalFuelAtPosition.min()!
    }

    private static func triangular(_ n: Int) -> Int {
        (n * (n + 1)) / 2
    }
}

public extension Array where Element == Int {
    func sum() -> Int {
        let sum = reduce(0, +)
        return sum
    }

    func mean() -> Int {
        let sum = self.sum()
        return sum / count
    }

    func median() -> Int {
        let ordered = sorted()
        let median: Int
        if ordered.count.isMultiple(of: 2) {
            let upperMid = count / 2
            let lowerMid = upperMid - 1
            median = (ordered[upperMid] + ordered[lowerMid]) / 2
        } else {
            let midpoint = (count - 1) / 2
            median = ordered[midpoint]
        }
        return median
    }

    /// Returns a dictionary whose keys are elements of the array, and whose values are the number of times that value appears in the array
    func histogram() -> [Int: Int] {
        let histogram = reduce([Int: Int]()) { acc, curr in
            var new = acc
            new[curr, default: 0] += 1
            return new
        }
        return histogram
    }

    func mode() -> Int {
        let histogram = self.histogram()
        let maxCount = histogram.max { $0.value < $1.value }
        return maxCount!.key
    }

    func weightedMean() -> Int {
        let histogram = self.histogram()
        let weightedSum = histogram
            .reduce(0) { $0 + ($1.key * $1.value) }
        return weightedSum / histogram.count
    }

    func geometricMean() -> Int {
        // Adjust entire range to remove zeros
        let adjustedValues = map { $0 + 1 }
        let product = adjustedValues.reduce(1, *)
        let nthRoot = pow(Double(product), Double(1 / adjustedValues.count))
        let geometricMean = nthRoot - 1
        return Int(geometricMean)
    }

    func centerOfGravity() -> Int {
        // https://www.wikihow.com/Calculate-Center-of-Gravity

        // Get the number of values at each index. This gives us a "weight" distribution
        let maxIndex = self.max()!
        var itemsAtPosition = [Int](repeating: 0, count: maxIndex + 1)
        for num in self {
            itemsAtPosition[num] += 1
        }

        let totalWeight = itemsAtPosition.sum()

        let datum = count / 2
        let moments = itemsAtPosition.map { $0 * datum }
        let totalMoment = moments.sum()
        let centerOfGravity = totalMoment / totalWeight
        return centerOfGravity
    }
}
