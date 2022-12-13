import Foundation

public enum day02 {
    public static func solvePart1(_ input: String) -> Int {
        let commands = parseInput(input)
        let position = executePart1(commands: commands)
        return position.horizontal * position.depth
    }

    public static func solvePart2(_ input: String) -> Int {
        let commands = parseInput(input)
        let position = executePart2(commands: commands)
        return position.horizontal * position.depth
    }

    public static func parseInput(_ input: String) -> [Command] {
        let lines = input.components(separatedBy: "\n")
        let commands = lines.map { Command(rawValue: $0) }
        return commands
    }

    private static func executePart1(commands: [Command]) -> Position {
        var position = Position()
        commands.forEach { position.applyCommandPart1($0) }
        return position
    }

    private static func executePart2(commands: [Command]) -> Position {
        var position = Position()
        commands.forEach { position.applyCommandPart2($0) }
        return position
    }
}

public enum Command {
    case forward(Int)
    case up(Int)
    case down(Int)

    // Would normally be optional, but we're trusting the input to be right
    // - No unrecognized commands
    // - Values are all unsigned integers
    init(rawValue: String) {
        let components = rawValue.components(separatedBy: " ")
        let value = Int(components[1])!
        switch components[0] {
        case "forward":
            self = .forward(value)
        case "up":
            self = .up(value)
        case "down":
            self = .down(value)
        default:
            fatalError("Unexpected command: \(components[0])")
        }
    }
}

public struct Position {
    var horizontal = 0
    var depth = 0
    var aim = 0

    mutating func applyCommandPart1(_ command: Command) {
        switch command {
        case let .down(value):
            depth += value
        case let .up(value):
            depth -= value
        case let .forward(value):
            horizontal += value
        }
    }

    mutating func applyCommandPart2(_ command: Command) {
        switch command {
        case let .down(value):
            aim += value
        case let .up(value):
            aim -= value
        case let .forward(value):
            horizontal += value
            depth += aim * value
        }
    }
}
