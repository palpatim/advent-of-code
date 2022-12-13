import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .notExceedingThreshold(100_000))
        XCTAssertEqual(actual, 95437)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .notExceedingThreshold(100_000))
        XCTAssertEqual(actual, 1_477_771)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .applyingUpdateSize(30_000_000))
        XCTAssertEqual(actual, 24_933_642)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .applyingUpdateSize(30_000_000))
        XCTAssertEqual(actual, 3_579_501)
    }
}

// MARK: - Solution

enum Strategy {
    case notExceedingThreshold(Int)
    case applyingUpdateSize(Int)
}

enum Solution {
    static let fileSystemSize = 70_000_000

    static func solve(
        _ fileName: String,
        strategy: Strategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var currentNode: DirectoryNode!

        // Note: `size` is memoized. Don't call `size` until directory tree is fully populated
        for line in try String.lines(fromFile: fileURL) {
            if line.starts(with: "$") {
                let command = Command(terminalOutput: line)
                switch command {
                case .ls:
                    break
                case let .cd(argument):
                    switch argument {
                    case "/":
                        currentNode = currentNode?.root ?? DirectoryNode(.directory, name: "/")
                    case "..":
                        guard let parent = currentNode.parent else {
                            fatalError("No parent directory for \(currentNode.name)")
                        }
                        currentNode = parent
                    default:
                        guard let child = currentNode.child(named: argument) else {
                            fatalError("No such directory of \(currentNode.name): \(argument)")
                        }
                        currentNode = child
                    }
                }
                continue
            }

            let node = DirectoryNode(terminalOutput: line)
            node.parent = currentNode
            currentNode.children.append(node)
        }

        let root = currentNode.root

        switch strategy {
        case let .notExceedingThreshold(sizeThreshold):
            return root
                .childDirectoriesRecursive
                .map { $0.size }
                .filter { $0 <= sizeThreshold }
                .reduce(0, +)
        case let .applyingUpdateSize(updateSize):
            let availableSpace = fileSystemSize - root.size
            let spaceToFree = updateSize - availableSpace
            return root
                .childDirectoriesRecursive
                .map { $0.size }
                .filter { $0 >= spaceToFree }
                .min()!
        }
    }
}

// MARK: - Structures

class DirectoryNode {
    enum NodeType {
        case directory
        case file(size: Int)
    }

    let name: String
    let nodeType: NodeType
    var parent: DirectoryNode?
    var children: [DirectoryNode]

    var root: DirectoryNode {
        if let parent {
            return parent.root
        }
        return self
    }

    var isDirectory: Bool {
        switch nodeType {
        case .directory: return true
        default: return false
        }
    }

    var childDirectories: [DirectoryNode] {
        children.filter { $0.isDirectory }
    }

    var childDirectoriesRecursive: [DirectoryNode] {
        var result = isDirectory ? [self] : []
        for dir in childDirectories {
            result.append(contentsOf: dir.childDirectoriesRecursive)
        }
        return result
    }

    private var _size: Int!
    var size: Int {
        if let _size {
            return _size
        }
        switch nodeType {
        case let .file(size):
            _size = size
            return size
        case .directory:
            _size = children
                .map { $0.size }
                .reduce(0, +)
            return _size
        }
    }

    convenience init(terminalOutput line: String) {
        let components = line.components(separatedBy: .whitespaces)
        let name = components[1]
        if components[0] == "dir" {
            self.init(.directory, name: name)
        } else {
            guard let size = Int(components[0]) else {
                fatalError("Unexpected dir list format: \(line)")
            }
            self.init(.file(size: size), name: name)
        }
    }

    init(_ nodeType: NodeType, name: String) {
        self.nodeType = nodeType
        self.name = name
        parent = nil
        children = []
    }

    func child(named name: String) -> DirectoryNode? {
        children.first { $0.name == name }
    }
}

enum Command {
    case cd(argument: String)
    case ls

    /// Creates a Command from a line of terminal output starting with "$"
    init(terminalOutput line: String) {
        let components = line.components(separatedBy: .whitespaces)

        guard components[0] == "$" else {
            fatalError("Unexpected command line format: \(line)")
        }

        let instruction = components[1]

        if instruction == "cd" {
            self = .cd(argument: components[2])
            return
        }
        self = .ls
    }
}
