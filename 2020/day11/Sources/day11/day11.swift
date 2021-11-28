import Foundation

public struct day11 {
    public static func solvePart1(_ input: String) -> Int {
        let floorMap = parseInput(input)
        let fullyEvolvedMap = evolveUntilStatic(
            floorMap: floorMap,
            accordingTo: .partOne
        )
        let occupiedSeats = fullyEvolvedMap
            .countSeats(of: .occupied)
        return occupiedSeats
    }

    public static func solvePart2(_ input: String) -> Int {
        let floorMap = parseInput(input)
        let fullyEvolvedMap = evolveUntilStatic(
            floorMap: floorMap,
            accordingTo: .partTwo
        )
        let occupiedSeats = fullyEvolvedMap
            .countSeats(of: .occupied)
        return occupiedSeats
    }

    private static func parseInput(_ input: String) -> FloorMap {
        let lines = input.components(separatedBy: "\n")
        let floorMap = lines
            .map { $0.map(SeatingType.init) }
        return floorMap
    }

    private static func evolveUntilStatic(
        floorMap: FloorMap,
        accordingTo ruleSet: RuleSet
    ) -> FloorMap {
        var evolvedMap = floorMap
        var currentMap: FloorMap
        repeat {
            currentMap = evolvedMap
            evolvedMap = evolve(
                currentMap,
                accordingTo: ruleSet
            )
        } while currentMap != evolvedMap
        return evolvedMap
    }

    private static func evolve(
        _ floorMap: FloorMap,
        accordingTo ruleSet: RuleSet
    ) -> FloorMap {
        var evolvedMap = FloorMap()
        for (y, _) in floorMap.enumerated() {
            var evolvedRow = FloorRow()
            let row = floorMap[y]
            for (x, _) in row.enumerated() {
                let evolvedCell = evolveCell(
                    at: GridPoint(x: x, y: y),
                    in: floorMap,
                    accordingTo: ruleSet
                )
                evolvedRow.append(evolvedCell)
            }
            evolvedMap.append(evolvedRow)
        }
        return evolvedMap
    }

    private static func evolveCell(
        at gridPoint: GridPoint,
        in floorMap: FloorMap,
        accordingTo ruleSet: RuleSet
    ) -> SeatingType {
        switch ruleSet {
        case .partOne:
            return evolveCellAccordingToRuleset1(
                at: gridPoint,
                in: floorMap
            )
        case .partTwo:
            return evolveCellAccordingToRuleset2(
                at: gridPoint,
                in: floorMap
            )
        }
    }

    private static func evolveCellAccordingToRuleset1(
        at gridPoint: GridPoint,
        in floorMap: FloorMap
    ) -> SeatingType {
        guard let cell = floorMap.seatAt(gridPoint) else {
            fatalError("Invalid grid point: \(gridPoint)")
        }

        let neighbors = floorMap.neighborsForSeatAt(gridPoint)
        let occupiedCount = neighbors
            .count { $0 == .occupied }

        switch (cell, occupiedCount) {
        case (.empty, 0):
            return .occupied
        case (.occupied, 4...):
            return .empty
        default:
            return cell
        }
    }

    private static func evolveCellAccordingToRuleset2(
        at gridPoint: GridPoint,
        in floorMap: FloorMap
    ) -> SeatingType {
        guard let cell = floorMap.seatAt(gridPoint) else {
            fatalError("Invalid grid point: \(gridPoint)")
        }

        let neighbors = floorMap.sightlinesForSeatAt(gridPoint)
        let occupiedCount = neighbors
            .count { $0 == .occupied }

        switch (cell, occupiedCount) {
        case (.empty, 0):
            return .occupied
        case (.occupied, 5...):
            return .empty
        default:
            return cell
        }
    }

}

typealias FloorMap = [FloorRow]
typealias FloorRow = [SeatingType]

public enum RuleSet {
    case partOne, partTwo
}

public enum SeatingType {
    case floor, empty, occupied

    public init(_ rawValue: Character) {
        switch rawValue {
        case ".":
            self = .floor
        case "L":
            self = .empty
        case "#":
            self = .occupied
        default:
            fatalError("Unexpected value initializing: \(rawValue)")
        }
    }
}

// Grid origin top left
struct GridPoint {
    let x: Int
    let y: Int
}

enum DirectionOffset: CaseIterable {
    case nw, n, ne, w, e, sw, s, se

    var offsetValue: (x: Int, y: Int) {
        switch self {
        case .nw:
            return (-1, -1)
        case .n:
            return (0, -1)
        case .ne:
            return (1, -1)
        case .w:
            return (-1, 0)
        case .e:
            return (1, 0)
        case .sw:
            return (-1, 1)
        case .s:
            return (0, 1)
        case .se:
            return (1, 1)
        }
    }
}

extension GridPoint {
    func applyingOffset(_ offset: DirectionOffset) -> GridPoint {
        GridPoint(
            x: x + offset.offsetValue.x,
            y: y + offset.offsetValue.y
        )
    }
}

extension FloorMap {
    func neighborsForSeatAt(_ point: GridPoint) -> [SeatingType] {
        let neighbors = DirectionOffset
            .allCases
            .map { point.applyingOffset($0) }
            .compactMap { seatAt($0) }
        return neighbors
    }

    /// Returns the seating state at the specified coordinates, or nil if the coordinates aren't valid
    func seatAt(_ point: GridPoint) -> SeatingType? {
        guard point.y >= 0, point.y < self.count else {
            return nil
        }

        let row = self[point.y]

        guard point.x >= 0, point.x < row.count else {
            return nil
        }
        let col = row[point.x]

        return col
    }

    func sightlinesForSeatAt(_ point: GridPoint) -> [SeatingType] {
        var sightlines = [SeatingType]()
        for dir in DirectionOffset.allCases {
            guard let seat = firstSeat(
                from: point,
                along: dir
            ) else {
                continue
            }
            sightlines.append(seat)
        }
        return sightlines
    }

    /// Returns the first non-floor tile in the sightline direction starting from `point`
    func firstSeat(
        from point: GridPoint,
        along sightlineDirection: DirectionOffset
    ) -> SeatingType? {
        var firstSeat: SeatingType? = nil
        var nextPoint = point.applyingOffset(sightlineDirection)
        var candidateCell = seatAt(nextPoint)

        while firstSeat == nil && candidateCell != nil {
            guard candidateCell == .floor else {
                firstSeat = candidateCell
                break
            }
            nextPoint = nextPoint.applyingOffset(sightlineDirection)
            candidateCell = seatAt(nextPoint)
        }

        return firstSeat
    }
}

extension FloorMap {
    func countSeats(of type: SeatingType) -> Int {
        self
            .flatMap { $0 }
            .count { $0 == type }
    }
}

extension Collection {
    func count(where isIncluded: (Element) -> Bool) -> Int {
        reduce(0) { acc, curr in
            isIncluded(curr) ? acc + 1 : acc
        }
    }
}
