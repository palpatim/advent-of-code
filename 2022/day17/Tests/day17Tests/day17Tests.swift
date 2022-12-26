import DequeModule
import utils
import XCTest

let shouldPrettyPrint: Bool = false
let shouldPrettyPrintWhileFalling: Bool = false

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", rockCount: 2022)
        XCTAssertEqual(actual, 3068)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", rockCount: 2022)
        XCTAssertEqual(actual, 3111)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", rockCount: 1_000_000_000_000)
        XCTAssertEqual(actual, 1_514_285_714_288)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", rockCount: 1_000_000_000_000)
        XCTAssertEqual(actual, 1526744186042)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        rockCount: Int
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let gasPattern = Array(try! String(contentsOf: fileURL))

        return getChamberHeight(
            rocksToDrop: rockCount,
            gasPattern: gasPattern
        )
    }

    static func getChamberHeight(
        rocksToDrop: Int,
        gasPattern: [Character]
    ) -> Int {
        let chamber = Chamber()

        var fallenRocks = 0
        var overallIterations = 0
        var seen = [String: (fallenRocks: Int, height: Int)]()

        while fallenRocks < rocksToDrop {
            let spriteIndex = fallenRocks % Sprite.allSprites.count
            let sprite = Sprite.allSprites[spriteIndex]
            chamber.addSprite(sprite)
            var isFalling = true

            while isFalling {
                defer {
                    overallIterations += 1
                }

                let gas = gasPattern[overallIterations % gasPattern.count]

                let direction: Chamber.SpriteDirection
                switch gas {
                case "<": direction = .left
                case ">": direction = .right
                default:
                    fatalError("Unexpected gas: \(gas)")
                }

                if shouldPrettyPrintWhileFalling {
                    chamber.prettyPrint("\niterations: \(overallIterations), rock \(fallenRocks), gas \(gas)")
                }

                _ = chamber.moveCurrentSprite(direction)

                guard chamber.moveCurrentSprite(.down) else {
                    isFalling = false
                    chamber.render()
                    break
                }
            }

            if shouldPrettyPrint {
                chamber.prettyPrint("\n== Rock \(fallenRocks) came to rest; height: \(chamber.height) ==")
            }

            let gasIndex = (overallIterations - 1) % gasPattern.count
            let key = "\(spriteIndex)|\(gasIndex)"

            if let previous = seen[key] {
                // Thanks to https://github.com/jpignata/adventofcode/blob/main/2022/17/solve.py
                // from https://github.com/jpignata for helping me understand that we need to look
                // for a cycle in the *remaining* time, not just a cycle in the *completed* time
                print("Found cycle at rock \(fallenRocks)")
                let remainingRocks = rocksToDrop - fallenRocks - 1
                let cyclePeriod = fallenRocks - previous.fallenRocks

                if remainingRocks % cyclePeriod == 0 {
                    print("Solution: using cycle at rock \(fallenRocks)")
                    let heightPerCycle = chamber.height - previous.height
                    let remainingCycles = remainingRocks / cyclePeriod
                    let totalHeight = (remainingCycles * heightPerCycle) + chamber.height
                    return totalHeight
                }
            }
            seen[key] = (fallenRocks: fallenRocks, height: chamber.height)
            fallenRocks += 1
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

    init(stringLiteral: String, verifyHeight: Int, verifyWidth: Int) {
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

        width = maxWidth
        self.bitmap = bitmap

        guard
            self.height == verifyHeight,
            self.width == verifyWidth
        else {
            fatalError("Failed verification")
        }
    }
}

extension Sprite {
    static let allSprites = [one, two, three, four, five]

    static let one = Sprite(stringLiteral: "####", verifyHeight: 1, verifyWidth: 4)

    static let two = Sprite(stringLiteral: """
    .#.
    ###
    .#.
    """, verifyHeight: 3, verifyWidth: 3)

    static let three = Sprite(stringLiteral: """
    ..#
    ..#
    ###
    """, verifyHeight: 3, verifyWidth: 3)

    static let four = Sprite(stringLiteral: """
    #
    #
    #
    #
    """, verifyHeight: 4, verifyWidth: 1)

    static let five = Sprite(stringLiteral: """
    ##
    ##
    """, verifyHeight: 2, verifyWidth: 2)
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
        rows = [127]
        currentSprite = nil
    }

    /// Add sprite to the chamber 3 rows above the row containing the topmost rock, and 2 spaces away from the left edge. Returns
    /// the horizontal offset of the sprite (that is, the number of spaces the sprite was left-shifted to put it into its starting position)
    func addSprite(_ sprite: Sprite) {
        let offset = Chamber.width - Chamber.spriteLeftStartPosition - sprite.width
        currentSprite = CurrentSprite(sprite: sprite, xOffset: offset, yOffset: 0)

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

        currentSprite = nil
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

        if collides() {
            currentSprite.yOffset -= 1
            return false
        } else {
            return true
        }
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

}

extension Chamber {
    enum MapSymbol: Character {
        case open = "."
        case wall = "|"
        case floor = "-"
        case restingRock = "#"
        case fallingRock = "@"
        case collision = "*"
    }

    /// Prints a map of the chamber.
    ///
    /// Legend:
    /// - `.`: Open space
    /// - `|`: Wall
    /// - `-`: Floor
    /// - `#`: Rock at rest
    /// - `@`: Falling rock
    /// - `*`: Collision (does not show collisions between falling rock and right wall)
    func prettyPrint(_ header: String? = nil) {
        if let header {
            print(header)
        }
        print("rows: \(rows)")

        let output = (0 ..< rows.count).map { prettyPrintRow(at: $0) }

        print(output.joined(separator: "\n"))
    }

    func prettyPrintRow(at index: Int) -> String {
        guard index < rows.count - 1 else {
            return "+-------+"
        }

        var chars = [MapSymbol]()

        if
            let currentSprite,
            (
                currentSprite.yOffset ..< currentSprite.yOffset + currentSprite.sprite.height
            ).contains(index)
        {
            let spriteRow = currentSprite.xOffsetBitmap[index - currentSprite.yOffset]

            // Now test each bit of the row to fill in the appropriate character
            for shift in 0 ..< 7 {
                let test: UInt8 = 1 << shift
                let occupiedByCurrentSprite = spriteRow & test > 0
                let occupiedByExistingRock = rows[index] & test > 0
                switch (occupiedByCurrentSprite, occupiedByExistingRock) {
                case (true, true): chars.insert(.collision, at: 0)
                case (true, false): chars.insert(.fallingRock, at: 0)
                case (false, true): chars.insert(.restingRock, at: 0)
                case (false, false): chars.insert(.open, at: 0)
                }
            }
        } else {
            chars.append(
                contentsOf:
                    String(rows[index], radix: 2)
                    .map { $0 == "1" ? MapSymbol.restingRock : .open }
            )
        }
        let convertedRow = String(chars.map { $0.rawValue })
        let formattedRow = convertedRow.leftPadding(toLength: 7, withPad: ".")
        return "|\(formattedRow)|"
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let newLength = count
        if newLength < toLength {
            return String(repeatElement(character, count: toLength - newLength)) + self
        } else {
            return self
        }
    }
}
