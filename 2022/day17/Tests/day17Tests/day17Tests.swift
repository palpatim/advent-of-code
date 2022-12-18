import DequeModule
import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        // Returns 2637 :( 
        XCTAssertEqual(actual, 3068)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, -1)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, -1)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, -1)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let gasPattern = Array(try! String(contentsOf: fileURL))

        return getChamberHeight(
            rockCount: 2022,
            gasPattern: gasPattern
        )
    }

    static func getChamberHeight(
        rockCount: Int,
        gasPattern: [Character]
    ) -> Int {
        let chamber = Chamber()

        var rocks = 0
        var overallIterations = 0
        while rocks < rockCount {
            defer {
                rocks += 1
            }
            let sprite = Sprite.allSprites[rocks % Sprite.allSprites.count]
            chamber.addSprite(sprite)
            var isFalling = true

            while isFalling {
                defer {
                    overallIterations += 1
                }
                let gas = gasPattern[overallIterations % gasPattern.count]

                let direction: Chamber.SpriteDirection = gas == "<" ? .left : .right
                _ = chamber.moveCurrentSprite(direction)

                guard chamber.moveCurrentSprite(.down) else {
                    isFalling = false
                    chamber.render()
                    break
                }
            }
        }

        // chamber.prettyPrint()
        return chamber.height
    }

}

// MARK: - Structures

/// Defines a sprite bitmap and position.
///
/// Horizontal position within the chamber is tracked in each line of the bitmap. Since the chamber is 7 spaces wide, the leftmost edge
/// is position 8, and the rightmost edge is position 0:
/// ```
/// | # |   |   |   |   |   |   |   | #
/// | W |   |   |   |   |   |   |   | W
/// | A |   |   |   |   |   |   |   | A
/// | L |   |   |   |   |   |   |   | L
/// | L |   |   |   |   |   |   |   | L
/// | # |   |   |   |   |   |   |   | #
/// +---+---+---+---+---+---+---+---+
///   7   6   5   4   3   2   1   0
/// ```
///
/// Since we don't actually add values to represent walls, we will check for the bit positions of the sprite's leftmost & rightmost bit
/// to check for collisions with a wall
struct Sprite {
    var bitmap: [UInt8]

    var height: Int {
        bitmap.count
    }

    /// Width of the widest part of the bitmap, to make it easier to check wall collisions
    let width: UInt8

    init(stringLiteral: String) {
        let lines = stringLiteral.lines
        var bitmap = [UInt8]()
        var maxWidth: UInt8 = 0
        for line in lines {
            var row: UInt8 = 0
            maxWidth = max(maxWidth, UInt8(line.count))
            // Reverse the line to ensure the rightmost bit is in the least significant position.
            // This only matters for sprite 3, but we'll do it as a general rule.
            for (charIndex, char) in line.reversed().enumerated() {
                guard char == "#" else {
                    continue
                }
                row |= 1 << charIndex
            }
            bitmap.append(row)
        }

        self.width = maxWidth
        self.bitmap = bitmap
    }
}

extension Sprite {

    static let allSprites = [one, two, three, four, five]

    static let one = Sprite(stringLiteral: "####")

    static let two = Sprite(stringLiteral: """
    .#.
    ###
    .#.
    """)

    static let three = Sprite(stringLiteral: """
    ..#
    ..#
    ###
    """)

    static let four = Sprite(stringLiteral: """
    #
    #
    #
    #
    """)

    static let five = Sprite(stringLiteral: """
    ##
    ##
    """)
}

class Chamber {
    enum SpriteDirection {
        case down, left, right
    }

    /// Overall width of chamber (that is, the empty space between vertical walls)
    static let width: UInt8 = 7
    static let spriteLeftStartPosition: UInt8 = 2
    static let newSpriteBuffer: [UInt8] = [0, 0, 0]

    private struct CurrentSprite {
        var sprite: Sprite
        var xOffset: UInt8
        var yOffset: Int

        /// Returns the bitmap of the sprite, with each row offset by `xOffset`
        var xOffsetBitmap: [UInt8] {
            sprite.bitmap.map { $0 << xOffset }
        }
    }

    /// The floor of the chamber is always the last index of `rows`
    var rows: Deque<UInt8>

    /// The height of the chamber, from the floor to the topmost rock
    var height: Int {
        rows.count - 1
    }

    private var currentSprite: CurrentSprite!

    init() {
        self.rows = [127]
        self.currentSprite = nil
    }

    /// Add sprite to the chamber 3 rows above the row containing the topmost rock, and 2 spaces away from the left edge. Returns
    /// the horizontal offset of the sprite (that is, the number of spaces the sprite was left-shifted to put it into its starting position)
    func addSprite(_ sprite: Sprite) {
        let offset = Chamber.width - Chamber.spriteLeftStartPosition - sprite.width
        self.currentSprite = CurrentSprite(sprite: sprite, xOffset: offset, yOffset: 0)

        for _ in 0 ..< sprite.height + 3 {
            rows.prepend(0)
        }
    }

    func moveCurrentSprite(_ direction: SpriteDirection) -> Bool {
        switch direction {
        case .down: return moveDown()
        case .left: return moveLeft()
        case .right: return moveRight()
        }
    }

    /// Renders the current sprite and truncates the rows so that the topmost row is a rock
    func render() {
        for (index, bitmapRow) in currentSprite.xOffsetBitmap.enumerated() {
            rows[index + currentSprite.yOffset] |= bitmapRow
        }

        if let idx = rows.firstIndex(where: { $0 > 0 }) {
            rows.removeFirst(idx)
        }
    }

    /// Attempt to move sprite down by specified offset. Return true if move was successful, false if blocked. If blocked, sprite comes
    /// to rest at current position. Row 0 contains the topmost rock of the chamber
    ///
    /// Move could be blocked by the floor or another sprite.
    private func moveDown() -> Bool {
        let lastRowOfSprite = currentSprite.xOffsetBitmap.last!
        let targetRow = rows[currentSprite.sprite.height + currentSprite.yOffset]

        guard lastRowOfSprite & targetRow == 0 else {
            return false
        }

        currentSprite.yOffset += 1
        return true
    }

    /// Attempt to move sprite left by specified offset. Return true if move was successful, false if blocked.
    ///
    /// Move could be blocked by the wall or another sprite.
    private func moveLeft() -> Bool {
        // Blocked by wall
        guard currentSprite.xOffset + currentSprite.sprite.width < Chamber.width else {
            return false
        }

        currentSprite.xOffset += 1

        if collides() {
            currentSprite.xOffset -= 1
            return false
        } else {
            return true
        }
    }

    /// Attempt to move sprite right by specified offset. Return true if move was successful, false if blocked.
    ///
    /// Move could be blocked by the wall or another sprite.
    private func moveRight() -> Bool {
        // Blocked by wall
        guard currentSprite.xOffset > 0 else {
            return false
        }

        currentSprite.xOffset -= 1

        if collides() {
            currentSprite.xOffset += 1
            return false
        } else {
            return true
        }
    }

    /// Bool check if the current sprite collides with the existing chamber bitmap. The current sprite must not yet be rendered, or it
    /// will return true because it will collide with itself.
    private func collides() -> Bool {
        for (index, bitmapRow) in currentSprite.xOffsetBitmap.enumerated() {
            if rows[index + currentSprite.yOffset] & bitmapRow > 0 {
                return true
            }
        }
        return false
    }

//    /// Clears the current sprite from the bitmap
//    private func clearCurrentSprite() {
//        let invertedRows = currentSprite.xOffsetBitmap.map { ~$0 }
//        for (index, invertedRow) in invertedRows.enumerated() {
//            rows[index + currentSprite.yOffset] &= invertedRow
//        }
//    }
}

extension Chamber {
    func prettyPrint() {
        print("rows: \(rows)")

        var output = [String]()
        for row in rows.prefix(upTo: rows.count - 1) {
            let convertedRow = String(row, radix: 2)
                .map({ $0 == "1" ? "#" : "." })
                .joined()
            let formattedRow = convertedRow.leftPadding(toLength: 7, withPad: ".")
            output.append("|\(formattedRow)|")
        }
        output.append("+-------+")
        print(output.joined(separator: "\n"))
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let newLength = self.count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return self
        }
    }
}

