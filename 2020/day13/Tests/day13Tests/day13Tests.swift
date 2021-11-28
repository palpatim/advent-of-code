import XCTest
@testable import day13

final class day13Tests: XCTestCase {
    func testPart1Sample() throws {
        let actual = day13.solvePart1(sampleInput)
        XCTAssertEqual(actual, 295)
    }

    func testPart1Real() throws {
        let actual = day13.solvePart1(realInput)
        XCTAssertEqual(actual, 1895)
    }

    func testPart2Sample() throws {
        let actual = day13.solvePart2(sampleInput)
        XCTAssertEqual(actual, 1068781)
    }

    func testPart2OtherSamples() {
        var expected = 3417
        var input = """
        1
        17,x,13,19
        """
        var actual = day13.solvePart2(input)
        XCTAssertEqual(actual, expected)

        expected = 754018
        input = """
        1
        67,7,59,61
        """
        actual = day13.solvePart2(input)
        XCTAssertEqual(actual, expected)

        expected = 779210
        input = """
        1
        67,x,7,59,61
        """
        actual = day13.solvePart2(input)
        XCTAssertEqual(actual, expected)

        expected = 1261476
        input = """
        1
        67,7,x,59,61
        """
        actual = day13.solvePart2(input)
        XCTAssertEqual(actual, expected)

        expected = 1_202_161_486
        input = """
        1
        1789,37,47,1889
        """
        actual = day13.solvePart2(input)
        XCTAssertEqual(actual, expected)
    }

    func testPart2Real() throws {
        let actual = day13.solvePart2(realInput)
        XCTAssertEqual(actual, 840493039281088)
    }

}

// MARK: - Input

let sampleInput = """
939
7,13,x,x,59,x,31,19
"""

let realInput = """
1004345
41,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,379,x,x,x,x,x,x,x,23,x,x,x,x,13,x,x,x,17,x,x,x,x,x,x,x,x,x,x,x,29,x,557,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19
"""
