import Foundation

public enum day04 {
    public static func solve(
        _ input: String,
        evaluatingAgainst policy: ValidationPolicy
    ) throws -> Int {
        let builders = try parseInput(input)
        return builders
            .filter { policy.isBuilderValid($0) }
            .count
    }

    private static func parseInput(_ input: String) throws -> [Passport.Builder] {
        var builders = [Passport.Builder]()
        let lines = input.components(separatedBy: .newlines)
        var currentBuilder = Passport.Builder()
        for line in lines {
            if line.isEmpty {
                builders.append(currentBuilder)
                currentBuilder = Passport.Builder()
                continue
            }

            try line
                .split(separator: " ")
                .forEach {
                    let keyAndValue = $0.split(separator: ":").map(String.init)
                    try currentBuilder.set(keyAndValue[0], to: keyAndValue[1])
                }
        }

        builders.append(currentBuilder)
        return builders
    }
}

// Not actually used, but it feels weird to not have an actual object here :)
public struct Passport {
    let birthYear: String
    let issueYear: String
    let expirationYear: String
    let height: String
    let hairColor: String
    let eyeColor: String
    let passportId: String
    let countryId: String?
}

public extension Passport {
    struct Builder {
        var birthYear: String?
        var issueYear: String?
        var expirationYear: String?
        var height: String?
        var hairColor: String?
        var eyeColor: String?
        var passportId: String?
        var countryId: String?

        public init() {}

        public mutating func set(_ key: String, to value: String?) throws {
            switch key {
            case "byr":
                birthYear = value
            case "iyr":
                issueYear = value
            case "eyr":
                expirationYear = value
            case "hgt":
                height = value
            case "hcl":
                hairColor = value
            case "ecl":
                eyeColor = value
            case "pid":
                passportId = value
            case "cid":
                countryId = value
            default:
                throw BuilderError.invalidKey
            }
        }
    }
}

extension Passport.Builder {
    enum BuilderError: Error {
        /// Thrown when setting builder data from an unrecognized key
        case invalidKey

        /// Thrown when attempting to build for a policy with insufficient data
        case policyValidationError

        /// Thrown if the policy "validity" check and required fields don't match up. This could probably be improved.
        case policyDataMismatch
    }
}

public protocol ValidationPolicy {
    func isBuilderValid(_ builder: Passport.Builder) -> Bool
}

struct RelaxedValidationPolicy: ValidationPolicy {
    func isBuilderValid(_ builder: Passport.Builder) -> Bool {
        builder.birthYear != nil &&
            builder.issueYear != nil &&
            builder.expirationYear != nil &&
            builder.height != nil &&
            builder.hairColor != nil &&
            builder.eyeColor != nil &&
            builder.passportId != nil
    }
}

private extension ClosedRange where Bound == Int {
    func contains<S: StringProtocol>(_ stringValue: S?) -> Bool {
        guard let stringValue = stringValue,
              let intValue = Int(stringValue)
        else {
            return false
        }
        return contains(intValue)
    }
}

struct StrictValidationPolicy: ValidationPolicy {
    func isBuilderValid(_ builder: Passport.Builder) -> Bool {
        isBirthYearValid(builder) &&
            isIssueYearValid(builder) &&
            isExpirationYearValid(builder) &&
            isHeightValid(builder) &&
            isHairColorValid(builder) &&
            isEyeColorValid(builder) &&
            isPassportIdValid(builder) &&
            isCountryIdValid(builder)
    }

    private static let birthYearValidRange = 1920 ... 2002
    private static let issueYearValidRange = 2010 ... 2020
    private static let expirationYearValidRange = 2020 ... 2030
    private static let heightInCentimetersValidRange = 150 ... 193
    private static let heightInInchesValidRange = 59 ... 76
    private static let hairColorValidRegex = "^#[0-9a-f]{6}$"
    private static let validEyeColors = [
        "amb", "blu", "brn", "gry", "grn", "hzl", "oth",
    ]
    private static let passportIdValidRegex = "^[0-9]{9}$"

    /// byr (Birth Year) - four digits; at least 1920 and at most 2002.
    private func isBirthYearValid(_ builder: Passport.Builder) -> Bool {
        guard let value = builder.birthYear, value.count == 4 else {
            return false
        }
        return StrictValidationPolicy.birthYearValidRange.contains(value)
    }

    /// iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    private func isIssueYearValid(_ builder: Passport.Builder) -> Bool {
        guard let value = builder.issueYear, value.count == 4 else {
            return false
        }
        return StrictValidationPolicy.issueYearValidRange.contains(value)
    }

    /// eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    private func isExpirationYearValid(_ builder: Passport.Builder) -> Bool {
        guard let value = builder.expirationYear, value.count == 4 else {
            return false
        }
        return StrictValidationPolicy.expirationYearValidRange.contains(value)
    }

    /// hgt (Height) - a number followed by either cm or in:
    /// - If cm, the number must be at least 150 and at most 193.
    /// - If in, the number must be at least 59 and at most 76.
    private func isHeightValid(_ builder: Passport.Builder) -> Bool {
        guard let value = builder.height else {
            return false
        }

        if value.hasSuffix("cm"), let index = value.lastIndex(of: "c") {
            let height = value.prefix(upTo: index)
            return StrictValidationPolicy.heightInCentimetersValidRange.contains(height)
        } else if value.hasSuffix("in"), let index = value.lastIndex(of: "i") {
            let height = value.prefix(upTo: index)
            return StrictValidationPolicy.heightInInchesValidRange.contains(height)
        } else {
            return false
        }
    }

    /// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    private func isHairColorValid(_ builder: Passport.Builder) -> Bool {
        guard let value = builder.hairColor else {
            return false
        }

        guard value.range(
            of: StrictValidationPolicy.hairColorValidRegex,
            options: .regularExpression
        ) != nil else {
            return false
        }
        return true
    }

    /// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    private func isEyeColorValid(_ builder: Passport.Builder) -> Bool {
        guard let value = builder.eyeColor else {
            return false
        }
        return StrictValidationPolicy.validEyeColors.contains(value)
    }

    /// pid (Passport ID) - a nine-digit number, including leading zeroes.
    private func isPassportIdValid(_ builder: Passport.Builder) -> Bool {
        guard let value = builder.passportId else {
            return false
        }

        guard value.range(
            of: StrictValidationPolicy.passportIdValidRegex,
            options: .regularExpression
        ) != nil else {
            return false
        }
        return true
    }

    /// cid (Country ID) - ignored, missing or not.
    private func isCountryIdValid(_: Passport.Builder) -> Bool {
        return true
    }
}
