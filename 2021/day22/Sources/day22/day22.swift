import Foundation
import utils

public struct day22 {
    public static func solve(_ input: String, shouldClamp: Bool = true) -> Int {
        let commands = parseInput(input, shouldClamp: shouldClamp)
        let activated = execute(bootCommands: commands)
        return activated.count
    }

    private static func parseInput(_ input: String, shouldClamp: Bool) -> [Command] {
        let clampRange = shouldClamp ? Puzzle.part1ValidRange : nil
        return input
            .components(separatedBy: "\n")
            .compactMap { Command.from(puzzleInput: $0, clampingTo: clampRange) }
    }

    private static func execute(bootCommands: [Command]) -> Set<Coordinate3D> {
        var activated = Set<Coordinate3D>()

        for command in bootCommands {
            if command.on {
                activated = activated.union(command.coordinates())
            } else {
                activated = activated.subtracting(command.coordinates())
            }
        }

        return activated
    }

}

public struct Command {
    public let on: Bool
    public let x: ClosedRange<Int>
    public let y: ClosedRange<Int>
    public let z: ClosedRange<Int>

    public func coordinates() -> Set<Coordinate3D> {
        var coordinates = Set<Coordinate3D>()
        for xCoord in x {
            for yCoord in y {
                for zCoord in z {
                    let coord = Coordinate3D(x: xCoord, y: yCoord, z: zCoord)
                    coordinates.insert(coord)
                }
            }
        }
        return coordinates
    }

    public static func from(
        puzzleInput: String,
        clampingTo clampRange: ClosedRange<Int>?
    ) -> Command? {
        let components = puzzleInput.components(separatedBy: " ")

        let on = components[0].starts(with: "on")

        let ranges = components[1]
            .components(separatedBy: ",")
            .map { $0.components(separatedBy: "=") }

        let xRange = Command.range(from: ranges[0][1])
        let yRange = Command.range(from: ranges[1][1])
        let zRange = Command.range(from: ranges[2][1])

        if let clampRange = clampRange {
            guard
                xRange.overlaps(clampRange),
                    yRange.overlaps(clampRange),
                    zRange.overlaps(clampRange)
            else {
                return nil
            }
        }

        return Command(
            on: on,
            x: xRange,
            y: yRange,
            z: zRange
        )
    }

    public init(
        on: Bool,
        x: ClosedRange<Int>,
        y: ClosedRange<Int>,
        z: ClosedRange<Int>
    ) {
        self.on = on
        self.x = x
        self.y = y
        self.z = z
    }

    private static func range(from puzzleInputSubstring: String) -> ClosedRange<Int> {
        let bounds = puzzleInputSubstring.components(separatedBy: "..").map { Int($0)! }
        return bounds[0] ... bounds[1]
    }
}

struct Puzzle {
    static let part1ValidRange = -50 ... 50
    let commands: [Command]
}
