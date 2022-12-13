import Foundation

public enum day06 {
    public static func solve(_ input: String, days: Int) -> Int {
        var school = parseInput(input)
        school.evolve(days: days)
        return school.count
    }

    private static func parseInput(_ input: String) -> FishSchool {
        let timers = input.components(separatedBy: ",").map { Int($0)! }
        let school = FishSchool(fishTimers: timers)
        return school
    }
}

public struct FishSchool {
    /// Number of cycles between reproductions
    static let indexForNewParent = 6

    /// Additional number of days before a newborn
    static let ageOfMajority = 2

    static var maxIndex: Int {
        return indexForNewParent + ageOfMajority + 1
    }

    // In this structure, the array index represents the timer count. Of course, there's
    // no way to track the actual age of the fish, so if the next problem statement has
    // fish dying after a certain number of days, we'll have to adjust this
    var fishCountsByTimer: [Int]

    // We could make this more efficient by updating the count each time
    // we add to the population.
    var count: Int {
        fishCountsByTimer.reduce(0, +)
    }

    public init(fishTimers: [Int]) {
        var counters = [Int](repeating: 0, count: FishSchool.maxIndex)
        for fish in fishTimers {
            counters[fish] += 1
        }
        fishCountsByTimer = counters
    }

    /// We evolve the school by removing the first item of the array,
    /// which decrements every index, and adding new elements where appropriate
    public mutating func evolve(days: Int) {
        for _ in 0 ..< days {
            evolve()
        }
    }

    public mutating func evolve() {
        let breeders = fishCountsByTimer.removeFirst()
        fishCountsByTimer[FishSchool.indexForNewParent] += breeders
        fishCountsByTimer.append(breeders)
    }
}
