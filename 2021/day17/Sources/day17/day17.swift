import Foundation
import utils

public struct day17 {
    public static func solvePart1(_ input: String) -> Int {
        let puzzle = parseInput(input)

        // At the time we cross y=0, our velocity is (-VYstart - 1). That means the next step is
        // going to put us that many units below y=0. Therefore our maximum starting velocity is
        // the minimum Y of the target area, minus 1 to account for the extra step starting with
        // velocity = VY at t0
        let minY = puzzle.targetBottomRight.y
        let yHeight = Velocity.distanceToZero(positiveInt: abs(minY) - 1)

        return yHeight
    }

    public static func solvePart2(_ input: String) -> Int {
        let puzzle = parseInput(input)

        // minVX must be at least enough to get us to the left boundary
        // (or else it undershoots and never reaches the target). (Note that
        // this calculation may actually undershoot b/c of rounding, but
        // we'll accept that for now.)
        let minX = puzzle.targetTopLeft.x
        let minVX = Velocity.countOfSeries(withSum: minX)
        print("minVX: \(minVX) -> \(Velocity.distanceToZero(positiveInt: minVX))")

        // maxVX must not exceed the right
        // boundary (or else it overshoots the target on the first step)
        let maxVX = puzzle.targetBottomRight.x

        // VY can range from the max as shown in part1, to a velocity that hits the
        // bottom in one step
        let minY = puzzle.targetBottomRight.y
        let maxVY = abs(minY)
        let minVY = -1 * maxVY

        var count = 0
        for vy in minVY ... maxVY {
            for vx in minVX ... maxVX {
                let v = Velocity(x: vx, y: vy)
                if simulate(v: v, puzzle: puzzle) {
                    count += 1
                } else {
                }
            }
        }

        return count
    }

    // Simulates the trajectory from the given initial velocity. Returns `true` if the
    // trajectory intersects the target area at any whole step
    private static func simulate(v: Velocity, puzzle: Puzzle) -> Bool {
        var currentVelocity = v
        var currentPosition = Coordinate(x: 0, y: 0)
        while true {
            if puzzle.intersects(currentPosition) {
                return true
            }
            guard !hasExceededTarget(coordinate: currentPosition, puzzle: puzzle) else {
                return false
            }
            currentPosition = currentPosition.applying(currentVelocity.offset)
            currentVelocity = currentVelocity.slowdown()
        }
    }

    private static func hasExceededTarget(coordinate: Coordinate, puzzle: Puzzle) -> Bool {
        coordinate.y < puzzle.targetBottomRight.y || coordinate.x > puzzle.targetBottomRight.x
    }

    private static func parseInput(_ input: String) -> Puzzle {
        let coordStrings = input
            .components(separatedBy: ": ")
            .dropFirst()
            .first!

        let ranges = coordStrings.components(separatedBy: ", ")
        let xRange = ranges[0].suffix(from: ranges[0].index(ranges[0].startIndex, offsetBy: 2))
        let yRange = ranges[1].suffix(from: ranges[1].index(ranges[1].startIndex, offsetBy: 2))

        let xs = xRange.components(separatedBy: "..").map { Int($0)! }
        let ys = yRange.components(separatedBy: "..").map { Int($0)! }

        let topLeft = Coordinate(x: xs[0], y: ys[1])
        let bottomRight = Coordinate(x: xs[1], y: ys[0])
        return Puzzle(
            targetTopLeft: topLeft,
            targetBottomRight: bottomRight
        )
    }

}

public struct Puzzle {
    let targetTopLeft: Coordinate
    let targetBottomRight: Coordinate

    var xRange: ClosedRange<Int> {
        targetTopLeft.x ... targetBottomRight.x
    }

    var yRange: ClosedRange<Int> {
        targetBottomRight.y ... targetTopLeft.y
    }

    func intersects(_ coordinate: Coordinate) -> Bool {
        xRange.contains(coordinate.x) && yRange.contains(coordinate.y)
    }

}

public struct Velocity: Equatable {
    let x: Int
    let y: Int
    var offset: Offset {
        Offset(x: x, y: y)
    }
}

extension Velocity {
    /// Applies puzzle's physics rules to `velocity` and returns the new velocity.
    /// - Converges `x` velocity by to 0 by 1
    /// - Reduces `y` velocity by 1
    public func slowdown() -> Velocity {
        let newX = x.converging(to: 0, by: 1)
        let newY = y - 1
        return Velocity(x: newX, y: newY)
    }

    /// Calculate the distance travelled (sum of series) until the velocity reaches zero
    public static func distanceToZero(positiveInt n: Int) -> Int {
        guard n >= 0 else {
            fatalError()
        }

        guard n > 0 else {
            return 0
        }

        // Simplified sum of series, since last term is always zero
        return (n + 1) * n / 2
    }

    /// Given a series 0, 1, 2, ... n where sum(series) == S, find n (number of steps) that is less than or equal to S.
    ///
    /// Since our simplified sum is `(n + 1) * n / 2 = S` (see `distanceToZero`),
    /// we can convert that to a quadratic:
    /// `(n+1) * n = 2S`
    /// `n² * n - 2S = 0`
    /// `n² * n + (-2S) = 0`
    /// Is a quadratic (`ax² + bx + c = 0`) Which means 8th grade algebra FTW!
    /// `x = (-b ± √(b² -4ac))/2`
    /// In this case, `a` and `b` are both 1, and `c = -2S`
    /// `x = (-1 ± √(1² -4*1*c))/2`
    /// `x = (-1 ± √(1 - 4*c))/2`
    /// `x = (-1 ± √(1² - 4*(-2S)))/2`
    /// `x = (-1 ± √(1 - -8S))/2`
    /// `x = (-1 ± √(1 + 8S))/2`
    public static func countOfSeries(withSum sum: Int) -> Int {
        let term = 1.0 + Double(8 * sum)
        let root = sqrt(term)
        // Ignore the "minus" part of the +/- and just return the first solution
        let sol = (root - 1) / 2
        return Int(sol)
    }
}

extension Int {
    func converging(to target: Int, by step: Int) -> Int {
        let absStep = abs(step)
        switch self - target {
        case 0:
            return target
        case Int.min ..< 0:
            return self + absStep
        case 0 ..< Int.max:
            return self - absStep
        default:
            fatalError()
        }

    }
}
