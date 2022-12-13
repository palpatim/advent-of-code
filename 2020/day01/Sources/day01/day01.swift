public enum day01 {
    public static func solve(
        forNElements n: Int,
        input: [Int],
        target: Int
    ) -> Int {
        guard n >= 2 else {
            preconditionFailure("n must be >= 2, got \(n)")
        }

        guard input.count >= 2 else {
            preconditionFailure("input length must be >= 2, got \(input.count)")
        }

        guard let entries = findNElements(
            n: n,
            input: input,
            target: target
        ) else {
            preconditionFailure("Could not find solution")
        }

        let product = entries.reduce(1, *)
        return product
    }

    private static func findNElements(
        n: Int,
        input: [Int],
        target: Int
    ) -> [Int]? {
        var visited = Set<Int>()
        var result: [Int]?

        for element in input {
            let complement = target - element

            if n == 2 {
                if visited.contains(complement) {
                    result = [element, complement]
                    break
                } else {
                    visited.insert(element)
                }
            } else {
                if let interimResult = findNElements(
                    n: n - 1,
                    input: input.filter { $0 != element },
                    target: complement
                ) {
                    result = interimResult
                    result!.append(element)
                    break
                }
            }
        }

        return result
    }
}
