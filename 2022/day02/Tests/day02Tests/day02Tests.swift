import XCTest
import utils
@testable import day02

final class day02Tests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("part1.sample.txt", strategy: .shape)
        XCTAssertEqual(actual, 15)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("part1.real.txt", strategy: .shape)
        XCTAssertEqual(actual, 15691)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("part2.sample.txt", strategy: .outcome)
        XCTAssertEqual(actual, 12)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("part2.real.txt", strategy: .outcome)
        XCTAssertEqual(actual, 12989)
    }

}

// MARK: - Solution

class Solution {
    static func solve(
        _ fileName: String,
        strategy: MovePickingStrategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw ParsingError("Unable to open \(fileName)")
        }

        var totalScore = 0
        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }
            let moves = line.components(separatedBy: .whitespaces)
            let opponentShape = Shape(opponentMove: moves[0])
            let myShape = Shape.response(
                against: opponentShape,
                using: strategy,
                symbol: moves[1]
            )
            let round = Round(myShape, opponentShape)
            totalScore += round.score
        }

        return totalScore
    }

}

// MARK: - Structures

/// Strategy for picking my move
enum MovePickingStrategy {
    /// Symbols represent shapes: X == Rock; Y == Paper; Z == Scissors
    case shape

    /// Symbols represent shapes: X == Lose; Y == Draw; Z == Win
    case outcome


}

enum Shape {
    case rock
    case paper
    case scissors

    var score: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }

    var beats: Shape {
        switch self {
        case .rock: return .scissors
        case .paper: return .rock
        case .scissors: return .paper
        }
    }

    var draws: Shape {
        return self
    }

    var losesTo: Shape {
        switch self {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }

    func outcome(against shape: Shape) -> Outcome {
        if shape == losesTo {
            return .lose
        }

        if shape == beats {
            return .win
        }

        return .draw
    }

    init(opponentMove: String) {
        switch opponentMove {
        case "A": self = .rock
        case "B": self = .paper
        case "C": self = .scissors
        default: fatalError("Unrecognized myMove: \(opponentMove)")
        }
    }

    private static func shapeSubstitutingSymbol(symbol: String) -> Shape {
        switch symbol {
        case "X": return .rock
        case "Y": return .paper
        case "Z": return .scissors
        default: fatalError("Unrecognized symbol: \(symbol)")
        }
    }

    private static func outcomeSubstitutingSymbol(
        symbol: String
    ) -> Shape {
        switch symbol {
        case "X": return .rock
        case "Y": return .paper
        case "Z": return .scissors
        default: fatalError("Unrecognized symbol: \(symbol)")
        }
    }

    static func response(
        against opponentsShape: Shape,
        using strategy: MovePickingStrategy,
        symbol: String
    ) -> Shape {
        switch strategy {
        case .shape:
            return shapeSubstitutingSymbol(symbol: symbol)
        case .outcome:
            let expectedOutcome = Outcome(outcomeSymbol: symbol)
            switch expectedOutcome {
            case .win: return opponentsShape.losesTo
            case .draw: return opponentsShape.draws
            case .lose: return opponentsShape.beats
            }
        }
    }
}

enum Outcome {
    case win
    case lose
    case draw

    var score: Int {
        switch self {
        case .win: return 6
        case .lose: return 0
        case .draw: return 3
        }
    }

    init(outcomeSymbol: String) {
        switch outcomeSymbol {
        case "X": self = .lose
        case "Y": self = .draw
        case "Z": self = .win
        default: fatalError("Unrecognized myMove: \(outcomeSymbol)")
        }
    }

}

struct Round {
    let myShape: Shape
    let opponentShape: Shape

    var score: Int {
        let outcome = myShape.outcome(against: opponentShape)
        return outcome.score + myShape.score
    }

    init(_ myShape: Shape, _ opponentShape: Shape) {
        self.myShape = myShape
        self.opponentShape = opponentShape
    }
}

// MARK: - Errors

struct ParsingError: Error {
    let message: String
    let underlyingError: Error?

    init(_ message: String, _ underlyingError: Error? = nil) {
        self.message = message
        self.underlyingError = underlyingError
    }
}
