import Foundation

public enum day12 {
    public static func solve(_ input: String, allowingRepeat: Bool) -> Int {
        let start = parseInput(input)
        let paths = getAllPaths(from: start, allowingRepeat: allowingRepeat)
        return paths
    }

    // Returns `start`
    private static func parseInput(_ input: String) -> Cave {
        let lines = input.components(separatedBy: "\n")

        var cavesByID = [String: Cave]()
        for line in lines {
            let caveIDs = line.components(separatedBy: "-")
            let cave0 = cavesByID[caveIDs[0], default: Cave(id: caveIDs[0])]
            cavesByID[cave0.id] = cave0

            let cave1 = cavesByID[caveIDs[1], default: Cave(id: caveIDs[1])]
            cavesByID[cave1.id] = cave1

            cave1.neighbors.insert(cave0)
            cave0.neighbors.insert(cave1)
        }

        return cavesByID["start"]!
    }

    private static func getAllPaths(
        from start: Cave,
        allowingRepeat: Bool
    ) -> Int {
        var allPaths = [[Cave]]()

        var stack = [[start]]

        while !stack.isEmpty {
            let currentPath = stack.removeLast()
            let currentCave = currentPath.last!

            if currentCave.id == "end" {
                allPaths.append(currentPath)
                continue
            }

            let candidatePaths = getCandidatePaths(
                for: currentCave,
                in: currentPath,
                allowingRepeat: allowingRepeat
            )
            stack.append(contentsOf: candidatePaths)
        }

        return allPaths.count
    }

    /// Given a candidate cave and previous path, create candidate paths. If no previous cave has been repeated, then
    /// one of the candidate paths will include.
    private static func getCandidatePaths(
        for cave: Cave,
        in path: [Cave],
        allowingRepeat: Bool
    ) -> [[Cave]] {
        let containsRepeat = path
            .filter { $0.isSmall }
            .containsRepeatedElement()

        // If the path already contains a repeated small element, we can only consider
        // unvisited small caves
        let neighbors: [Cave]
        if containsRepeat || !allowingRepeat {
            neighbors = cave.neighbors.filter {
                !$0.isSmall || !path.contains($0)
            }
        } else {
            neighbors = Array(cave.neighbors.filter { $0.id != "start" })
        }

        var candidatePaths = [[Cave]]()
        for neighbor in neighbors {
            var candidatePath = path
            candidatePath.append(neighbor)
            candidatePaths.append(candidatePath)
        }

        return candidatePaths
    }
}

class Cave {
    let id: String
    let isSmall: Bool
    var neighbors: Set<Cave>

    public init(id: String) {
        self.id = id
        isSmall = id == id.lowercased()
        neighbors = []
    }
}

extension Cave: Equatable {
    public static func == (_ lhs: Cave, _ rhs: Cave) -> Bool {
        lhs.id == rhs.id
    }
}

extension Cave: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension Cave: CustomDebugStringConvertible {
    public var debugDescription: String {
        id
    }
}

public extension Sequence where Element: Hashable {
    /// True if the sequence contains any repeated element
    func containsRepeatedElement() -> Bool {
        var seen = Set<Element>()
        for element in self {
            guard !seen.contains(element) else {
                return true
            }
            seen.insert(element)
        }
        return false
    }
}
