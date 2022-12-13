@testable import day11
import XCTest

final class day11Tests: XCTestCase {
    func testOne() throws {
        let actual = day11.solvePart1(sampleInput, steps: 2)
        let expected = 35
        XCTAssertEqual(actual, expected)
    }

    func testPart1Sample() throws {
        let actual = day11.solvePart1(sampleInput, steps: 100)
        let expected = 1656
        XCTAssertEqual(actual, expected)
    }

    func testPart1Real() throws {
        let actual = day11.solvePart1(realInput, steps: 100)
        let expected = 1741
        XCTAssertEqual(actual, expected)
    }

    func testPart2Sample() throws {
        let actual = day11.solvePart2(sampleInput)
        let expected = 195
        XCTAssertEqual(actual, expected)
    }

    func testPart2Real() throws {
        let actual = day11.solvePart2(realInput)
        let expected = 440
        XCTAssertEqual(actual, expected)
    }
}

// MARK: - Input

let sampleInput = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

let realInput = """
4743378318
4664212844
2535667884
3273363861
2282432612
2166612134
3776334513
8123852583
8181786685
4362533174
"""
