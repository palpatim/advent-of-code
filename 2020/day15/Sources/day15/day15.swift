import Foundation

public enum day15 {
    public static func solve(
        _ input: String,
        playingTo limit: Int
    ) -> Int {
        let numbers = parseInput(input)
        let result = play(to: limit, startingList: numbers)
        return result
    }

    private static func parseInput(_ input: String) -> [Int] {
        let numbers = input
            .components(separatedBy: ",")
            .map { Int($0)! }
        return numbers
    }

    // Brute force, but relatively efficient storage & lookups
    private static func play(
        to endTurn: Int,
        startingList: [Int]
    ) -> Int {
        var turn = 1
        var seen = [Int: History]()
        var lastSpoken = -1

        func speak(_ num: Int) {
            lastSpoken = num
            let newHistory: History
            if let history = seen[lastSpoken] {
                switch history {
                case let .moreThanOnce(prev, mostRecent):
                    newHistory = .moreThanOnce(
                        prev: mostRecent,
                        mostRecent: turn
                    )
                case let .once(prevTurn):
                    newHistory = .moreThanOnce(
                        prev: prevTurn,
                        mostRecent: turn
                    )
                }
            } else {
                newHistory = .once(turn: turn)
            }
            seen[lastSpoken] = newHistory
        }

        startingList.forEach {
            speak($0)
            turn += 1
        }

        while turn <= endTurn {
            defer {
                turn += 1
            }
            guard case let .moreThanOnce(prev, mostRecent) = seen[lastSpoken] else {
                speak(0)
                continue
            }
            speak(mostRecent - prev)
        }

        return lastSpoken
    }
}

enum History {
    case once(turn: Int)
    case moreThanOnce(prev: Int, mostRecent: Int)
}
