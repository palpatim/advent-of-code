public struct day05 {

}

public struct BoardingPass {
    // BoardingPass format is dependent on plane size
    public static let charactersInRowAssignment = 7
    public static let charactersInSeatAssignment = 3
    public static let rowCount = 128
    public static let seatCount = 8

    public let rowIndex: Int
    public let colIndex: Int

    public var seatId: Int {
        rowIndex * BoardingPass.seatCount + colIndex
    }

    public init(
        boardingPassCode: String
    ) {
        self = BoardingPass.boardingPassFromCode(boardingPassCode)
    }

    init(
        rowIndex: Int,
        colIndex: Int
    ) {
        self.rowIndex = rowIndex
        self.colIndex = colIndex
    }

    private static func boardingPassFromCode(
        _ code: String
    ) -> BoardingPass {
        let rowIndex = rowIndexFromBoardingPassCode(code)
        let colIndex = colIndexFromBoardingPassCode(code)
        return BoardingPass(rowIndex: rowIndex, colIndex: colIndex)
    }

    private static func rowIndexFromBoardingPassCode(_ code: String) -> Int {
        let rawRowDirections = code.prefix(charactersInRowAssignment)
        let rowDirections = rawRowDirections
            .map { RowCodeDirection(rawValue: $0)!.binarySearchHalf }
        let range = 0 ... rowCount - 1
        let rowIndex = value(applying: rowDirections, to: range)
        return rowIndex
    }

    private static func colIndexFromBoardingPassCode(_ code: String) -> Int {
        let rawColDirections = code.suffix(charactersInSeatAssignment)
        let colDirections = rawColDirections
            .map { SeatCodeDirection(rawValue: $0)!.binarySearchHalf }
        let range = 0 ... seatCount - 1
        let colIndex = value(applying: colDirections, to: range)
        return colIndex
    }

    private static func value(
        applying directions: [BinarySearchHalf],
        to range: ClosedRange<Int>
    ) -> Int {
        var directions = directions
        var start = range.first!
        var end = range.last!
        while start <= end && !directions.isEmpty {
            let midpoint = start + ((end - start) / 2)
            let direction = directions.removeFirst()
            switch direction {
            case .upper:
                start = midpoint + 1
            case .lower:
                end = midpoint
            }
        }
        return start
    }
}

enum RowCodeDirection: Character {
    case front = "F"
    case back = "B"

    var binarySearchHalf: BinarySearchHalf {
        switch self {
        case .front:
            return .lower
        case .back:
            return .upper
        }
    }
}

enum SeatCodeDirection: Character {
    case left = "L"
    case right = "R"

    var binarySearchHalf: BinarySearchHalf {
        switch self {
        case .left:
            return .lower
        case .right:
            return .upper
        }
    }
}

enum BinarySearchHalf {
    case upper
    case lower
}
