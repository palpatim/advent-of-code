@testable import day17
import utils
import XCTest

final class day17Tests: XCTestCase {
    func testConverge() {
        XCTAssertEqual(1.converging(to: 1, by: 1), 1)
        XCTAssertEqual(10.converging(to: 0, by: 1), 9)
        XCTAssertEqual(-10.converging(to: 0, by: 1), -9)
        XCTAssertEqual(0.converging(to: 10, by: 1), 1)
        XCTAssertEqual(0.converging(to: -10, by: 1), -1)
        XCTAssertEqual(10.converging(to: 0, by: 100), -90)
        XCTAssertEqual(0.converging(to: 10, by: 100), 100)
    }

    func testVelocity() {
        XCTAssertEqual(Velocity(x: 10, y: 10).slowdown(), Velocity(x: 9, y: 9))
        XCTAssertEqual(Velocity(x: -2, y: 0).slowdown(), Velocity(x: -1, y: -1))
        XCTAssertEqual(Velocity(x: 1, y: 1).slowdown(), Velocity(x: 0, y: 0))
        XCTAssertEqual(Velocity(x: -1, y: 1).slowdown(), Velocity(x: 0, y: 0))
        XCTAssertEqual(Velocity(x: -1, y: -1).slowdown(), Velocity(x: 0, y: -2))
    }

    func testDistanceToZero() {
        XCTAssertEqual(
            Velocity.distanceToZero(positiveInt: 3),
            6
        )

        XCTAssertEqual(
            Velocity.distanceToZero(positiveInt: 4),
            10
        )

        XCTAssertEqual(
            Velocity.distanceToZero(positiveInt: 5),
            15
        )

        XCTAssertEqual(
            Velocity.distanceToZero(positiveInt: 6),
            21
        )

        XCTAssertEqual(
            Velocity.distanceToZero(positiveInt: 8),
            36
        )
    }

    func testCountOfSeries() {
        XCTAssertEqual(
            Velocity.countOfSeries(withSum: 6),
            3
        )

        XCTAssertEqual(
            Velocity.countOfSeries(withSum: 10),
            4
        )

        XCTAssertEqual(
            Velocity.countOfSeries(withSum: 15),
            5
        )

        XCTAssertEqual(
            Velocity.countOfSeries(withSum: 21),
            6
        )

        XCTAssertEqual(
            Velocity.countOfSeries(withSum: 36),
            8
        )
    }

    func testPart1Sample() {
        let result = day17.solvePart1(sampleInput)
        XCTAssertEqual(result, 45)
    }

    func testPart1Real() {
        let result = day17.solvePart1(realInput)
        XCTAssertEqual(result, 5995)
    }

    func testPart2Sample() {
        let result = day17.solvePart2(sampleInput)
        XCTAssertEqual(result, 112)
    }

    func testPart2Real() {
        let result = day17.solvePart2(realInput)
        XCTAssertEqual(result, 3202)
    }
}

// MARK: - Inputs

let sampleInput = """
target area: x=20..30, y=-10..-5
"""

let realInput = """
target area: x=156..202, y=-110..-69
"""
