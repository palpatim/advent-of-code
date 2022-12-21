import RegexBuilder
import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .rowCount(10))
        XCTAssertEqual(actual, 26)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .rowCount(2_000_000))
        XCTAssertEqual(actual, 4_873_353)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .tuningFrequency)
        XCTAssertEqual(actual, 56_000_011)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .tuningFrequency)
        XCTAssertEqual(actual, 11_600_823_139_120)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        strategy: Strategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var circles = [ManhattanCircle]()
        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }

            // Sensor at x=2, y=18: closest beacon is at x=-2, y=15

            let sensorXRef = Reference(Int.self)
            let sensorYRef = Reference(Int.self)
            let beaconXRef = Reference(Int.self)
            let beaconYRef = Reference(Int.self)

            let regex = Regex {
                "Sensor at x="
                Capture(as: sensorXRef) {
                    Regex {
                        Optionally {
                            "-"
                        }
                        OneOrMore(.digit)
                    }
                } transform: { Int($0)! }
                ", y="
                Capture(as: sensorYRef) {
                    Regex {
                        Optionally {
                            "-"
                        }
                        OneOrMore(.digit)
                    }
                } transform: { Int($0)! }
                ": closest beacon is at x="
                Capture(as: beaconXRef) {
                    Regex {
                        Optionally {
                            "-"
                        }
                        OneOrMore(.digit)
                    }
                } transform: { Int($0)! }
                ", y="
                Capture(as: beaconYRef) {
                    Regex {
                        Optionally {
                            "-"
                        }
                        OneOrMore(.digit)
                    }
                } transform: { Int($0)! }
            }

            guard let result = line.firstMatch(of: regex) else {
                fatalError("Unexpected line format: \(line)")
            }

            let sensor = Coordinate(x: result[sensorXRef], y: result[sensorYRef])
            let beacon = Coordinate(x: result[beaconXRef], y: result[beaconYRef])

            circles.append(ManhattanCircle(center: sensor, beacon: beacon))
        }

        switch strategy {
        case let .rowCount(row):
            return solveForRowCount(circles: circles, row: row)
        case .tuningFrequency:
            return solveForTuningFrequency(circles: circles)
        }
    }

    static func solveForTuningFrequency(
        circles: [ManhattanCircle]
    ) -> Int {
        let maxCoord = 4_000_000
        let beaconCandidates = circles
            .map { $0.beacon }
            .filter { $0.x >= 0 && $0.x <= maxCoord && $0.y >= 0 && $0.y <= maxCoord }

        let minY = beaconCandidates
            .map { $0.y }
            .min()!

        let maxY = beaconCandidates
            .map { $0.y }
            .max()!

        let xToConsider = 0 ... maxCoord

        for row in minY ... maxY {
            let coveredX = coveredXRanges(circles: circles, row: row)
                .compactMap { $0.intersection(xToConsider) }

            switch coveredX.count {
            case 1: continue
            case 2: break
            default: fatalError("Unexpected range count: \(coveredX.count)")
            }

            let dX = coveredX[1].lowerBound - coveredX[0].upperBound
            guard dX == 2 else {
                fatalError("Unexpected range gap in \(coveredX)")
            }

            let beacon = Coordinate(x: coveredX[0].upperBound + 1, y: row)
            return beacon.tuningFrequency
        }

        return Int.max
    }

    /// Returns an array of ranges where each element of the range is an X position covered by a sensor. Thus, any value in one of
    /// the ranges cannot have an unknown beacon.
    ///
    /// The returned ranges are sorted by lowerBound, and do not overlap.
    static func coveredXRanges(
        circles: [ManhattanCircle],
        row: Int
    ) -> [ClosedRange<Int>] {
        let coveredRanges = circles
            .compactMap { $0.xRange(atYPosition: row) }
            .sorted { $0.lowerBound < $1.lowerBound }

        let mergedRanges = coveredRanges
            .reduce(into: [ClosedRange<Int>]()) { current, new in
                guard let last = current.last else {
                    current.append(new)
                    return
                }

                guard last.overlaps(new) else {
                    current.append(new)
                    return
                }

                _ = current.removeLast()
                current.append(last.mergedWith(new))
            }

        return mergedRanges
    }

    static func solveForRowCount(
        circles: [ManhattanCircle],
        row: Int
    ) -> Int {
        let mergedRanges = coveredXRanges(circles: circles, row: row)

        let coveredCellCount = mergedRanges
            .map { $0.count }
            .reduce(0, +)

        let beacons = circles
            .map { $0.beacon }
            .filter { $0.y == row }
            .map { $0.x }

        let beaconsCount = Set(beacons).count

        return coveredCellCount - beaconsCount
    }
}

// MARK: - Structures

enum Strategy {
    case rowCount(Int)
    case tuningFrequency
}

struct ManhattanCircle {
    let center: Coordinate
    let beacon: Coordinate

    var radius: Int {
        center.manhattanDistance(to: beacon)
    }

    /// The topmost point of the circle
    var minY: Coordinate {
        Coordinate(x: center.x, y: center.y - radius)
    }

    /// The bottommost point of the circle
    var maxY: Coordinate {
        Coordinate(x: center.x, y: center.y + radius)
    }

    /// The leftmost point of the circle
    var minX: Coordinate {
        Coordinate(x: center.x - radius, y: center.y)
    }

    /// The rightmost point of the circle
    var maxX: Coordinate {
        Coordinate(x: center.x + radius, y: center.y)
    }

    /// Returns the range of X positions covered by the circle at position y.
    ///
    /// Returns nil if no x positions are covered by the circle.
    /// - Parameter y: the Y position to check
    /// - Returns: a closed range of all the X positions contained within the circle at specified Y position
    func xRange(atYPosition y: Int) -> ClosedRange<Int>? {
        let dY = abs(y - center.y)
        guard dY <= radius else {
            return nil
        }

        let dX = radius - dY
        return center.x - dX ... center.x + dX
    }
}

extension Coordinate {
    var tuningFrequency: Int {
        (x * 4_000_000) + y
    }
}
