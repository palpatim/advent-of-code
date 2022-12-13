import Foundation

public enum day12 {
    public static func solvePart1(_ input: String) -> Int {
        let commands = parseInput(input)
        var boat = Boat(position: GridPoint(x: 0, y: 0), heading: .e)
        navigate(boat: &boat, by: commands)
        return boat.position.manhattanDistanceFromZeroPoint
    }

    public static func solvePart2(_ input: String) -> Int {
        let commands = parseInput(input)
        var boat = Boat(
            position: GridPoint(x: 0, y: 0),
            heading: .e,
            waypoint: GridPoint(x: 10, y: 1)
        )
        navigate(boat: &boat, by: commands)
        return boat.position.manhattanDistanceFromZeroPoint
    }

    private static func parseInput(_ input: String) -> [NavigationCommand] {
        let lines = input.components(separatedBy: "\n")
        return lines.map { NavigationCommand(inputValue: $0) }
    }

    private static func navigate(
        boat: inout Boat,
        by commands: [NavigationCommand]
    ) {
        commands.forEach { boat.apply($0) }
    }
}

enum NavigationCommand {
    case translate(direction: CompassDirection, units: Int)
    case rotate(direction: RotationDirection, degrees: Int)
    case forward(units: Int)

    init(inputValue: String) {
        let command = inputValue.prefix(1)
        let arg = inputValue.suffix(from: inputValue.index(after: inputValue.startIndex))
        let units = Int(arg)!
        switch command {
        case "F":
            self = .forward(units: units)
        case "L":
            self = .rotate(direction: .left, degrees: units)
        case "R":
            self = .rotate(direction: .right, degrees: units)
        case "N":
            self = .translate(direction: .n, units: units)
        case "E":
            self = .translate(direction: .e, units: units)
        case "S":
            self = .translate(direction: .s, units: units)
        case "W":
            self = .translate(direction: .w, units: units)
        default:
            fatalError("Unexpected input value: \(inputValue)")
        }
    }
}

struct Boat {
    var position: GridPoint
    var heading: CompassDirection
    var waypoint: GridPoint?

    init(
        position: GridPoint,
        heading: CompassDirection,
        waypoint: GridPoint? = nil
    ) {
        self.position = position
        self.heading = heading
        self.waypoint = waypoint
    }

    mutating func translate(
        _ direction: CompassDirection,
        by units: Int
    ) {
        if let waypoint = waypoint {
            let translatedWaypoint = waypoint.translated(
                direction,
                by: units
            )
            self.waypoint = translatedWaypoint
        } else {
            position = position.translated(direction, by: units)
        }
    }

    mutating func forward(_ units: Int) {
        if let waypoint = waypoint {
            let xOffset = waypoint.x * units
            let yOffset = waypoint.y * units
            position = position.translated(
                byX: xOffset,
                byY: yOffset
            )
        } else {
            translate(heading, by: units)
        }
    }

    mutating func rotate(_ direction: RotationDirection, by degrees: Int) {
        if let waypoint = waypoint {
            self.waypoint = waypoint.rotated(direction, by: degrees)
        } else {
            heading = heading.rotate(direction, by: degrees)
        }
    }
}

extension Boat {
    mutating func apply(_ command: NavigationCommand) {
        switch command {
        case let .translate(direction, units):
            translate(direction, by: units)
        case let .rotate(direction, degrees):
            rotate(direction, by: degrees)
        case let .forward(units):
            forward(units)
        }
    }
}

// Grid origin top left
struct GridPoint {
    let x: Int
    let y: Int
}

extension GridPoint {
    var manhattanDistanceFromZeroPoint: Int {
        abs(x) + abs(y)
    }
}

enum RotationDirection {
    case left
    case right
}

/// Order is according to degrees of the compass, with 0 deg == N, 90 deg == E, etc, in 90-degree increments.
enum CompassDirection: CaseIterable {
    case n, e, s, w

    var offsetValue: (x: Int, y: Int) {
        switch self {
        case .n:
            return (0, 1)
        case .e:
            return (1, 0)
        case .s:
            return (0, -1)
        case .w:
            return (-1, 0)
        }
    }

    var heading: Int {
        switch self {
        case .n:
            return 0
        case .e:
            return 90
        case .s:
            return 180
        case .w:
            return 270
        }
    }

    public init?(heading: Int) {
        switch heading {
        case 0:
            self = .n
        case 90:
            self = .e
        case 180:
            self = .s
        case 270:
            self = .w
        default:
            return nil
        }
    }
}

extension GridPoint {
    func translated(
        _ direction: CompassDirection,
        by units: Int
    ) -> GridPoint {
        GridPoint(
            x: x + (units * direction.offsetValue.x),
            y: y + (units * direction.offsetValue.y)
        )
    }

    func translated(
        byX xOffset: Int,
        byY yOffset: Int
    ) -> GridPoint {
        GridPoint(
            x: x + xOffset,
            y: y + yOffset
        )
    }

    /// Rotates a GridPoint around the origin by the specified number of degrees.
    func rotated(
        _ direction: RotationDirection,
        by degrees: Int
    ) -> GridPoint {
        let x = Double(x)
        let y = Double(y)
        let degrees = Double(degrees) * Double.pi / 180.0

        let newX: Double
        let newY: Double

        switch direction {
        case .left:
            newX = x * cos(degrees) - y * sin(degrees)
            newY = x * sin(degrees) + y * cos(degrees)
        case .right:
            newX = x * cos(degrees) + y * sin(degrees)
            newY = x * -sin(degrees) + y * cos(degrees)
        }

        return GridPoint(
            x: Int(round(newX)),
            y: Int(round(newY))
        )
    }
}

extension CompassDirection {
    func rotate(_ direction: RotationDirection, by degrees: Int) -> CompassDirection {
        var newHeading: Int

        switch direction {
        case .left:
            newHeading = heading - degrees
            if newHeading < 0 {
                newHeading += 360
            }
        case .right:
            newHeading = heading + degrees
            newHeading = newHeading % 360
        }

        guard let newDirection = CompassDirection(heading: newHeading) else {
            fatalError("Unexpected heading: \(newHeading)")
        }
        return newDirection
    }
}
