import Algorithms
import DequeModule
import utils
import XCTest

var shouldLog: Bool = false
var shouldPrettyPrint: Bool = false

func log(_ msg: String) {
    guard shouldLog else {
        return
    }
    print(msg)
}

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve(
            "sample.txt",
            turns: 24,
            prefixSize: 750,
            taking: .max,
            mapper: { $0.id * $1 },
            reducer: (initialValue: 0, fn: { $0 + $1 })
        )
        XCTAssertEqual(actual, 33)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve(
            "real.txt",
            turns: 24,
            prefixSize: 750,
            taking: .max,
            mapper: { $0.id * $1 },
            reducer: (initialValue: 0, fn: { $0 + $1 })
        )
        XCTAssertEqual(actual, 1023)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve(
            "sample.txt",
            turns: 32,
            prefixSize: 2_000,
            taking: 3,
            mapper: { $1 },
            reducer: (initialValue: 1, fn: { $0 * $1 })
        )
        XCTAssertEqual(actual, 3_472)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve(
            "real.txt",
            turns: 32,
            prefixSize: 2_000,
            taking: 3,
            mapper: { $1 },
            reducer: (initialValue: 1, fn: { $0 * $1 })
        )
        XCTAssertEqual(actual, 13_520)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        turns: Int,
        prefixSize: Int,
        taking: Int,
        mapper: (Blueprint, Int) -> Int,
        reducer: (initialValue: Int, fn: (Int, Int) -> Int)
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let blueprints = try String.lines(fromFile: fileURL)
            .filter { !$0.isEmpty }
            .map { Blueprint($0) }

        // Thanks to https://github.com/jpignata/adventofcode/blob/main/2022/19/solve.py for
        // strategy
        var resultsByBlueprint = [Blueprint: Int]()

        for blueprint in blueprints.prefix(taking) {
            var states = [State()]
            for turn in 0 ..< turns {
                var nextStates = [State]()
                for state in states {
                    for material in Material.allCases {
                        if state.hasRawMaterialsForRobot(
                            harvesting: material,
                            using: blueprint
                        ) && shouldBuildBotToHarvest(
                            harvestMaterial: material,
                            using: blueprint,
                            considering: state
                        ) {
                            nextStates.append(
                                State.process(state, harvesting: material, using: blueprint)
                            )
                        }
                    }
                }

                log("After turn \(turn):")

                log(" \(nextStates.count) raw, turn \(turn)")
                prettyPrint(nextStates)

                let sortedStates = Set(nextStates).sorted { $0 > $1 }
                log(" \(sortedStates.count) uniqued & sorted, turn \(turn)")
                prettyPrint(sortedStates)

                states = Array( sortedStates.prefix(prefixSize) )
                log(" \(states.count) states, turn \(turn)")
                prettyPrint(states)

                log("")
            }
            let resultForBlueprint = states.first?.rawMaterials[.geode] ?? 0
            resultsByBlueprint[blueprint] = resultForBlueprint
            print("Blueprint \(blueprint.id): \(resultForBlueprint)")
        }

        let result = resultsByBlueprint
            .map { mapper($0, $1) }
            .reduce(reducer.initialValue, reducer.fn)

        return result
    }

    static func prettyPrint(_ states: [State]) {
        guard shouldPrettyPrint else {
            return
        }
        print(
            states
                .map { "  \($0)" }
                .joined(separator: "\n")
        )
    }

    static func shouldBuildBotToHarvest(
        harvestMaterial: Material,
        using blueprint: Blueprint,
        considering state: State
    ) -> Bool {
        let botCount = state.bots[harvestMaterial, default: 0]
        let maxMaterial = blueprint.maxMaterialCost[harvestMaterial]!
        return botCount < maxMaterial
    }
}

// MARK: - Structures

/// Cases are in order of precedence
enum Material: CaseIterable, Hashable {
    case wait
    case ore
    case clay
    case obsidian
    case geode
}

extension Material: CustomStringConvertible {
    var description: String {
        switch self {
        case .wait: return "wa"
        case .ore: return "or"
        case .clay: return "cl"
        case .obsidian: return "ob"
        case .geode: return "ge"
        }
    }
}

extension Material: Comparable {
    static var sortKeys: [Material] {
        allCases.reversed().filter { $0 != .wait }
    }
}

struct State: Hashable {
    var rawMaterials: [Material: Int]
    var bots: [Material: Int]

    init(rawMaterials: [Material : Int] = [:], bots: [Material : Int] = [.ore: 1]) {
        self.rawMaterials = rawMaterials
        self.bots = bots
    }

    func hasRawMaterialsForRobot(
        harvesting harvestMaterial: Material,
        using blueprint: Blueprint
    ) -> Bool {
        for (rawMaterial, cost) in blueprint.botCost[harvestMaterial]! {
            guard rawMaterials[rawMaterial, default: 0] >= cost else {
                return false
            }
        }
        return true
    }

    static func process(
        _ state: State,
        harvesting harvestMaterial: Material,
        using blueprint: Blueprint
    ) -> State {
        var result = state

        // Allocate raw materials for bot
        if harvestMaterial != .wait {
            for (rawMaterial, cost) in blueprint.botCost[harvestMaterial]! {
                result.rawMaterials[rawMaterial, default: 0] -= cost
            }
        }

        // Add raw materials harvested by existing bots
        for (material, botCount) in result.bots {
            result.rawMaterials[material, default: 0] += botCount
        }

        // Build new bot
        if harvestMaterial != .wait {
            result.bots[harvestMaterial, default: 0] += 1
        }

        return result
    }
}

extension State: CustomStringConvertible {
    var description: String {
        let materials = Material.sortKeys

        let rawMaterialsString = materials
            .map { "\($0):\(rawMaterials[$0, default: 0])" }
            .joined(separator: ", ")

        let botsString = materials
            .map { "\($0):\(bots[$0, default: 0])" }
            .joined(separator: ", ")

        return "r: \(rawMaterialsString); b: \(botsString)"
    }
}

extension State: Comparable {
    private static var comparators: [(State, Material) -> Int] {
        [
            { $0.rawMaterials[$1, default: 0] },
            { $0.bots[$1, default: 0] }
        ]
    }

    // From https://github.com/jpignata/adventofcode/blob/main/2022/19/solve.py - best strategies
    // to consider are the ones with the rarest bots and materials:
    //     sorted(next_s, key=lambda x: tuple(map(add, x[0], x[1])))[-1000:]
    //
    // Expect:
    //    r: ge:9, ob:8, cl:21, or:4; b: ge:2, ob:2, cl:2, or:1
    //      >
    //    r: ge:8, ob:8, cl:17, or:3; b: ge:3, ob:5, cl:5, or:3
    static func < (lhs: State, rhs: State) -> Bool {
        for material in Material.sortKeys {
            if lhs.rawMaterials[material, default: 0] != rhs.rawMaterials[material, default: 0] {
                return lhs.rawMaterials[material, default: 0] < rhs.rawMaterials[material, default: 0]
            } else if lhs.bots[material, default: 0] != rhs.bots[material, default: 0] {
                return lhs.bots[material, default: 0] < rhs.bots[material, default: 0]
            }
        }
        return false
    }
}

struct Blueprint: Hashable {
    let id: Int
    let botCost: [Material: [Material: Int]]

    /// Use this to prune branches: if we already have enough bots to harvest the max material cost
    /// for a turn, there is no reason to build more of them. Note that we always build more geode
    /// bots.
    let maxMaterialCost: [Material: Int]

    init(_ line: String) {
        let regex = #/Blueprint (?<id>\d+): Each ore robot costs (?<oreRobotOreCost>\d+) ore. Each clay robot costs (?<clayRobotOreCost>\d+) ore. Each obsidian robot costs (?<obsidianRobotOreCost>\d+) ore and (?<obsidianRobotClayCost>\d+) clay. Each geode robot costs (?<geodeRobotOreCost>\d+) ore and (?<geodeRobotObsidianCost>\d+) obsidian./#
        let result = line.firstMatch(of: regex)!

        id = Int(result.id)!

        let oreRobotOreCost = Int(result.oreRobotOreCost)!
        let clayRobotOreCost = Int(result.clayRobotOreCost)!
        let obsidianRobotOreCost = Int(result.obsidianRobotOreCost)!
        let obsidianRobotClayCost = Int(result.obsidianRobotClayCost)!
        let geodeRobotOreCost = Int(result.geodeRobotOreCost)!
        let geodeRobotObsidianCost = Int(result.geodeRobotObsidianCost)!

        botCost = [
            .wait: [:],
            .ore: [.ore: oreRobotOreCost],
            .clay: [.ore: clayRobotOreCost],
            .obsidian: [.ore: obsidianRobotOreCost, .clay: obsidianRobotClayCost],
            .geode: [.ore: geodeRobotOreCost, .obsidian: geodeRobotObsidianCost],
        ]

        maxMaterialCost = [
            .wait: Int.max,
            .ore: max(oreRobotOreCost, clayRobotOreCost, obsidianRobotOreCost, geodeRobotOreCost),
            .clay: obsidianRobotClayCost,
            .obsidian: geodeRobotObsidianCost,
            .geode: Int.max,
        ]
    }
}
