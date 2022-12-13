import Foundation

public enum day02 {
    public static func solvePart1(input: String) -> Int {
        let records = parseInput(input)
        let validRecordCount = records.filter(day02.validatePart1).count
        return validRecordCount
    }

    public static func solvePart2(input: String) -> Int {
        let records = parseInput(input)
        let validRecordCount = records.filter(day02.validatePart2).count
        return validRecordCount
    }

    /// Note: Not flexible with respect to input format. Crashes if it encounters unexpected formats
    private static func parseInput(_ input: String) -> [InputRecord] {
        var result = [InputRecord]()
        let lines = input.split(separator: "\n")
        for line in lines {
            let components = line.split(separator: ":")
            let actualPassword = components[1].trimmingCharacters(in: .whitespacesAndNewlines)

            let policyComponents = components[0].split(separator: " ")
            let rangeComponents = policyComponents[0].split(separator: "-")
            let firstNumber = Int(rangeComponents[0])!
            let secondNumber = Int(rangeComponents[1])!

            let requiredCharacter = policyComponents[1]
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let policy = PasswordPolicy(
                firstNumber: firstNumber,
                secondNumber: secondNumber,
                requiredCharacter: requiredCharacter.first!
            )

            let inputRecord = InputRecord(passwordPolicy: policy, password: actualPassword)
            result.append(inputRecord)
        }

        return result
    }

    private static func validatePart1(_ inputRecord: InputRecord) -> Bool {
        let policy = inputRecord.passwordPolicy
        let requiredCharacter = policy.requiredCharacter
        let actualCount = inputRecord
            .password
            .filter { $0 == requiredCharacter }
            .count

        let range = inputRecord.passwordPolicy.range
        return range.contains(actualCount)
    }

    private static func validatePart2(_ inputRecord: InputRecord) -> Bool {
        let policy = inputRecord.passwordPolicy
        let actualPassword = inputRecord.password
        let requiredCharacter = policy.requiredCharacter

        let characterAtFirstIndex = actualPassword
            .characterAt(policy.firstNumber - 1)

        let characterAtSecondIndex = actualPassword
            .characterAt(policy.secondNumber - 1)

        let truthCount = [
            characterAtFirstIndex == requiredCharacter,
            characterAtSecondIndex == requiredCharacter,
        ]
        .filter { $0 }
        .count

        return truthCount == 1
    }
}

public struct InputRecord {
    let passwordPolicy: PasswordPolicy
    let password: String
}

public struct PasswordPolicy {
    let firstNumber: Int
    let secondNumber: Int
    let requiredCharacter: Character
}

extension PasswordPolicy {
    var range: ClosedRange<Int> {
        firstNumber ... secondNumber
    }
}

extension String {
    func characterAt(_ index: Int) -> Character {
        let stringIndex = String.Index(
            utf16Offset: index,
            in: self
        )
        return self[stringIndex]
    }
}
