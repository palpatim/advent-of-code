import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .small)
        XCTAssertEqual(actual, 10605)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .small)
        XCTAssertEqual(actual, 107_822)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .large)
        XCTAssertEqual(actual, 2_713_310_158)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .large)
        XCTAssertEqual(actual, 27_267_163_742)
    }
}

// MARK: - Solution

enum Strategy {
    case small
    case large

    var rounds: Int {
        switch self {
        case .small: return 20
        case .large: return 10000
        }
    }
}

enum Solution {
    static func solve(
        _ fileName: String,
        strategy: Strategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var monkeys = [Monkey]()
        var currentMonkey: Monkey!
        for line in try String.lines(fromFile: fileURL)
            .map({ $0.trimmingCharacters(in: .whitespaces) })
        {
            guard !line.isEmpty else {
                continue
            }

            if line.starts(with: "Monkey") {
                if currentMonkey != nil {
                    monkeys.append(currentMonkey)
                }
                currentMonkey = Monkey()
                currentMonkey.id = parseMonkeyId(line)
            } else if line.starts(with: "Starting items:") {
                currentMonkey.items = parseItems(line)
            } else if line.starts(with: "Operation:") {
                currentMonkey.operation = parseOperation(line)
            } else if line.starts(with: "Test:") {
                currentMonkey.testDivisor = parseTestDivisor(line)
            } else if line.starts(with: "If ") {
                let dest = parseDestination(line)
                currentMonkey.destinations[dest.key] = dest.value
            }
        }

        monkeys.append(currentMonkey)

        processRounds(strategy: strategy, monkeys: &monkeys)
        printMonkeyInspectionCount(monkeys)
        return part1Score(monkeys: monkeys)
    }

    static func prettyPrint(_ monkeys: [Monkey]) {
        for monkey in monkeys {
            print("""
            Monkey \(monkey.id!):
              Starting items: \(monkey.items)
              Operation: new = \(monkey.operation!)
              Test: divisible by \(monkey.testDivisor!)
                If true: throw to monkey \(monkey.destinations[true]!)
                If false: throw to monkey \(monkey.destinations[false]!)

            """)
        }
    }

    static func printMonkeyItems(_ monkeys: [Monkey]) {
        for monkey in monkeys {
            print("Monkey \(monkey.id!): \(monkey.items)")
        }
    }

    static func printMonkeyInspectionCount(_ monkeys: [Monkey]) {
        for monkey in monkeys {
            print("Monkey \(monkey.id!) inspected items \(monkey.inspectionCount) times")
        }
    }

    static func parseMonkeyId(_ line: String) -> Int {
        let idString = line
            .suffix(afterFirstInstanceOf: "Monkey ")!
            .prefix(upToFirstInstanceOf: ":")!
        return Int(idString)!
    }

    static func parseItems(_ line: String) -> [Int] {
        let itemsString = line.suffix(afterFirstInstanceOf: ": ")!
        let items = itemsString
            .split(separator: ", ")
            .map { Int($0)! }
        return items
    }

    static func parseOperation(_ line: String) -> (Int) -> Int {
        let statement = line.suffix(afterFirstInstanceOf: ": ")!
        let expression = statement.suffix(afterFirstInstanceOf: " = ")!
            .components(separatedBy: .whitespaces)
        let op = expression[1]
        let operand = expression[2]

        let resolveOperand: (Int) -> Int = { old in
            if operand == "old" {
                return old
            }

            return Int(operand)!
        }

        switch op {
        case "*": return { $0 * resolveOperand($0) }
        case "+": return { $0 + resolveOperand($0) }
        default: fatalError("Unrecognized operation: \(line)")
        }
    }

    static func parseTestDivisor(_ line: String) -> Int {
        let divisorString = line.suffix(afterFirstInstanceOf: "divisible by ")!
        return Int(divisorString)!
    }

    static func parseDestination(_ line: String) -> Dictionary<Bool, Int>.Element {
        let conditionString = line
            .suffix(afterFirstInstanceOf: "If ")!
            .prefix(upToFirstInstanceOf: ":")!
        let condition = conditionString == "true"

        let destinationString = line.suffix(afterFirstInstanceOf: "to monkey ")!
        let destination = Int(destinationString)!
        return [condition: destination].first!
    }

    static func processRounds(strategy: Strategy, monkeys: inout [Monkey]) {
        let worryReducer: (Int) -> Int
        switch strategy {
        case .small:
            worryReducer = { $0 / 3 }
        case .large:
            let divisor = monkeys
                .map { $0.testDivisor }
                .reduce(1, *)
            worryReducer = { $0 % divisor }
        }

        for idx in 0 ..< strategy.rounds {
            processRound(monkeys: &monkeys, reducingWorryLevelWith: worryReducer)
        }
    }

    static func processRound(monkeys: inout [Monkey], reducingWorryLevelWith worryReducer: (Int) -> Int) {
        for idx in 0 ..< monkeys.count {
            processTurn(for: idx, monkeys: &monkeys, reducingWorryLevelWith: worryReducer)
        }
    }

    static func processTurn(
        for idx: Int,
        monkeys: inout [Monkey],
        reducingWorryLevelWith worryReducer: (Int) -> Int
    ) {
        let monkey = monkeys[idx]
        while !monkey.items.isEmpty {
            let item = monkey.items.removeFirst()
            monkey.inspectionCount += 1
            let worryLevel = monkey.operation(item)
            let newWorryLevel = worryReducer(worryLevel)
            let condition = newWorryLevel.isMultiple(of: monkey.testDivisor)
            let destination = monkey.destinations[condition]!
            monkeys[destination].items.append(newWorryLevel)
        }
    }

    static func part1Score(monkeys: [Monkey]) -> Int {
        let sorted = monkeys.sorted { $0.inspectionCount > $1.inspectionCount }
        return sorted[0].inspectionCount * sorted[1].inspectionCount
    }
}

// MARK: - Structures

class Monkey {
    var id: Int!
    var items = [Int]()
    var operation: ((Int) -> Int)!
    var testDivisor: Int!
    var destinations = [Bool: Int]()
    var inspectionCount = 0
}

// MARK: - Extensions

extension StringProtocol {
    func suffix(afterFirstInstanceOf target: Self) -> Self.SubSequence? {
        guard let firstOccurrence = ranges(of: target).first else {
            return nil
        }
        return suffix(from: firstOccurrence.upperBound)
    }

    func prefix(upToFirstInstanceOf target: Self) -> Self.SubSequence? {
        guard let firstOccurrence = ranges(of: target).first else {
            return nil
        }
        return prefix(upTo: firstOccurrence.lowerBound)
    }
}
