import OrderedCollections
import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt")
        XCTAssertEqual(actual, 3)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt")
        XCTAssertEqual(actual, 18257)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", key: 811_589_153, mixCount: 10)
        XCTAssertEqual(actual, 1_623_178_306)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", key: 811_589_153, mixCount: 10)
        XCTAssertEqual(actual, 4_148_032_160_983)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        key: Int = 1,
        mixCount: Int = 1
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let numbers = try String
            .lines(fromFile: fileURL)
            .filter { !$0.isEmpty }
            .map { Int($0)! * key }

        let decrypted = mix(numbers, mixCount: mixCount)

        let zeroIndex = decrypted.firstIndex(of: 0)!

        let result = [1000, 2000, 3000]
            .map { decrypted[circular: $0 + zeroIndex] }
            .reduce(0, +)

        return result
    }

    static func mix(_ numbers: [Int], mixCount: Int) -> [Int] {
        var working = OrderedSet(
            numbers.toPositionedItems()
        )

        for _ in 0 ..< mixCount {
            for currentItem in numbers.toPositionedItems() {
                let oldIndex = working.firstIndex { $0 == currentItem }!
                working.moveItem(at: oldIndex, byCircularOffset: currentItem.value)
            }
        }

        return working.map { $0.value }
    }
}

// MARK: - Structures

struct PositionedItem<Value>: Hashable where Value: Hashable {
    let originalIndex: Int
    let value: Value
}

extension Array where Element: Hashable {
    func toPositionedItems() -> [PositionedItem<Element>] {
        enumerated()
            .map { PositionedItem(originalIndex: $0.0, value: $0.1) }
    }
}

extension OrderedSet {
    func circularIndexValue(for index: Int) -> Int {
        let mod = isEmpty ? 0 : index % count
        let newIndex = mod < 0 ? mod + count : mod
        return newIndex
    }

    subscript(circular index: Int) -> Element {
        return self[circularIndexValue(for: index)]
    }

    /// Moves item at oldIndex by the specified offset. The offset will be treated as circular--that is, offsets referring to an index
    /// greater than endIndex will "wrap around" to the front of the collection, while negative offsets referring to an index less than
    /// zero will "wrap around" to the end of the collection.
    ///
    /// - Parameters:
    ///   - oldIndex: the index of the item to move
    ///   - offset: the offset by which to move the item
    mutating func moveItem(at oldIndex: Int, byCircularOffset offset: Int) {
        let truncatedCount = count - 1
        let mod = isEmpty ? 0 : (oldIndex + offset) % truncatedCount
        let newIndex = mod < 0 ? mod + truncatedCount : mod
        let value = remove(at: oldIndex)
        insert(value, at: newIndex)
    }
}
