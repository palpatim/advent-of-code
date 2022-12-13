import Foundation

public enum day05 {
    public static func solve(_ input: String, consideringDiagonals: Bool) -> Int {
        let ventMap = parseInput(input, consideringDiagonals: consideringDiagonals)
        let intersections = ventMap.countIntersections()
        return intersections
    }

    private static func parseInput(_ input: String, consideringDiagonals: Bool) -> VentMap {
        let lines = input.components(separatedBy: "\n")
        var segments = [Segment]()
        for line in lines {
            let rawPoints = line.components(separatedBy: " -> ")
            let endpoints = rawPoints.map { Coordinate(csv: $0) }
            let segment = Segment(p1: endpoints[0], p2: endpoints[1])
            segments.append(segment)
        }
        let ventMap = VentMap(segments: segments, consideringDiagonals: consideringDiagonals)
        return ventMap
    }
}

public class Segment {
    let p1: Coordinate
    let p2: Coordinate
    let direction: Direction

    /// A list of all coordinates in the Segment
    let coords: [Coordinate]

    public init(p1: Coordinate, p2: Coordinate) {
        self.p1 = p1
        self.p2 = p2
        coords = Segment.getAllCoordinates(
            from: p1,
            to: p2
        )
        direction = p1.direction(to: p2)
    }

    private static func getAllCoordinates(
        from p1: Coordinate,
        to p2: Coordinate
    ) -> [Coordinate] {
        let direction = p1.direction(to: p2)
        var coordinates = [p1]
        var currentCoord = p1
        while currentCoord != p2 {
            currentCoord = currentCoord.applying(offset: direction.offset)
            coordinates.append(currentCoord)
        }

        return coordinates
    }
}

public enum Direction {
    case n, ne, e, se, s, sw, w, nw

    public var offset: Coordinate {
        switch self {
        case .n: return Coordinate(x: 0, y: -1)
        case .ne: return Coordinate(x: 1, y: -1)
        case .e: return Coordinate(x: 1, y: 0)
        case .se: return Coordinate(x: 1, y: 1)
        case .s: return Coordinate(x: 0, y: 1)
        case .sw: return Coordinate(x: -1, y: 1)
        case .w: return Coordinate(x: -1, y: 0)
        case .nw: return Coordinate(x: -1, y: -1)
        }
    }

    public var isDiagonal: Bool {
        switch self {
        case .n, .e, .s, .w: return false
        default: return true
        }
    }
}

public struct Coordinate: Hashable {
    let x: Int
    let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init(csv: String) {
        let coords = csv.components(separatedBy: ",").map { Int($0)! }
        x = coords[0]
        y = coords[1]
    }

    public func direction(to other: Coordinate) -> Direction {
        let xOffset = other.x - x
        let yOffset = other.y - y

        let zero = 0
        let pos = 1 ... Int.max
        let neg = Int.min ... -1
        let direction: Direction

        switch (xOffset, yOffset) {
        case (zero, neg): direction = .n
        case (pos, neg): direction = .ne
        case (pos, zero): direction = .e
        case (pos, pos): direction = .se
        case (zero, pos): direction = .s
        case (neg, pos): direction = .sw
        case (neg, zero): direction = .w
        case (neg, neg): direction = .nw
        default:
            fatalError("Can't map (\(self) -> \(other) to a direction")
        }

        return direction
    }

    public func applying(offset: Coordinate) -> Coordinate {
        Coordinate(
            x: x + offset.x,
            y: y + offset.y
        )
    }
}

public class VentMap {
    public typealias CoordinateMap = [Coordinate: [Segment]]
    let segmentsByCoord: CoordinateMap
    let segments: [Segment]

    public init(segments: [Segment], consideringDiagonals: Bool) {
        let includedSegments = segments.filter { consideringDiagonals || !$0.direction.isDiagonal }
        self.segments = includedSegments
        segmentsByCoord = VentMap.groupSegmentsByCoord(segments: includedSegments)
    }

    public func countIntersections() -> Int {
        let intersections = segmentsByCoord
            .values
            .filter { $0.count > 1 }
            .count
        return intersections
    }

    private static func groupSegmentsByCoord(segments: [Segment]) -> CoordinateMap {
        var coordMap = CoordinateMap()
        for segment in segments {
            for coord in segment.coords {
                if coordMap[coord] == nil {
                    coordMap[coord] = []
                }
                coordMap[coord]?.append(segment)
            }
        }
        return coordMap
    }
}

extension Numeric {
    var squared: Self {
        return self * self
    }
}
