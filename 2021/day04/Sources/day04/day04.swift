import Foundation

public enum day04 {
    public static func solve(_ input: String, exitAfterFirst: Bool = true) -> Int {
        var game = parseInput(input)
        game.play(exitAfterFirst: exitAfterFirst)

        let winningBoard = game.boards[game.winningBoardIndex]
        let sum = winningBoard.sumUncalledNumbers()
        let returnValue = sum * winningBoard.lastCall
        return returnValue
    }

    private static func parseInput(_ input: String) -> Game {
        let lines = input.components(separatedBy: "\n")
        let calls = lines[0].components(separatedBy: ",").map { Int($0)! }
        var rows = [[Int]]()
        var boards = [Board]()
        for line in lines[2...] {
            if line.isEmpty {
                boards.append(Board(rows: rows))
                rows = []
                continue
            }

            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            let row = trimmedLine
                .split(separator: " ", omittingEmptySubsequences: true)
                .map { Int($0)! }
            rows.append(row)
        }
        boards.append(Board(rows: rows))

        let game = Game(calls: calls, boards: boards)
        return game
    }
}

public struct Game {
    let calls: [Int]
    var boards: [Board]
    var winningBoardIndex: Int
    var winningBoardCount: Int

    public init(calls: [Int], boards: [Board]) {
        self.calls = calls
        self.boards = boards
        winningBoardIndex = Int.min
        winningBoardCount = 0
    }

    public mutating func play(exitAfterFirst: Bool) {
        for call in calls {
            for index in 0 ..< boards.count {
                guard !boards[index].hasWon else {
                    continue
                }
                let isWinner = boards[index].call(call)
                if isWinner {
                    winningBoardCount += 1
                    if exitAfterFirst || winningBoardCount == boards.count {
                        winningBoardIndex = index
                        return
                    }
                }
            }
        }
    }
}

public struct Board {
    public typealias Row = [Int]
    public typealias RowIndex = Int
    public typealias ColIndex = Int
    public enum WinDirection {
        case row, col
    }

    let rows: [Row]
    let numbersByCoordinate: [Int: Coordinate]
    var wins: [
        WinDirection: [
            RowIndex: Set<Int>
        ]
    ]
    var lastCall: Int
    var hasWon: Bool

    public var isWinner: Bool {
        return false
    }

    public init(rows: [Row]) {
        self.rows = rows
        lastCall = Int.min
        hasWon = false
        var numbersByCoordinate = [Int: Coordinate]()
        var wins: [
            WinDirection: [
                Int: Set<Int>
            ]
        ] = [
            .row: [:],
            .col: [:],
        ]

        // Set up empty wins structure
        let rowCount = rows.count
        let colCount = rows[0].count
        for rowIndex in 0 ..< rowCount {
            for colIndex in 0 ..< colCount {
                wins[.row]![rowIndex] = []
                wins[.col]![colIndex] = []
            }
        }

        for (rowIndex, row) in rows.enumerated() {
            for (colIndex, num) in row.enumerated() {
                wins[.row]![rowIndex]!.insert(num)
                wins[.col]![colIndex]!.insert(num)
                numbersByCoordinate[num] = Coordinate(row: rowIndex, col: colIndex)
            }
        }

        self.numbersByCoordinate = numbersByCoordinate
        self.wins = wins
    }

    public mutating func call(_ value: Int) -> Bool {
        // Check that number is on board
        guard let coordinates = numbersByCoordinate[value] else {
            return false
        }

        lastCall = value

        let rowIndex = coordinates.row
        let colIndex = coordinates.col

        wins[.row]![rowIndex]!.remove(value)
        if wins[.row]![rowIndex]!.isEmpty {
            hasWon = true
        }

        wins[.col]![colIndex]!.remove(value)
        if wins[.col]![colIndex]!.isEmpty {
            hasWon = true
        }

        return hasWon
    }

    public func sumUncalledNumbers() -> Int {
        var sum = 0
        for element in wins[.row]!.values {
            let subtotal = element.reduce(0, +)
            sum += subtotal
        }
        return sum
    }
}

public struct Coordinate {
    let row: Int
    let col: Int
}
