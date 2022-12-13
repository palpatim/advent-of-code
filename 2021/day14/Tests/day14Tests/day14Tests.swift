@testable import day14
import XCTest

final class day14Tests: XCTestCase {
    func testPairs() {
        var string: String!
        var pairs: [String: Int]!

        string = "NNCB"
        pairs = day14.pairs(from: string)
        XCTAssertEqual(pairCounts(from: pairs), string.count - 1)

        string = "NCNBCHB"
        pairs = day14.pairs(from: string)
        XCTAssertEqual(pairCounts(from: pairs), string.count - 1)

        string = "NBCCNBBBCBHCB"
        pairs = day14.pairs(from: string)
        XCTAssertEqual(pairCounts(from: pairs), string.count - 1)

        string = "NBBBCNCCNBBNBNBBCHBHHBCHB"
        pairs = day14.pairs(from: string)
        XCTAssertEqual(pairCounts(from: pairs), string.count - 1)

        string = "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"
        pairs = day14.pairs(from: string)
        XCTAssertEqual(pairCounts(from: pairs), string.count - 1)
    }

    func testCharacterCounts() {
        var string: String!
        var pairs: [String: Int]!
        var characterCounts: [Character: Int]!

        string = "NNCB"
        pairs = day14.pairs(from: string)
        characterCounts = day14.characterCounts(from: pairs, derivedFrom: string)
        XCTAssertEqual(characterCounts, [
            "N": 2,
            "C": 1,
            "B": 1,
        ])
    }

    func testPart1Sample() {
        let actual = day14.solve(sampleInput, count: 10)
        XCTAssertEqual(actual, 1588)
    }

    func testPart1Real() {
        let actual = day14.solve(realInput, count: 10)
        XCTAssertEqual(actual, 3058)
    }

    func testPart2Sample() {
        let actual = day14.solve(sampleInput, count: 40)
        XCTAssertEqual(actual, 2_188_189_693_529)
    }

    func testPart2Real() {
        let actual = day14.solve(realInput, count: 40)
        XCTAssertEqual(actual, 3_447_389_044_530)
    }

    func pairCounts(from pairs: [String: Int]) -> Int {
        pairs.values.reduce(0, +)
    }
}

// MARK: - Input

let sampleInput = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

let realInput = """
SVCHKVFKCSHVFNBKKPOC

NC -> H
PK -> V
SO -> C
PH -> F
FP -> N
PN -> B
NP -> V
NK -> S
FV -> P
SB -> S
VN -> F
SC -> H
OB -> F
ON -> O
HN -> V
HC -> F
SN -> K
CB -> H
OP -> K
HP -> H
KS -> S
BC -> S
VB -> V
FC -> B
BH -> C
HH -> O
KH -> S
VF -> F
PF -> P
VV -> F
PP -> V
BO -> H
BF -> B
PS -> K
FO -> O
KF -> O
FN -> H
CK -> B
VP -> V
HK -> F
OV -> P
CS -> V
FF -> P
OH -> N
VS -> H
VO -> O
CP -> O
KC -> V
KV -> P
BK -> B
VK -> S
NF -> V
OO -> V
FH -> H
CN -> O
SP -> B
KN -> V
OF -> H
NV -> H
FK -> B
PV -> N
NB -> B
KK -> P
VH -> P
CC -> B
HV -> V
OC -> H
PO -> V
NO -> O
BP -> C
NH -> H
BN -> O
BV -> S
CV -> B
HS -> O
NN -> S
NS -> P
KB -> F
CO -> H
HO -> P
PB -> B
BS -> P
SH -> H
FS -> V
SF -> O
OK -> F
KP -> S
BB -> C
PC -> B
OS -> C
SV -> N
SK -> K
KO -> C
SS -> V
CF -> C
HB -> K
VC -> B
CH -> P
HF -> K
FB -> V
"""
