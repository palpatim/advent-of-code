// Convenience methods to add stack-like aliases to Array

public extension Array {
    mutating func push(_ element: Element) {
        append(element)
    }

    /// The array must not be empty
    mutating func pop() -> Element {
        removeLast()
    }
}
