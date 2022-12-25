import utils
import XCTest

final class aocTests: XCTestCase {
    func testConversions() async throws {
        let tests = [
            1: "1",
            2: "2",
            3: "1=",
            4: "1-",
            5: "10",
            6: "11",
            7: "12",
            8: "2=",
            9: "2-",
            10: "20",
            15: "1=0",
            20: "1-0",
            2022: "1=11-2",
            12345: "1-0---0",
            314_159_265: "1121-1110-1=0"
        ]

        for (int, str) in tests {
            XCTAssertEqual(Snafu(integerValue: int).stringValue, str)
            XCTAssertEqual(Snafu(stringLiteral: str).intValue, int)
        }
    }

    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, "2=-1=0")
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, "2-=12=2-2-2-=0012==2")
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, "-1")
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, "-1")
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String
    ) async throws -> String {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let fuelRequirements = try String.lines(fromFile: fileURL)
            .filter { !$0.isEmpty }
            .map { Snafu(stringLiteral: $0) }

        let totalRequirements = fuelRequirements
            .map { $0.intValue }
            .reduce(0, +)

        return Snafu(integerValue: totalRequirements).description
    }
}

// MARK: - Structures

struct Snafu {
    static let base = 5
    let intValue: Int
    let stringValue: String

    init(integerValue: Int) {
        self.intValue = integerValue
        self.stringValue = Snafu.toSnafuString(integerValue)
    }

    private static func toSnafuString(_ intValue: Int) -> String {
        guard intValue != 0 else {
            return "0"
        }
//"1-0---0"
        var snafu = [Character]()
        var acc = intValue
        while acc > 0 {
            let rem = acc % base
            var carryOver = 0
            switch rem {
            case 0, 1, 2: snafu.append(Character("\(rem)"))
            case 3:
                snafu.append("=")
                carryOver = 1
            case 4:
                snafu.append("-")
                carryOver = 1
            default:
                fatalError("Unexpected remainder converting \(intValue)")
            }

            acc /= base
            acc += carryOver
        }

//        if carryOver > 0 {
//            snafu.append(Character("\(carryOver)"))
//        }

        return String(snafu.reversed())
    }
}

extension Snafu: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        self.stringValue = stringLiteral
        self.intValue = Snafu.toInteger(stringLiteral)
    }

    private static func toInteger(_ string: String) -> Int {
        var acc = 0
        var exp = 0
        for char in string.reversed() {
            switch char {
            case "0": break
            case "1": acc += intPow(base, exp)
            case "2": acc += 2 * intPow(base, exp)
            case "-": acc -= intPow(base, exp)
            case "=": acc -= 2 * intPow(base, exp)
            default: fatalError("Invalid SNAFU format \(string)")
            }
            exp += 1
        }
        return acc
    }
}

extension Snafu: CustomStringConvertible {
    var description: String { stringValue }
}


func intPow(_ base: Int, _ exponent: Int) -> Int {
    let result = Int(pow(Double(base), Double(exponent)))
    return result
}
