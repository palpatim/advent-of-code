import XCTest
import utils

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .signalStrength)
        XCTAssertEqual(actual, 13140)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .signalStrength)
        XCTAssertEqual(actual, 12740)
    }

    func testPart2Sample() async throws {
        let strategy = RenderStrategy()
        _ = try await Solution.solve("sample.txt", strategy: strategy)
        let output = strategy.displayRows.joined(separator: "\n")
        print(output)
        XCTAssertEqual(output, """
        ██..██..██..██..██..██..██..██..██..██..
        ███...███...███...███...███...███...███.
        ████....████....████....████....████....
        █████.....█████.....█████.....█████.....
        ██████......██████......██████......████
        ███████.......███████.......███████.....
        ........................................
        """)
    }

    func testPart2Real() async throws {
        let strategy = RenderStrategy()
        _ = try await Solution.solve("real.txt", strategy: strategy)
        let output = strategy.displayRows.joined(separator: "\n")
        print(output)
        XCTAssertEqual(strategy.displayRows.joined(separator: "\n"), """
        ███..███..███...██..███...██...██..████.
        █..█.█..█.█..█.█..█.█..█.█..█.█..█.█....
        █..█.███..█..█.█..█.█..█.█..█.█....███..
        ███..█..█.███..████.███..████.█.██.█....
        █.█..█..█.█....█..█.█.█..█..█.█..█.█....
        █..█.███..█....█..█.█..█.█..█..███.█....
        """)
    }

}

// MARK: - Solution
protocol Strategy {}
struct SignalStrengthStrategy: Strategy {}

extension Strategy where Self == SignalStrengthStrategy {
    static var signalStrength: Strategy { SignalStrengthStrategy() }
}

class RenderStrategy: Strategy {
    var displayRows = [String]()
}

extension Strategy where Self == RenderStrategy {
    static var render: Strategy { RenderStrategy() }
}

class Solution {
    static func solve(
        _ fileName: String,
        strategy: Strategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var register = 1

        // Index from 1, not 0
        var history = [register]

        for line in try String.lines(fromFile: fileURL) {
            guard line.starts(with: "addx") else {
                // No op carries the register value
                history.append(register)
                continue
            }

            let components = line.components(separatedBy: .whitespaces)
            let value = Int(components[1])!

            // addx takes 2 cycles to run, next command won't start until current addx is complete
            history.append(contentsOf: [register, register])

            // At the end of 2 cycles, register value is updated, so it's available at the beginning
            // of the next cycle
            register += value
        }

        switch strategy {
        case is SignalStrengthStrategy:
            return signalStrength(history: history)
        case let strategy as RenderStrategy:
            strategy.displayRows = renderScreen(history: history)
            return -1
        default:
            fatalError("Unknown strategy")
        }
    }

    static func signalStrength(history: [Int]) -> Int {
        let cols = 40
        let startIndex = 20
        let endIndex = 220
        var strength = 0
        for cycle in stride(from: startIndex, to: endIndex + 1, by: cols) {
            strength += cycle * history[cycle]
        }
        return strength
    }

    static func renderScreen(history: [Int]) -> [String] {
        let colCount = 40

        var rows = [String]()

        var pixels = [String]()
        for (cycle, registerValue) in history.suffix(from: 1).enumerated() {
            let col = cycle % colCount
            if col == 0 {
                let renderedRow = pixels.joined(separator: "")
                rows.append(renderedRow)
                pixels = [String](repeating: ".", count: colCount)
            }
            let spriteRange = Range.range(of: 3, centeredOn: registerValue)

            guard spriteRange.contains(col) else {
                continue
            }
            pixels[col] = "█"
        }

        let renderedRow = pixels.joined(separator: "")
        rows.append(renderedRow)

        return Array(rows.suffix(from: 1))
    }
}

// MARK: - Structures
