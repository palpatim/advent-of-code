import Foundation

public enum day13 {
    public static func solvePart1(_ input: String) -> Int {
        let problem = parsePart1Input(input)
        let solution = findEarliestBus(problem: problem)
        return solution.busId * solution.waitTime
    }

    public static func solvePart2(_ input: String) -> Int {
        let buses = parsePart2Input(input)
//        let timestamp = findBusPatternMatch(busPattern: buses)
        let timestamp = findTimestamp(for: buses)
        return timestamp
    }

    private static func parsePart1Input(_ input: String) -> Part1Input {
        let lines = input.components(separatedBy: "\n")
        let earliestDeparture = Int(lines[0])!
        let buses = lines[1]
            .split(separator: ",")
            .compactMap { Int($0) }
        return Part1Input(
            earliestDeparture: earliestDeparture,
            buses: buses
        )
    }

    private static func parsePart2Input(_ input: String) -> [Int?] {
        let lines = input.components(separatedBy: "\n")
        let buses = lines[1]
            .split(separator: ",")
            .map { Int($0) }
        return buses
    }

    private static func findEarliestBus(
        problem: Part1Input
    ) -> Part1Solution {
        var bestSolution = Part1Solution(busId: -1, waitTime: Int.max)
        for busID in problem.buses {
            let waitTime = busID - (problem.earliestDeparture % busID)
            if waitTime < bestSolution.waitTime {
                bestSolution = Part1Solution(busId: busID, waitTime: waitTime)
            }
        }

        return bestSolution
    }

    // This brute-force method works fine for the sample cases, but is
    // impractical on the real input, where the problem explicitly states
    // the timestamp is > 100,000,000,000,000.
    private static func findBusPatternMatch(busPattern: [Int?]) -> Int {
        var indexesToCheck = [(offset: Int, busID: BusID)]()
        for (index, busID) in busPattern.enumerated() {
            guard let busID = busID else {
                continue
            }
            indexesToCheck.append(
                (
                    offset: index,
                    busID: busID
                )
            )
        }

        let increment = indexesToCheck[0].busID
        var timestamp = increment
        outer: while true {
            defer {
                timestamp += increment
            }
            for toCheck in indexesToCheck {
                let adjustedTimestamp = timestamp + toCheck.offset
                guard adjustedTimestamp.isMultiple(of: toCheck.busID) else {
                    continue outer
                }
            }
            return timestamp
        }
        fatalError("No solution found")
    }

    // I finally gave up and had to look up hints: https://0xdf.gitlab.io/adventofcode2020/13
    //
    // Solution uses Chinese remainder theorem https://en.wikipedia.org/wiki/Chinese_remainder_theorem
    private static func findTimestamp(for busPattern: [Int?]) -> Int {
        let moduli = busPattern.compactMap { $0 }
        let a = busPattern
            .enumerated()
            .map { index, busID -> Int? in
                guard let busID = busID else {
                    return nil
                }
                return busID - index
            }
            .compactMap { $0 }

        let timestamp = chineseRemainder(n: moduli, a: a)
        return timestamp
    }
}

typealias BusID = Int

struct Part1Input {
    let earliestDeparture: Int
    let buses: [Int]
}

struct Part1Solution {
    let busId: BusID
    let waitTime: Int
}

func chineseRemainder(n: [Int], a: [Int]) -> Int {
    /*
     sum = 0
     prod = reduce(lambda a, b: a*b, n)
     for n_i, a_i in zip(n, a):
         p = prod // n_i
         sum += a_i * mul_inv(p, n_i) * p
     return sum % prod
     */

    var sum = 0
    let prod = n.reduce(1, *)

    for (n_i, a_i) in zip(n, a) {
        let p = prod / n_i
        sum += a_i * inverse(p, n_i) * p
        print("sum: \(sum)")
    }

    var min = sum % prod
    if min < 0 {
        min += prod
    }
    return min
}

// https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
func inverse(_ a: Int, _ n: Int) -> Int {
    /*
     function inverse(a, n)
        t := 0;     newt := 1
        r := n;     newr := a

        while newr ≠ 0 do
            quotient := r div newr
            (t, newt) := (newt, t − quotient × newt)
            (r, newr) := (newr, r − quotient × newr)

        if r > 1 then
            return "a is not invertible"
        if t < 0 then
            t := t + n

        return t
     */

    var t = 0
    var newT = 1
    var r = n
    var newR = a

    while newR != 0 {
        let q = r / newR
        let tempT = t
        t = newT
        newT = tempT - q * newT

        let tempR = r
        r = newR
        newR = tempR - q * newR
    }

    if r > 1 {
        fatalError("a is not invertible")
    }

    if t < 0 {
        t += n
    }

    return t
}
