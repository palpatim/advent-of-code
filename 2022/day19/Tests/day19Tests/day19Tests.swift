import utils
import DequeModule
import Algorithms
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", turns: 24)
        XCTAssertEqual(actual, 33)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", turns: 24)
        XCTAssertEqual(actual, -1)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", turns: 24)
        XCTAssertEqual(actual, -1)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", turns: 24)
        XCTAssertEqual(actual, -1)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        turns: Int
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        let blueprints = try String.lines(fromFile: fileURL)
            .filter { !$0.isEmpty }
            .map { Blueprint($0) }

        let results = bestGeodeCount(forEachBluePrint: blueprints, turns: turns)

        let result = results
            .map { $0.0 * $0.1 }
            .reduce(0, +)

        return result
    }

    static func bestGeodeCount(forEachBluePrint blueprints: [Blueprint], turns: Int) -> [(id: Int, geodeCount: Int)] {
        var maxGeodeCount = 0

        var results = [(id: Int, geodeCount: Int)]()
        for blueprint in blueprints {
            let result = bestGeodeCount(for: blueprint, turns: turns, maxSoFar: maxGeodeCount)
            results.append(
                (
                    id: blueprint.id,
                    geodeCount: result
                )
            )
            maxGeodeCount = max(maxGeodeCount, result)
        }
        return results
    }

    static func bestGeodeCount(for blueprint: Blueprint, turns: Int, maxSoFar: Int) -> Int {
        var state = State(
            blueprint: blueprint,
            initialTimeRemaining: 24
        )
        while state.processNextTick() {
            // Do nothing
        }

        return state.currentGeodes
    }

}

// MARK: - Structures

enum Material: CaseIterable {
    case ore
    case clay
    case obsidian
    case geode
}

enum Action {
    case startRobotConstruction(material: Material)
    case harvestResources
    case finalize
}

struct State {
    let blueprint: Blueprint
    var timeRemaining: Int
    var rawMaterials = [Material: Int]()
    var bots: [Material: Int] = [.ore: 1]
    var pendingBots = [Material: Int]()

    var currentGeodes: Int {
        rawMaterials[.geode] ?? 0
    }

    var geodeBots: Int {
        bots[.geode] ?? 0
    }

    var projectedGeodeCount: Int {
        currentGeodes + (geodeBots * timeRemaining)
    }

    init(
        blueprint: Blueprint,
        initialTimeRemaining: Int
    ) {
        self.blueprint = blueprint
        self.timeRemaining = initialTimeRemaining
    }

    mutating func processNextTick() -> Bool {
        if let harvestMaterial = bestPossibleBuild() {
            buildBot(harvesting: harvestMaterial)
        }

        rawMaterials = bots
            .reduce(into: rawMaterials) { acc, bot in
                acc[bot.key, default: 0] += bot.value
            }

        bots = pendingBots.reduce(into: bots) { acc, curr in
            acc[curr.key, default: 0] += curr.value
        }
        pendingBots = [:]

        timeRemaining -= 1

        return timeRemaining > 0
    }

    func bestPossibleBuild() -> Material? {
        if hasRawMaterialsForRobot(harvesting: .geode) {
            return .geode
        }

        if hasRawMaterialsForRobot(harvesting: .obsidian) {
            return .obsidian
        }

        return nil
    }

    func hasRawMaterialsForRobot(
        harvesting harvestMaterial: Material
    ) -> Bool {
        for (rawMaterial, cost) in blueprint.botCost[harvestMaterial]! {
            guard rawMaterials[rawMaterial, default: 0] >= cost else {
                return false
            }
        }
        return true
    }

    /// Assumes you've checked inventory first.
    mutating func buildBot(harvesting harvestMaterial: Material) {
        for (rawMaterial, cost) in blueprint.botCost[harvestMaterial]! {
            rawMaterials[rawMaterial]! -= cost
        }
        pendingBots[harvestMaterial, default: 0] += 1
    }

    func inventoryRemainingAfterBuildingRobot(
        harvesting harvestMaterial: Material
    ) -> [Material: Int] {
        let inventory = blueprint
            .botCost[harvestMaterial]!
            .reduce(into: [Material: Int]()) { acc, curr in
                acc[curr.key] = rawMaterials[curr.key, default: 0] - curr.value
            }
        return inventory
    }
}

struct Blueprint {
    let id: Int

    let botCost: [Material: [Material: Int]]

    init(_ line: String) {
        let regex = #/Blueprint (?<id>\d+): Each ore robot costs (?<oreRobotOreCost>\d+) ore. Each clay robot costs (?<clayRobotOreCost>\d+) ore. Each obsidian robot costs (?<obsidianRobotOreCost>\d+) ore and (?<obsidianRobotClayCost>\d+) clay. Each geode robot costs (?<geodeRobotOreCost>\d+) ore and (?<geodeRobotObsidianCost>\d+) obsidian./#
        let result = line.firstMatch(of: regex)!

        self.id = Int(result.id)!

        let oreRobotOreCost = Int(result.oreRobotOreCost)!
        let clayRobotOreCost = Int(result.clayRobotOreCost)!
        let obsidianRobotOreCost = Int(result.obsidianRobotOreCost)!
        let obsidianRobotClayCost = Int(result.obsidianRobotClayCost)!
        let geodeRobotOreCost = Int(result.geodeRobotOreCost)!
        let geodeRobotObsidianCost = Int(result.geodeRobotObsidianCost)!

        self.botCost = [
            .ore: [.ore: oreRobotOreCost],
            .clay: [.ore: clayRobotOreCost],
            .obsidian: [.ore: obsidianRobotOreCost, .clay: obsidianRobotClayCost],
            .geode: [.ore: geodeRobotOreCost, .obsidian: geodeRobotObsidianCost]
        ]

    }
}
