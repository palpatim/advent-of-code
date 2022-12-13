import XCTest
import utils

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .validCount)
        XCTAssertEqual(actual, 13)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .validCount)
        XCTAssertEqual(actual, 5198)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", strategy: .decoderKey)
        XCTAssertEqual(actual, 140)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", strategy: .decoderKey)
        XCTAssertEqual(actual, 22344)
    }

}

// MARK: - Solution

class Solution {
    static func solve(
        _ fileName: String,
        strategy: Strategy
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        switch strategy {
        case .validCount:
            return try await solveValidation(fileURL)
        case .decoderKey:
            return try await solveDecoderKey(fileURL)
        }
    }

    static func solveValidation(_ fileURL: URL) async throws -> Int {
        var lhs: [PacketData]?
        var rhs: [PacketData]?
        var validPacketIndexes = [Int]()
        var currentPacketIndex = 1
        for line in try String.lines(fromFile: fileURL) {
            if line.isEmpty {
                print("Processing index \(currentPacketIndex)")
                if validatePackets(lhs: lhs, rhs: rhs) {
                    validPacketIndexes.append(currentPacketIndex)
                }

                currentPacketIndex += 1
                lhs = nil
                rhs = nil
                continue
            }

            if lhs == nil {
                lhs = try! JSONDecoder().decode([PacketData].self, from: line.data(using: .ascii)!)
                continue
            }

            if rhs == nil {
                rhs = try! JSONDecoder().decode([PacketData].self, from: line.data(using: .ascii)!)
                continue
            }
        }

        if let lhs, let rhs {
//            print("Processing index \(currentPacketIndex)")
            if validatePackets(lhs: lhs, rhs: rhs) {
                validPacketIndexes.append(currentPacketIndex)
            }
        }

//        print("validPacketIndexes: \(validPacketIndexes)")
        return validPacketIndexes.reduce(0, +)
    }

    static func solveDecoderKey(_ fileURL: URL) async throws -> Int {
        var packets = [PacketData]()
        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }
            let packet = try! JSONDecoder().decode([PacketData].self, from: line.data(using: .ascii)!)
            packets.append(PacketData.list(packet))
        }

        let divider1 = PacketData.list(
            try! JSONDecoder().decode([PacketData].self, from: "[[2]]".data(using: .ascii)!)
        )
        let divider2 = PacketData.list(
            try! JSONDecoder().decode([PacketData].self, from: "[[6]]".data(using: .ascii)!)
        )

        packets.append(contentsOf: [divider1, divider2])

        let sorted = packets.sorted()

        let divider1Index = sorted.firstIndex(of: divider1)! + 1
        let divider2Index = sorted.firstIndex(of: divider2)! + 1

        return divider1Index * divider2Index
    }

    /// Return true if lhs is smaller than, or runs out of items sooner than, rhs
    static func validatePackets(lhs: [PacketData]?, rhs: [PacketData]?) -> Bool {
        guard let lhs else {
            fatalError("lhs unexpectedly nil")
        }

        guard let rhs else {
            fatalError("rhs unexpectedly nil")
        }

        let result = PacketData.list(lhs).validate(PacketData.list(rhs))

        if result == .undetermined {
            fatalError("Unexpected undetermined result")
        }

        return result == .valid
    }

}

// MARK: - Structures
enum Strategy {
    case validCount
    case decoderKey
}

enum ValidationResult {
    case valid, invalid, undetermined
}

extension PacketData {
    func validate(_ other: PacketData) -> ValidationResult {
        switch (self, other) {

        case (.int(let lValue), .int(let rValue)):
            return PacketData.validate(lhs: lValue, rhs: rValue)

        case (.list(let lValue), .list(let rValue)):
            return PacketData.validate(lhs: lValue, rhs: rValue)

        case (.list(_), .int(let rValue)):
            return self.validate(PacketData.list([.int(rValue)]))

        case (.int(let lValue), .list(_)):
            return PacketData.list([.int(lValue)]).validate(other)
        }
    }

    private static func validate(lhs: Int, rhs: Int) -> ValidationResult {
        if lhs < rhs {
            return .valid
        } else if rhs < lhs {
            return .invalid
        } else {
            return .undetermined
        }
    }

    private static func validate(lhs: [PacketData], rhs: [PacketData]) -> ValidationResult {
        let maxCount = max(lhs.count, rhs.count)

        for index in 0 ..< maxCount {
            guard let lValue = lhs.get(index) else {
                return .valid
            }

            guard let rValue = rhs.get(index) else {
                return .invalid
            }

            let result = lValue.validate(rValue)

            guard result != .undetermined else {
                continue
            }
            return result
        }

        return .undetermined
    }

}

extension Array {
    func get(_ index: Index) -> Element? {
        if index < 0 || index >= self.count {
            return nil
        }
        return self[index]
    }
}


// Adapted from
// https://github.com/aws-amplify/amplify-swift/blob/main/Amplify/Core/Support/JSONValue.swift

import Foundation

/// A utility type that allows us to represent an arbitrary JSON structure
public enum PacketData {
    case list([PacketData])
    case int(Int)
}

extension PacketData: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode([PacketData].self) {
            self = .list(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else {
            fatalError("Cannot decode value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .list(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        }
    }

}

extension PacketData: Hashable { }

extension PacketData: Equatable { }

extension PacketData: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: PacketData...) {
        self = .list(elements)
    }
}

extension PacketData: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension PacketData: Comparable {
    public static func < (lhs: PacketData, rhs: PacketData) -> Bool {
        return lhs.validate(rhs) == .valid
    }
}
