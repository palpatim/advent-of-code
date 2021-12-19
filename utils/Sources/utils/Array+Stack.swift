// Convenience methods to add stack-like aliases to Array

extension Array {
    mutating public func push(_ element: Element) {
        append(element)
    }

    /// The array must not be empty
    mutating public func pop() -> Element {
        removeLast()
    }
}
