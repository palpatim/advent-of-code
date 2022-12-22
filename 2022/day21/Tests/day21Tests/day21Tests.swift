import utils
import DequeModule
import XCTest

func log(_ message: String) {
    // print(message)
}

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, 152)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, 85616733059734)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .solve)
        XCTAssertEqual(actual, 301)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .solve)
        XCTAssertEqual(actual, 3560324848168)
    }
}

// MARK: - Solution

enum Strategy {
    case evaluate
    case solve
}

enum Solution {
    static func solve(
        _ fileName: String,
        strategy: Strategy = .evaluate
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }

            let regex = #/(?<id>\w+): (?<remaining>.*)/#
            guard let result = line.firstMatch(of: regex) else {
                fatalError("Unexpected line format: \(line)")
            }

            if strategy == .solve && result.id == "humn" {
                variables["humn"] = .unknown("humn")
                continue
            }

            if let constant = Int(result.remaining) {
                variables["\(result.id)"] = .constant(constant)
            } else {
                let components = result.remaining.components(separatedBy: " ")
                let lhsId = components[0]
                let rhsId = components[2]

                let op = strategy == .solve && result.id == "root" ?
                    .equals : MathOperation(rawValue: components[1])!

                variables["\(result.id)"] = .expr(
                    op: op,
                    lhs: .variable(lhsId),
                    rhs: .variable(rhsId)
                )
            }

        }

        log("Formula: \(variables["root"]!.formula)")
        let rootResult = variables["root"]!.evaluate()
        if case .constant(let result) = rootResult {
            return result
        } else {
            print("Solving for: \(rootResult.formula)")
            let solvedResult = solve(rootResult)
            if case .constant(let result) = solvedResult {
                return result
            } else {
                fatalError("Couldn't solve")
            }
        }
    }

    static func solve(_ expr: Expression, indent: Int = 0) -> Expression {
        let ind = String([Character](repeating: " ", count: indent * 2))
        log("\(ind)Solving \(expr)")
        guard
            case .expr(let rootOp, let lhs, let rhs) = expr,
            rootOp == .equals
        else {
            return expr
        }

        switch (lhs, rhs) {
        case
            (let .constant(knownValue), let .expr(op: unknownOp, lhs: unknownLValue, rhs: unknownRValue)),
            (let .expr(op: unknownOp, lhs: unknownLValue, rhs: unknownRValue), let .constant(knownValue)):
            let inverseOp = unknownOp.inverse

            switch (unknownLValue, unknownRValue) {
            case (let .constant(constantValue), .expr):
                let newKnownValue = inverseOp.operation(knownValue, constantValue)
                return solve(
                    .expr(op: .equals, lhs: unknownRValue, rhs: .constant(newKnownValue)),
                    indent: indent + 1
                )
            case (.expr, let .constant(constantValue)):
                let newKnownValue = inverseOp.operation(knownValue, constantValue)
                return solve(
                    .expr(op: .equals, lhs: unknownLValue, rhs: .constant(newKnownValue)),
                    indent: indent + 1
                )

            case
                (.unknown(let name), .constant(let constantValue)),
                (.constant(let constantValue), .unknown(let name)):
                let newKnownValue = inverseOp.operation(knownValue, constantValue)

                log("\(ind)\(name) = \(newKnownValue)")
                return .constant(newKnownValue)

            default:
                fatalError("Can't solve for multiple unknowns")
            }

        case
            (.unknown(let name), .constant(let knownValue)),
            (.constant(let knownValue), .unknown(let name)):
            log("\(ind)\(name) = \(knownValue)")
            return .constant(knownValue)
        case (.constant, .constant):
            fatalError("Can't solve constant on both sides")

        default:
            fatalError("Don't know how to deal with this pair")
        }
    }
}

// MARK: - Structures

enum MathOperation: String {
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "*"
    case equals = "="

    var inverse: MathOperation {
        switch self {
        case .add: return .subtract
        case .subtract: return .add
        case .divide: return .multiply
        case .multiply: return .divide
        case .equals: return self
        }
    }

    var operation: (Int, Int) -> Int {
        switch self {
        case .add: return { $0 + $1 }
        case .subtract: return { $0 - $1 }
        case .divide: return { $0 / $1 }
        case .multiply: return { $0 * $1 }
        case .equals: return { _, _ in -1 }
        }
    }
}

extension MathOperation: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}

var variables = [String: Expression]()

indirect enum Expression {
    case constant(_ value: Int)
    case variable(_ name: String)
    case expr(op: MathOperation, lhs: Expression, rhs: Expression)
    case unknown(_ name: String)

    var formula: String {
        switch self {
        case .unknown(let name):
            return name
        case .constant(let value):
            return "\(value)"
        case .variable(let name):
            return variables[name]!.formula
        case .expr(op: let op, lhs: let lhs, rhs: let rhs):
            return "( \(lhs.formula) \(op.rawValue) \(rhs.formula) )"
        }
    }

    func evaluate(indent: Int = 0) -> Expression {
        let ind = String([Character](repeating: " ", count: indent * 2))
        switch self {
        case .unknown:
            return self
        case .constant:
            log("\(ind)Returning \(self)")
            return self
        case .variable(let name):
            log("\(ind)Evaluating \(self)")
            return variables[name]!.evaluate(indent: indent + 1)
        case .expr(let op, let lhs, let rhs):
            log("\(ind)Evaluating \(self)")
            let lResult = lhs.evaluate(indent: indent + 1)
            log("\(ind)lhs=\(lResult)")

            let rResult = rhs.evaluate(indent: indent + 1)
            log("\(ind)rhs=\(rResult)")

            switch (lResult, rResult) {
            case (.constant(let lValue), .constant(let rValue)):
                log("\(ind)Returning \(lValue) \(op) \(rValue)")
                return .constant(op.operation(lValue, rValue))
            default:
                log("\(ind)Returning .expr( \(lResult) \(op) \(rResult) )")
                return .expr(op: op, lhs: lResult, rhs: rResult)
            }

        }
    }
}

extension Expression: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown(let name):
            return "\(name)?"
        case .constant(let value):
            return "\(value)"
        case .variable(let name):
            return name
        case .expr(op: let op, lhs: let lhs, rhs: let rhs):
            return "( \(lhs.description) \(op.rawValue) \(rhs.description) )"
        }
    }
}
