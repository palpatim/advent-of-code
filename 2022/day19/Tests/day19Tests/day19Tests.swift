import Algorithms
import DequeModule
import utils
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
            .map { $0.blueprint.id * $0.geodeCount }
            .reduce(0, +)

        return result
    }

    static func bestGeodeCount(forEachBluePrint blueprints: [Blueprint], turns: Int) -> [State] {
        var results = [State]()
        for blueprint in blueprints {
            let result = bestProductionStrategy(for: blueprint, turns: turns)
            results.append(result)
        }
        return results
    }

    static func bestProductionStrategy(for blueprint: Blueprint, turns _: Int) -> State {
        let state = State(
            blueprint: blueprint,
            initialTimeRemaining: 24
        )

        var maxGeodeState = state
        // Can never build a bot on the first turn, so it will always be a "wait only" turn
        var stack = Deque<Action>([.init(state, nil)])
        var visited = Set<Action>()
        while !stack.isEmpty {
            let action = stack.removeLast()
            guard !visited.contains(action) else {
                continue
            }
            visited.insert(action)

            var currentState = action.state
            if currentState.processNextTick(buildingBotToHarvest: action.material) {
                let candidateMaterials = currentState.botCandidates()
                for candidateMaterial in candidateMaterials {
                    let action = Action(currentState, candidateMaterial)
                    if !visited.contains(action) {
                        stack.append(action)
                    }
                }
            }
            if currentState.geodeCount > maxGeodeState.geodeCount {
                maxGeodeState = currentState
            }
        }

        return maxGeodeState
    }
}

// MARK: - Structures

struct Action: Hashable {
    let state: State
    let material: Material?
    init(_ state: State, _ material: Material?) {
        self.state = state
        self.material = material
    }
}

enum Material: CaseIterable, Hashable {
    case ore
    case clay
    case obsidian
    case geode
}

struct State: Hashable {
    let blueprint: Blueprint
    var timeRemaining: Int
    var rawMaterials: [Material: Int]
    var bots: [Material: Int]
    var botsToNotBuild = Set<Material>()
    var history: [Int: Material?]

    var geodeCount: Int {
        rawMaterials[.geode] ?? 0
    }

    init(
        blueprint: Blueprint,
        initialTimeRemaining: Int
    ) {
        self.blueprint = blueprint
        self.timeRemaining = initialTimeRemaining
        self.bots = [.ore: 1]
        self.rawMaterials = [:]
        self.history = [:]
    }

    /// Processes the next tick of state. Builds a new bot to harvest `harvestMaterial`, if specified, harvests materials from existing
    /// bots, and decreases remaining time.
    ///
    /// Callers must ensure that there are sufficient raw materials prior to building the bot
    mutating func processNextTick(buildingBotToHarvest harvestMaterial: Material?) -> Bool {
        history[timeRemaining] = harvestMaterial
        rawMaterials = bots
            .reduce(into: rawMaterials) { acc, bot in
                acc[bot.key, default: 0] += bot.value
            }

        // Build the pending bot, and update the bots that are no longer needed to build
        if let harvestMaterial, hasRawMaterialsForRobot(harvesting: harvestMaterial) {
            buildBot(harvesting: harvestMaterial)
            for (material, count) in bots {
                if count >= blueprint.maxResourceCost[material]! {
                    botsToNotBuild.insert(material)
                }
            }
        }

        timeRemaining -= 1

        return timeRemaining > 0
    }

    /// Use this to populate the decision tree. Filters materials by bots NOT TO build, rather than attempting to prioritize bots TO build.
    ///
    func botCandidates() -> [Material?] {
        var candidates: [Material?] = Material
            .allCases
            .filter { shouldBuildBot(harvesting: $0) }
        candidates.append(nil)
        return candidates
    }

    /// Heuristics for picking bots to build. See
    /// https://www.reddit.com/r/adventofcode/comments/zpy5rm/2022_day_19_what_are_your_insights_and
    /// for additional discussion
    func shouldBuildBot(harvesting harvestMaterial: Material) -> Bool {
        guard !botsToNotBuild.contains(harvestMaterial) else {
            return false
        }

        return hasRawMaterialsForRobot(harvesting: harvestMaterial)

        //        let numRobots = robots[robot]!
        //        let numResource = resources[robot]!
        //        let minutesRemaining = maxMinutes - minute + 1
        //        let maxNeeded = maxNeeded(resource: robot)
        //        return numRobots * minutesRemaining + numResource < minutesRemaining * maxNeeded
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
        bots[harvestMaterial, default: 0] += 1
    }

}

struct Blueprint: Hashable {
    let id: Int

    let botCost: [Material: [Material: Int]]

    /// Return the maximum cost of a resource for any bot type. Geode bots have a cost of Int.max to reflect the fact that we always
    /// want to build a geode bot
    let maxResourceCost: [Material: Int]

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
            .ore: [.ore: oreRobotOreCost],
            .clay: [.ore: clayRobotOreCost],
            .obsidian: [.ore: obsidianRobotOreCost, .clay: obsidianRobotClayCost],
            .geode: [.ore: geodeRobotOreCost, .obsidian: geodeRobotObsidianCost],
        ]

        maxResourceCost = [
            .ore: max(oreRobotOreCost, clayRobotOreCost, obsidianRobotOreCost, geodeRobotOreCost),
            .clay: obsidianRobotClayCost,
            .obsidian: geodeRobotObsidianCost,
            .geode: Int.max
        ]
    }
}
