@testable import day11
import XCTest

final class day11Tests: XCTestCase {
    func testPart1Sample() throws {
        let actual = day11.solvePart1(sampleInput)
        XCTAssertEqual(actual, 37)
    }

    func testPart1Real() throws {
        let actual = day11.solvePart1(realInput)
        XCTAssertEqual(actual, 2243)
    }

    func testPart2Sample() throws {
        let actual = day11.solvePart2(sampleInput)
        XCTAssertEqual(actual, 26)
    }

    func testPart2Real() throws {
        let actual = day11.solvePart2(realInput)
        XCTAssertEqual(actual, 2027)
    }
}

// MARK: - Input

let sampleInput = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

let realInput = """
LLLLL.LLLLLL.LLLLLLLLL.LLL.LL.LLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLLL.LLLLLLL
LLLLL.LLLLLL.LLLLLLLLLLLLLLL.LLLLLLLL.LLLLL.LLL.LLLLLL.LLLL.LLLLL.LLLLLLLLLLL.LLLLLLLL.LLLLLLLLL
LLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLL
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLLLLLLL.LLLL.L.LLLLLLLLLLLLLLLLLLLLLLLLL.LLL.LLLL
LLLLL.L.LLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLL.LLLL.L.LLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLL
LLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
L.LL.L.L.LL.....L.L..L.LL.L.L.L.....L..LLL.L.....L.L...LL..L.....L...L..L.LLLL..L.LL......L.L.L.
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLL.L.LLLLLLLLL.LLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLL.
LLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
......LL..LLLL.L...LL.....L.L.......L..L.LL....L.LLL........L.L.L.LL.....L.........L....L......L
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLL.LL.LLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL..LLLLLLL..LLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL.LLL.LLLL.LLLLLLLLLLLLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.L.LLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.L.LLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLLLLLLLLLLLLL.LLLLLL..LLLLL.LLL.LLLLLL.LLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLL.L.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
LLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
.L...L...L.....L...L....L.LL.LLL.LL...LL.L..L...L......L..LL..L..LL..L.L......L.L.LLL......L.L..
LLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLL.LLLLLLLLLLLLLLLLL.L.LLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLL.L.LLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLL.LLL.LLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LL.LL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
...........LLL.....LLL.....LL.L..........L..L.L.L...L.L.....L........L......L..L..L...LL....L.L.
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLL.LLLLL.LLLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLL.LLLL.L.LLLL.LLLLLL.LLLLLL.LLLL.LLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLL.LLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLL.LLLL.LLLLLLL.L.LLLLLLLL
LLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLL
LLLLL.LLLLLL.L.LLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
.LLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLL.LLLLLL.LLLL.LLLL.LLLLLLLLLLLLL
L.......LL...LL...L..L.....L..LL..L.L.LLL.L.L..L.LL.L.........L....LLLL..LL..L.L..L..LLLL..LL.L.
LLLLL.LLLLLL.LLL.LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLL.LLLLLL..LLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLL.LLLL.LLLLLLLLLLLLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLLL.LLLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLL.LLLLLL.LL.LLLLLLLL
LLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
....LLL.LL....L.L.........L.L............L..L...L.LLLL......L...L.L..L....L.......L..L..........
LLLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL..LLLLLLLL.LLLLLL.LL.L.LLLLL.LLLLLL.LLLLLL.LLLLLLL.LLLLLLLL
LLLLLLLLLLLL.LL.L.LLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLLLLLLLLL.L..LLL..LLLLLLLLL.LLLLLL.LLLL.L.LLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLL..LLLLL.LLLLLLLLL.LLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
.L..LLLL..L.L.LLL.......LL.LL.LL......L.L....L.LLL.......L...L.L.LL...LL.....L.L....L.L...L.L...
LLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLLLLLL.LLLL
LLLLL.LL.LLL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLL..LLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLL.LLLLLL..LLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLL.LL
LLL.LLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLL
LLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLL.LLLLLLLLLL.LLLLLLLLLLLLLLLLLLL
.L..L..LLL....LL......LL.L.L..LL..LL....L...L..L.L.L...L..L..L.LLLL.L....L.....L..L...L...LLL...
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
LLLLLLLLLLLLL.LLLLLLLL.LLLLLL.LLLLLLLLLLLLLLL.L.LLLLLL.LLLL.LLL.LLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLLLLLLLLL.LLLLLLL.LLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLL.LLLLL.LLLLLLLLLLLLLLLLLLLLLLLL.LL.LLL.LLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLL
LLLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLLLLL.LLLLLLLL.LLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLLLLL..LLLLLLLLLLLLLL.LLLLLL.LL.LLLLLLLLLLL.L.LLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
..LL.LL.L.LL.L...L..L..L..L...LL........L......LL.LLLL.......L..LLL.L.L....L.....L..LL..L.LL.LL.
LLLLL.LLLL.L.LLLLL.LLL.LLLLLL.LLLLLLL.LL.LLLLLL.LLLLLL.LLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL..LLLLL.LLLLLLL.LLLL.LLLLLLLLLLL.LLLL..LLLL.LLLLLLLLLLL.LLLLLLLLLLLLL.LLLL
LLLLL.LLLLLLLLLLLLLLL.L.LLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLL..LLLLLLLLLLLLLLL.L.LLLLLLLLLLL.LLLLLLLLLLLL.LLLL.LLLLLLLLLLLLLLLLLL
LLLLL.LLLLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LL.LL.LLL.LL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL..LLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL..LLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLL
.LL..LL.L.LL......L.L.LL...L..LL..LL...L..L.L..LL...L.L..L.....L.LLL..L..LL.L..L.......L..LLL...
LLLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLL
LLLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLLL.LLLLLLLLLLLLLLLLL
LLLLL.LLLLLLLLLLLLLLLL.LLLLLLLL.LLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLL..LLLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL..LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLL.LLLLLLLLL.LLLL.LLL.L.LLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
LLLLL.LLL.LL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLL.LL.LLL.LLLL.LLLLL.LLLLLL.LL.L.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.L.LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
.L.L....LLL.L.L........L..L....L..L...LL..L..LLL..L.L....L..L.LL....LL.L.L.....L........L..L.L..
LLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLL.LL.LLLLLLLLLLLLL.LLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLL.LLL
LLLLL.LLLLLL.LLLLLLLLLLLLLL.L.LLLLLLL.LLLLLLLL.LLLLLLL.LLLL.LLLLL.LLLLLL.LLLL.LLLLL.LL..LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.L.LLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
LLLLLLLLLLLL.LLLLLLLLLLLLL.LL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLLLLL.LLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLL
LLLL..L.LLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL
LLLLL..LLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLL..LLLLLLLLL.LLLLLLLL
LLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLLL.L.LL..LLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLL
"""
