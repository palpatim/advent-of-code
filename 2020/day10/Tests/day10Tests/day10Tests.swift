@testable import day10
import XCTest

final class day10Tests: XCTestCase {
    func testPart1Sample() throws {
        let actual = day10.solvePart1(sampleInput)
        XCTAssertEqual(actual, 220)
    }

    func testPart1Real() throws {
        let actual = day10.solvePart1(realInput)
        XCTAssertEqual(actual, 1998)
    }

    func testPart2Easy() throws {
        let actual = day10.solvePart2(easyInput)
        XCTAssertEqual(actual, 8)
    }

    func testPart2Sample() throws {
        let actual = day10.solvePart2(sampleInput)
        XCTAssertEqual(actual, 19208)
    }

    func testPart2Real() throws {
        let actual = day10.solvePart2(realInput)
        XCTAssertEqual(actual, 347_250_213_298_688)
    }
}

// MARK: - Input

// Expected = 8
// (0), 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19, (22)
// (0), 1, 4, 5, 6, 7, 10,     12, 15, 16, 19, (22)
// (0), 1, 4, 5,    7, 10, 11, 12, 15, 16, 19, (22)
// (0), 1, 4, 5,    7, 10,     12, 15, 16, 19, (22)
// (0), 1, 4,    6, 7, 10, 11, 12, 15, 16, 19, (22)
// (0), 1, 4,    6, 7, 10,     12, 15, 16, 19, (22)
// (0), 1, 4,       7, 10, 11, 12, 15, 16, 19, (22)
// (0), 1, 4,       7, 10,     12, 15, 16, 19, (22)
// Val | Child | Paths
// 0   | 1     | 8
// 1   | 1     | 8
// 4   | 3     | 8
// 5   | 2     | 4
// 6   | 1     | 2
// 7   | 1     | 2
// 10  | 2     | 2
// 11  | 1     | 1
// 12  | 1     | 1
// 15  | 1     | 1
// 16  | 1     | 1
// 19  | 1     | 1
// 22  | 0     | 0
let easyInput = """
16
10
15
5
1
11
7
19
6
12
4
"""

let sampleInput = """
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

let realInput = """
46
63
21
115
125
35
89
17
116
90
51
66
111
142
148
60
2
50
82
20
47
24
80
101
103
16
34
72
145
141
124
14
123
27
62
61
95
138
29
7
149
147
104
152
22
81
11
96
97
30
41
98
59
45
88
37
10
114
110
4
56
122
139
117
108
91
36
146
131
109
31
75
70
140
38
121
3
28
118
54
107
84
15
76
71
102
130
132
87
55
129
83
23
42
69
1
77
135
128
94
"""
