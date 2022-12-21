//
//  Array+Circular.swift
//
//
//  Created by Schmelter, Tim on 12/21/22.
//

import Foundation

extension Array {
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
