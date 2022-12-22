// MARK: - Stack

public extension Array {
    mutating func push(_ element: Element) {
        append(element)
    }

    /// The array must not be empty
    mutating func pop() -> Element {
        removeLast()
    }
}

// MARK: - Safe indexing

extension Array {
    /// Returns the element at `index` if `index` is in `0..<endIndex`, or the default value otherwise.
    ///
    /// Unlike the similar defaulting subscript for dictionaries, this accessor does not create a default element in the collection at the
    /// index if it is out of range. Use this for safely accessing indexes when it is not known ahead of time whether the element exists,
    /// but the collection has a reasonable default value. In cases where you simply want to safely check for the existence of an index,
    /// use ``subscript(nullableIndex index:)``.
    public subscript(index: Int, readonlyDefault defaultValue: @autoclosure () -> Element) -> Element {
        guard (0 ..< endIndex).contains(index) else {
            return defaultValue()
        }

        return self[index]
    }

    /// Returns the element at `index` if `index` is in `0..<endIndex`, or nil otherwise.
    ///
    /// Use this accessor to safely check for the existence of an index without providing a default value. Note that collections containing
    /// optional elements must double-unwrap to confirm whether the index exists or not.
    public subscript(nullableIndex index: Int) -> Element? {
        guard (0 ..< endIndex).contains(index) else {
            return nil
        }

        return self[index]
    }
}

// MARK: - Circular indexing

extension Array {
    public func circularIndexValue(for index: Int) -> Int {
        let mod = isEmpty ? 0 : index % count
        let newIndex = mod < 0 ? mod + count : mod
        return newIndex
    }

    public subscript(circular index: Int) -> Element {
        return self[circularIndexValue(for: index)]
    }

    /// Moves item at oldIndex by the specified offset. The offset will be treated as circular--that is, offsets referring to an index
    /// greater than endIndex will "wrap around" to the front of the collection, while negative offsets referring to an index less than
    /// zero will "wrap around" to the end of the collection.
    ///
    /// - Parameters:
    ///   - oldIndex: the index of the item to move
    ///   - offset: the offset by which to move the item
    public mutating func moveItem(at oldIndex: Int, byCircularOffset offset: Int) {
        let truncatedCount = count - 1
        let mod = isEmpty ? 0 : (oldIndex + offset) % truncatedCount
        let newIndex = mod < 0 ? mod + truncatedCount : mod
        let value = remove(at: oldIndex)
        insert(value, at: newIndex)
    }
}
