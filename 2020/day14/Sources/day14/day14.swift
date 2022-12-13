import Foundation

public enum day14 {
    public static func solve(
        _ input: String,
        ruleSet: RuleSet
    ) -> Int {
        let program = parseInput(input)
        let mem = execute(program, ruleSet: ruleSet)
        return mem.values.reduce(0, +)
    }

    private static func parseInput(_ input: String) -> Program {
        let lines = input.components(separatedBy: "\n")
        let program = lines.map { Command(inputLine: $0) }
        return program
    }

    private static func execute(
        _ program: Program,
        ruleSet: RuleSet
    ) -> [Address: Int] {
        var mem = [Address: Int]()
        var mask = Bitmask()
        for command in program {
            switch command {
            case let .mask(maskString):
                mask = parseMask(maskString)
            case let .mem(address, value):
                switch ruleSet {
                case .part1:
                    let adjustedValue = applyValueMask(mask, to: value)
                    mem[address] = adjustedValue
                case .part2:
                    let adjustedAddresses = applyAddressMask(mask, to: address)
                    adjustedAddresses.forEach { mem[$0] = value }
                }
            }
        }
        return mem
    }

    private static func parseMask(_ maskString: String) -> Bitmask {
        var mask = Bitmask()
        for (index, char) in maskString.reversed().enumerated() {
            let bitmaskValue = BitmaskValue(rawValue: char)!
            mask[index] = bitmaskValue
        }
        return mask
    }

    private static func applyValueMask(_ mask: Bitmask, to value: Int) -> Int {
        var value = value
        for (bitPosition, bit) in mask {
            switch bit {
            case .unset:
                value = value & ~(1 << bitPosition)
            case .set:
                value = value | (1 << bitPosition)
            case .floating:
                break
            }
        }
        return value
    }

    private static func applyAddressMask(
        _ mask: Bitmask,
        to address: Int
    ) -> [Int] {
        var address = address
        var floatingPositions = [Int]()
        for (bitPosition, bit) in mask {
            switch bit {
            case .unset:
                break
            case .set:
                address = address | (1 << bitPosition)
            case .floating:
                floatingPositions.append(bitPosition)
            }
        }

        let masks = masksForFloatingPositions(floatingPositions)
        let addresses = masks
            .map { applyValueMask($0, to: address) }

        return addresses
    }

    private static func masksForFloatingPositions(
        _ positions: [Int]
    ) -> [Bitmask] {
        guard positions.count > 0 else {
            return []
        }

        var masks = [Bitmask]()
        masks.append(contentsOf: [
            [positions[0]: .set],
            [positions[0]: .unset],
        ])

        guard positions.count > 1 else {
            return masks
        }

        for position in positions[1...] {
            for maskIndex in 0 ..< masks.count {
                var mask = masks[maskIndex]
                mask[position] = .set
                masks[maskIndex] = mask
                mask[position] = .unset
                masks.append(mask)
            }
        }

        return masks
    }
}

typealias Program = [Command]
typealias Bitmask = [Int: BitmaskValue]
typealias Address = Int

public enum BitmaskValue: Character {
    case set = "1"
    case unset = "0"
    case floating = "X"
}

public enum RuleSet {
    case part1, part2
}

enum Command {
    case mask(String)
    case mem(address: Int, value: Int)
}

extension Command {
    init(inputLine: String) {
        let parts = inputLine.components(separatedBy: " = ")
        if parts[0].hasPrefix("mask") {
            self = .mask(parts[1])
        } else {
            let leftIndex = parts[0].firstIndex(of: "[")!
            let rightIndex = parts[0].firstIndex(of: "]")!
            let addressStart = parts[0].index(after: leftIndex)
            let addressString = parts[0][addressStart ..< rightIndex]
            let address = Int(addressString)!
            let value = Int(parts[1])!
            self = .mem(address: address, value: value)
        }
    }
}
