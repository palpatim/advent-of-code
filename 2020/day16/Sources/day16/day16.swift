import Foundation

public struct day16 {
    public static func solvePart1(
        _ input: String
    ) -> Int {
        let puzzleInput = parseInput(input)
        let interimValues = validate(puzzleInput)
        let errorRate = interimValues.invalidValues.reduce(0, +)
        return errorRate
    }

    public static func solvePart2(
        _ input: String
    ) -> Int {
        let puzzleInput = parseInput(input)
        let interimValues = validate(puzzleInput)

        let allFields = Set(puzzleInput.ranges.keys.map { String($0) })
        var fieldCandidates = [Set<String>](repeating: allFields, count: puzzleInput.yourTicket.count)

        for index in 0 ..< fieldCandidates.count {
            let potentialFields = fieldCandidates[index]
            for ticket in interimValues.validTickets {
                let valueAtIndex = ticket[index]
                for field in potentialFields {
                    if !puzzleInput.value(valueAtIndex, canBeInField: field) {
                        fieldCandidates[index].remove(field)
                    }
                }
            }
        }

        var processedIndexes = Set<Int>()
        while processedIndexes.count < fieldCandidates.count {
            var singleElementIndexes = Set<Int>()
            for (index, fields) in fieldCandidates.enumerated() {
                guard fields.count == 1 else {
                    continue
                }
                singleElementIndexes.insert(index)
            }
            singleElementIndexes = singleElementIndexes.subtracting(processedIndexes)

            let indexToRemove = singleElementIndexes.first!
            processedIndexes.insert(indexToRemove)
            let fieldsToRemove = fieldCandidates[indexToRemove]

            for index in 0 ..< fieldCandidates.count {
                guard index != indexToRemove else {
                    continue
                }
                fieldCandidates[index] = fieldCandidates[index].subtracting(fieldsToRemove)
            }
        }

        // fieldCandidates has now been process-of-eliminationed into one field per index
        let fieldNames = fieldCandidates.map { $0.first! }

        var departureIndexes = [Int]()
        for (index, field) in fieldNames.enumerated() {
            guard field.starts(with: "departure") else {
                continue
            }
            departureIndexes.append(index)
        }

        var yourTicketDepartureValues = [Int]()
        for index in departureIndexes {
            yourTicketDepartureValues.append(puzzleInput.yourTicket[index])
        }

        return yourTicketDepartureValues.reduce(1, *)
    }

    private static func validate(_ puzzleInput: PuzzleInput) -> InterimValues {
        var interimValues = InterimValues(validTickets: [], invalidTickets: [], invalidValues: [])
        let ranges = puzzleInput
            .ranges
            .values
            .flatMap { $0 }
            .sorted { $0.lowerBound < $1.lowerBound }

        var consolidatedRanges = [ClosedRange<Int>]()
        for range in ranges {
            guard let lastRange = consolidatedRanges.last else {
                consolidatedRanges.append(range)
                continue
            }
            if range.lowerBound <= lastRange.upperBound {
                let newRange = lastRange.lowerBound ... range.upperBound
                consolidatedRanges[consolidatedRanges.count - 1] = newRange
            } else {
                consolidatedRanges.append(range)
            }
        }

        for ticket in puzzleInput.nearbyTickets {
            let invalidOnTicket = ticket
                .filter { !isValueContained($0, ranges: consolidatedRanges) }
            interimValues.invalidValues.append(contentsOf: invalidOnTicket)
            if invalidOnTicket.count > 0 {
                interimValues.invalidTickets.append(ticket)
            } else {
                interimValues.validTickets.append(ticket)
            }
        }

        return interimValues
    }

    private static func isValueContained(_ value: Int, ranges: [ClosedRange<Int>]) -> Bool {
        return ranges.contains { $0.contains(value) }
    }

    private static func parseInput(
        _ input: String
    ) -> PuzzleInput {
        enum ParsingState {
            case fields, yourTicket, nearbyTickets
            func advanced() -> ParsingState {
                switch self {
                case .fields: return .yourTicket
                case .yourTicket: return .nearbyTickets
                default: fatalError("Can't advance past .nearbyTickets")
                }
            }
        }

        let lines = input.components(separatedBy: "\n")
        var parsingState = ParsingState.fields

        var fieldsAndRanges = [String: [ClosedRange<Int>]]()
        var nearbyTickets = [[Int]]()
        var yourTicket = [Int]()

        for line in lines {
            guard !line.isEmpty else {
                parsingState = parsingState.advanced()
                continue
            }

            switch parsingState {
            case .fields:
                let components = line.components(separatedBy: ": ")
                let rangeStrings = components[1]
                    .components(separatedBy: " or ")
                var ranges = [ClosedRange<Int>]()
                for rangeString in rangeStrings {
                    let startEndStrings = rangeString
                        .components(separatedBy: "-")
                    ranges.append(
                        Int(startEndStrings[0])! ... Int(startEndStrings[1])!
                    )
                }
                fieldsAndRanges[components[0]] = ranges
            case .yourTicket:
                if line.hasPrefix("your ticket") {
                    continue
                }
                yourTicket = line
                    .components(separatedBy: ",")
                    .map { Int($0)! }
            case .nearbyTickets:
                if line.hasPrefix("nearby tickets") {
                    continue
                }
                let ticket = line
                    .components(separatedBy: ",")
                    .map { Int($0)! }
                nearbyTickets.append(ticket)
            }
        }

        return PuzzleInput(
            ranges: fieldsAndRanges,
            yourTicket: yourTicket,
            nearbyTickets: nearbyTickets
        )
    }
}

public struct PuzzleInput {
    let ranges: [String: [ClosedRange<Int>]]
    let yourTicket: [Int]
    let nearbyTickets: [[Int]]

    func value(_ value: Int, canBeInField field: String) -> Bool {
        let matchingRange = ranges[field]!
            .first { $0.contains(value) }

        return matchingRange != nil
    }
}

public struct InterimValues {
    var validTickets: [[Int]]
    var invalidTickets: [[Int]]
    var invalidValues: [Int]
}
