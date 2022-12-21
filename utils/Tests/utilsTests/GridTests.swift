@testable import utils
import XCTest

final class GridTests: XCTestCase {
    func testInconsistentSize() {
        let rows = [
            [0, 1, 2],
            [3, 4],
        ]
        XCTAssertThrowsError(try Grid(rows: rows)) {
            guard case GridError.inconsistentSize = $0 else {
                XCTFail("Expected .inconsistentSize, got \($0)")
                return
            }
        }
    }

    func testDiscontiguousRows() {
        let cells = [
            Coordinate(x: 0, y: 0): 0,
            Coordinate(x: 1, y: 0): 1,
            Coordinate(x: 2, y: 0): 2,

            Coordinate(x: 0, y: 1): 3,
            Coordinate(x: 2, y: 1): 5,
        ]

        XCTAssertThrowsError(try Grid(cells: cells)) {
            guard case GridError.discontiguousCells = $0 else {
                XCTFail("Expected .discontiguousCells, got \($0)")
                return
            }
        }
    }
}
