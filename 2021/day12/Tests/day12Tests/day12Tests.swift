import XCTest
@testable import day12

final class day12Tests: XCTestCase {
    func testPart1Samples() {
        XCTAssertEqual(
            day12.solve(small, allowingRepeat: false),
            10
        )

        XCTAssertEqual(
            day12.solve(medium, allowingRepeat: false),
            19
        )

        XCTAssertEqual(
            day12.solve(large, allowingRepeat: false),
            226
        )
    }

    func testPart1Real() {
        XCTAssertEqual(
            day12.solve(realInput, allowingRepeat: false),
            3708
        )
    }

    func testPart2Samples() {
        XCTAssertEqual(
            day12.solve(small, allowingRepeat: true),
            36
        )

        XCTAssertEqual(
            day12.solve(medium, allowingRepeat: true),
            103
        )

        XCTAssertEqual(
            day12.solve(large, allowingRepeat: true),
            3509
        )
    }

    func testPart2Real() {
        XCTAssertEqual(
            day12.solve(realInput, allowingRepeat: true),
            93858
        )
    }

}

// MARK: - Input

let small = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

let medium = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

let large = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""

let realInput = """
lg-GW
pt-start
pt-uq
nx-lg
ve-GW
start-nx
GW-start
GW-nx
pt-SM
sx-GW
lg-end
nx-SM
lg-SM
pt-nx
end-ve
ve-SM
TG-uq
end-SM
SM-uq
"""
