@testable import day15
import XCTest

final class day15Tests: XCTestCase {
    func testPart1Sample() throws {
        let limit = 2020
        var input = "0,3,6"
        var expected = 436
        var actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "1,3,2"
        expected = 1
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "2,1,3"
        expected = 10
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "1,2,3"
        expected = 27
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "2,3,1"
        expected = 78
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "3,2,1"
        expected = 438
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "3,1,2"
        expected = 1836
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)
    }

    func testPart1Real() {
        let limit = 2020
        let input = "1,17,0,10,18,11,6"
        let expected = 595
        let actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)
    }

    func testPart2Sample() {
        let limit = 30_000_000
        var input = "0,3,6"
        var expected = 175_594
        var actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "1,3,2"
        expected = 2578
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "2,1,3"
        expected = 3_544_142
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "1,2,3"
        expected = 261_214
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "2,3,1"
        expected = 6_895_259
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "3,2,1"
        expected = 18
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)

        input = "3,1,2"
        expected = 362
        actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)
    }

    func testPart2Real() {
        let limit = 30_000_000
        let input = "1,17,0,10,18,11,6"
        let expected = 1_708_310
        let actual = day15.solve(input, playingTo: limit)
        XCTAssertEqual(actual, expected)
    }
}
