@testable import day18
import utils
import XCTest

final class day18Tests: XCTestCase {
    func testCopy() {
        var input: String!
        var original: SnailFishNumber!
        var expected: SnailFishNumber!

        input = "[1,1]"
        original = SnailFishNumber.fromPuzzleInput(input)
        expected = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(original.copy(), expected)

        input = "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
        original = SnailFishNumber.fromPuzzleInput(input)
        expected = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(original.copy(), expected)
    }

    func testParsing() {
        var input: String!
        var expected: String!
        var tree: SnailFishNumber!

        input = "[1,1]"
        expected = "1,1"
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(traverse(tree), expected)
        XCTAssertEqual(tree.depth, 0)
        XCTAssertEqual(tree.left?.depth, 1)

        input = "[2,2]"
        expected = "2,2"
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(traverse(tree), expected)

        input = "[[1,2],[3,4]]"
        expected = "1,2,3,4"
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(traverse(tree), expected)
        XCTAssertEqual(tree.left?.left?.depth, 2)
        XCTAssertEqual(tree.height, 2)

        input = "[[[[[1,2]]]],[3,4]]"
        expected = "1,2,3,4"
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(traverse(tree), expected)
        XCTAssertEqual(tree.left?.left?.left?.left?.left?.depth, 5)

        input = "[[1,8],[[8,7],[3,[1,9]]]]"
        expected = "1,8,8,7,3,1,9"
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(traverse(tree), expected)

        XCTAssertEqual(tree.left?.left?.value, 1)
        XCTAssertEqual(tree.left?.right?.value, 8)
        XCTAssertEqual(tree.left?.left?.depth, 2)

        XCTAssertEqual(tree.right?.left?.left?.value, 8)
        XCTAssertEqual(tree.right?.left?.right?.value, 7)
        XCTAssertEqual(tree.right?.left?.left?.depth, 3)

        XCTAssertEqual(tree.right?.right?.left?.value, 3)
        XCTAssertEqual(tree.right?.right?.left?.depth, 3)

        XCTAssertEqual(tree.right?.right?.right?.left?.value, 1)
        XCTAssertEqual(tree.right?.right?.right?.right?.value, 9)
        XCTAssertEqual(tree.right?.right?.right?.left?.depth, 4)
        XCTAssertEqual(tree.right?.right?.right?.right?.depth, 4)
    }

    func traverse(_ tree: SnailFishNumber) -> String {
        let traversedElements = tree.traverse(.inOrder).compactMap { $0 }
        return traversedElements.map { "\($0)" }.joined(separator: ",")
    }

    func testMagnitude() {
        var input: String!
        var expected: Int!
        var tree: SnailFishNumber!

        input = "[9,1]"
        expected = 29
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[1,9]"
        expected = 21
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[[9,1],[1,9]]"
        expected = 129
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[[1,2],[[3,4],5]]"
        expected = 143
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
        expected = 1384
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[[[[1,1],[2,2]],[3,3]],[4,4]]"
        expected = 445
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[[[[3,0],[5,3]],[4,4]],[5,5]]"
        expected = 791
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[[[[5,0],[7,4]],[5,5]],[6,6]]"
        expected = 1137
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)

        input = "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
        expected = 3488
        tree = SnailFishNumber.fromPuzzleInput(input)
        XCTAssertEqual(tree.magnitude, expected)
    }

    func testExplode() {
        var expected: SnailFishNumber!
        var actual: SnailFishNumber!

        actual = SnailFishNumber.fromPuzzleInput("[1,1]")
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[1,1]")
        XCTAssertEqual(actual, expected)

        actual = SnailFishNumber.fromPuzzleInput("[[[[4,3],4],4],[7,[[8,4],9]]]")
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[[[[4,3],4],4],[7,[[8,4],9]]]")
        XCTAssertEqual(actual, expected)

        actual = SnailFishNumber.fromPuzzleInput("[[[[[9,8],1],2],3],4]")
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[[[[0,9],2],3],4]")
        XCTAssertEqual(actual, expected)

        actual = SnailFishNumber.fromPuzzleInput("[7,[6,[5,[4,[3,2]]]]]")
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[7,[6,[5,[7,0]]]]")
        XCTAssertEqual(actual, expected)

        actual = SnailFishNumber.fromPuzzleInput("[[6,[5,[4,[3,2]]]],1]")
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[[6,[5,[7,0]]],3]")
        XCTAssertEqual(actual, expected)

        actual = SnailFishNumber.fromPuzzleInput("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[[3,[2,[8,0]]],[9,[5,[7,0]]]]")
        XCTAssertEqual(actual, expected)
    }

    func testSplit() {
        var expected: SnailFishNumber!
        var actual: SnailFishNumber!

        actual = SnailFishNumber.fromPuzzleInput("[1,1]")
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[1,1]")
        XCTAssertEqual(actual, expected)

        actual = SnailFishNumber.fromPuzzleInput("[9,9]")
        actual.left!.value! += 1
        actual.right!.value! += 2
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[[5,5],[5,6]]")
        XCTAssertEqual(actual, expected)

        actual = SnailFishNumber.fromPuzzleInput("[9,[9,8]]")
        actual.left!.value! += 2
        actual.reduce()
        expected = SnailFishNumber.fromPuzzleInput("[[5,6],[9,8]]")
        XCTAssertEqual(actual, expected)
    }

    func testAddition() {
        var expected: SnailFishNumber!
        var actual: SnailFishNumber!
        var lhs: SnailFishNumber!
        var rhs: SnailFishNumber!

        lhs = SnailFishNumber.fromPuzzleInput("[1,2]")
        rhs = SnailFishNumber.fromPuzzleInput("[3,4]")
        actual = lhs + rhs
        expected = SnailFishNumber.fromPuzzleInput("[[1,2],[3,4]]")
        XCTAssertEqual(actual, expected)
        XCTAssertEqual(actual.height, 2)
        XCTAssertEqual(actual.left?.left?.depth, 2)

        lhs = SnailFishNumber.fromPuzzleInput("[[1,2],[3,4]]")
        rhs = SnailFishNumber.fromPuzzleInput("[5,6]")
        actual = lhs + rhs
        expected = SnailFishNumber.fromPuzzleInput("[[[1,2],[3,4]],[5,6]]")
        XCTAssertEqual(actual, expected)

        lhs = SnailFishNumber.fromPuzzleInput("[[[1,2],[3,4]],[5,6]]")
        rhs = SnailFishNumber.fromPuzzleInput("[7,8]")
        actual = lhs + rhs
        expected = SnailFishNumber.fromPuzzleInput("[[[[1,2],[3,4]],[5,6]],[7,8]]")
        XCTAssertEqual(actual, expected)

        lhs = SnailFishNumber.fromPuzzleInput("[[[[4,3],4],4],[7,[[8,4],9]]]")
        rhs = SnailFishNumber.fromPuzzleInput("[1,1]")
        actual = lhs + rhs
        expected = SnailFishNumber.fromPuzzleInput("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
        XCTAssertEqual(actual, expected)
    }

    func testSamples() {
        var input: String!
        var actual: SnailFishNumber!
        var expected: SnailFishNumber!

        input = """
        [1,1]
        [2,2]
        [3,3]
        [4,4]
        """
        actual = day18.solve(input)
        expected = SnailFishNumber.fromPuzzleInput("[[[[1,1],[2,2]],[3,3]],[4,4]]")
        XCTAssertEqual(actual, expected)

        input = """
        [1,1]
        [2,2]
        [3,3]
        [4,4]
        [5,5]
        """
        actual = day18.solve(input)
        expected = SnailFishNumber.fromPuzzleInput("[[[[3,0],[5,3]],[4,4]],[5,5]]")
        XCTAssertEqual(actual, expected)

        input = """
        [1,1]
        [2,2]
        [3,3]
        [4,4]
        [5,5]
        [6,6]
        """
        actual = day18.solve(input)
        expected = SnailFishNumber.fromPuzzleInput("[[[[5,0],[7,4]],[5,5]],[6,6]]")
        XCTAssertEqual(actual, expected)

        input = """
        [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
        [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
        """
        actual = day18.solve(input)
        expected = SnailFishNumber.fromPuzzleInput("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")
        XCTAssertEqual(actual, expected)

        input = """
        [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
        [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
        [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
        [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
        [7,[5,[[3,8],[1,4]]]]
        [[2,[2,2]],[8,[8,1]]]
        [2,9]
        [1,[[[9,3],9],[[9,0],[0,7]]]]
        [[[5,[7,4]],7],1]
        [[[[4,2],2],6],[8,7]]
        """
        actual = day18.solve(input)
        expected = SnailFishNumber.fromPuzzleInput("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
        XCTAssertEqual(actual, expected)
    }

    func testPart1Sample() {
        let number = day18.solve(sampleInput)
        let expected = 4140
        XCTAssertEqual(number.magnitude, expected)
    }

    func testPart1Real() {
        let number = day18.solve(realInput)
        let expected = 3734
        XCTAssertEqual(number.magnitude, expected)
    }

    func testPart2Sample() {
        let actual = day18.solvePart2(sampleInput)
        let expected = 3993
        XCTAssertEqual(actual, expected)
    }

    func testPart2Real() {
        let actual = day18.solvePart2(realInput)
        let expected = 4837
        XCTAssertEqual(actual, expected)
    }
}

// MARK: - Inputs

let sampleInput = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""

let realInput = """
[[1,8],[[8,7],[3,[1,9]]]]
[[[[8,1],7],[[9,9],[4,8]]],[[7,[7,2]],[2,[1,6]]]]
[[[[0,8],0],[0,[7,2]]],[[[3,2],8],[[5,6],3]]]
[[[7,[7,9]],8],[[[7,0],[7,7]],[[8,2],2]]]
[[5,7],[[0,[1,0]],[2,[4,6]]]]
[[[[7,7],[2,6]],9],[[1,3],[[1,7],7]]]
[[[[5,7],[8,6]],[1,[6,4]]],[7,[[2,8],[9,2]]]]
[[[3,6],[[7,7],[1,0]]],[[1,[9,3]],[[0,9],[9,5]]]]
[[[6,[6,2]],[[3,4],[5,1]]],[[3,[5,6]],[8,[4,8]]]]
[[[[4,9],6],4],[3,[[1,6],[4,3]]]]
[[[[4,9],[6,0]],2],[[0,9],[[8,4],[3,5]]]]
[[5,[8,[1,1]]],[7,[[3,2],2]]]
[1,2]
[[[1,9],[[7,4],4]],[[7,[0,7]],9]]
[[[[5,9],0],[3,8]],[[[4,9],[5,8]],[2,7]]]
[[[[1,1],[4,5]],[7,7]],1]
[[[[4,3],3],[1,6]],[[0,2],8]]
[[[[1,5],9],[[5,5],1]],[[6,1],[[9,9],[3,0]]]]
[[6,9],[[[9,7],[3,8]],[[2,2],[8,7]]]]
[[[6,2],[6,[8,1]]],[[[5,1],1],9]]
[[[8,5],[7,9]],[[5,2],[[1,6],[8,0]]]]
[[[[5,6],[9,1]],3],[[1,7],[6,5]]]
[[[5,7],8],[9,[8,7]]]
[[[[0,7],4],[3,[3,2]]],[[[0,8],5],[[8,8],1]]]
[[[[8,2],[6,5]],[8,6]],[1,[[1,4],[3,7]]]]
[[7,[9,[0,8]]],[[[7,1],[5,5]],[5,[1,5]]]]
[[3,5],[[[7,4],[1,6]],[[6,9],4]]]
[4,[9,4]]
[[3,[5,5]],9]
[[0,2],[[[9,8],9],1]]
[[[0,3],[[9,8],0]],[[5,[5,1]],[7,[6,5]]]]
[[[9,[0,4]],[[0,2],[4,5]]],[3,[2,[9,8]]]]
[[[2,6],[[3,5],5]],[0,[9,7]]]
[[[6,[0,8]],9],[8,7]]
[[[[8,2],3],[6,6]],[6,[5,[7,8]]]]
[[[9,[3,6]],[0,6]],[9,[[4,4],5]]]
[[[3,2],5],2]
[[[2,1],[[6,7],1]],[[7,[7,0]],5]]
[[[[1,3],1],[1,5]],[[1,3],[[5,6],1]]]
[[[3,[9,9]],[2,6]],[[[3,4],[5,8]],[1,[1,9]]]]
[[[0,2],[4,[5,0]]],9]
[[9,0],[7,[7,[9,9]]]]
[[[8,[4,9]],[6,[4,8]]],[[3,6],[7,[9,1]]]]
[[7,[6,[5,7]]],[[[0,9],[9,2]],1]]
[8,[6,[[9,7],[5,7]]]]
[[[7,[6,1]],[9,[4,9]]],[[[2,0],7],[8,7]]]
[[5,[[4,1],[2,7]]],[0,[2,[5,3]]]]
[[[0,8],[0,5]],2]
[[[3,[9,8]],9],[1,2]]
[[[[7,1],9],2],[[[4,6],[0,5]],[6,8]]]
[4,[[[5,3],3],[[1,8],3]]]
[[[3,0],[[5,0],[3,9]]],[6,[9,2]]]
[[[6,6],[[8,2],6]],[[[0,6],8],[[3,3],[1,2]]]]
[[6,[[5,2],[2,8]]],[1,7]]
[[4,3],[[[1,5],0],[[1,4],6]]]
[[7,[[2,7],7]],[[[4,2],[4,5]],[[5,3],3]]]
[[0,1],[[9,[1,0]],9]]
[[[[4,5],[1,8]],[5,1]],[[[4,6],[6,0]],[3,[1,4]]]]
[[[[7,5],[0,9]],[[1,0],[2,7]]],[[9,4],[6,[7,7]]]]
[[[3,1],9],[[[7,9],[4,7]],[[4,0],2]]]
[[[9,[2,3]],[4,[3,1]]],[[9,[1,7]],[8,[9,6]]]]
[[[2,2],0],[[9,[0,1]],[2,[2,4]]]]
[9,[[6,9],[[2,5],[1,1]]]]
[[2,9],[[[8,8],9],[[4,0],[8,2]]]]
[1,[[8,[7,4]],8]]
[[[[0,3],2],[[0,6],[3,8]]],6]
[[[[3,7],[1,3]],[4,[0,3]]],[[[7,7],1],[[2,9],1]]]
[[[4,[5,0]],[[1,1],6]],[[3,4],[8,5]]]
[8,[2,[[0,4],9]]]
[[[7,1],8],[[0,2],[[8,7],6]]]
[[[4,0],4],[[4,[2,4]],[2,[1,8]]]]
[[[1,5],[2,[5,4]]],[2,5]]
[[[9,[6,7]],[1,6]],[[[0,3],[8,2]],[9,7]]]
[[[[4,9],[4,0]],[[6,7],[5,9]]],[[[7,0],1],[[0,1],[4,6]]]]
[[[8,[2,3]],[[1,6],[2,9]]],[[6,9],[4,[2,3]]]]
[[[3,1],7],[[[6,9],[9,2]],[[3,9],2]]]
[[9,[[8,3],[0,9]]],[[0,8],8]]
[[[[4,8],4],[5,[3,3]]],[8,[6,4]]]
[[[[0,8],[1,6]],[[9,4],3]],2]
[[[7,[8,2]],[[9,0],1]],[[2,7],[[3,0],[8,6]]]]
[[4,[1,[4,7]]],[[[2,6],4],[[5,3],9]]]
[[0,5],[8,[[1,8],0]]]
[[[1,[3,3]],9],[2,1]]
[[[[5,0],[2,4]],[[1,7],0]],[[[5,3],4],5]]
[[[9,[1,1]],7],[9,[7,1]]]
[[[[5,5],9],4],[2,9]]
[[5,[5,[6,8]]],9]
[[[9,[1,6]],[[1,7],7]],[[7,3],[5,4]]]
[[3,[[7,5],4]],[[[9,6],[7,1]],1]]
[[[[8,7],1],3],[[2,[3,1]],[4,8]]]
[[[4,[5,5]],0],[[7,8],[1,[5,6]]]]
[[[[1,1],[9,2]],[1,[3,5]]],[[7,[2,1]],[2,[7,3]]]]
[[[[3,7],[0,9]],0],[[0,8],[9,[2,8]]]]
[[[7,[3,9]],[5,[1,6]]],[[[8,4],7],[[5,6],3]]]
[[[[0,7],[4,3]],[1,[0,8]]],[[6,9],2]]
[[[8,9],[8,3]],[[6,[0,1]],[7,8]]]
[[[[6,6],9],[8,0]],[[9,[7,2]],[0,3]]]
[[[[8,9],[0,0]],[9,3]],[3,[9,[8,9]]]]
[[[8,[8,5]],[6,[9,1]]],8]
[[6,[[1,0],8]],[4,6]]
"""
