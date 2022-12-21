import DequeModule
import utils
import XCTest

final class aocTests: XCTestCase {
    func testPart1Sample() async throws {
        let actual = try await Solution.solve("sample.txt", part: 1)
        XCTAssertEqual(actual, 64)
    }

    func testPart1Real() async throws {
        let actual = try await Solution.solve("real.txt", part: 1)
        XCTAssertEqual(actual, 3500)
    }

    func testPart2Sample() async throws {
        let actual = try await Solution.solve("sample.txt", part: 2)
        XCTAssertEqual(actual, 58)
    }

    func testPart2Real() async throws {
        let actual = try await Solution.solve("real.txt", part: 2)
        XCTAssertEqual(actual, 2048)
    }
}

// MARK: - Solution

enum Solution {
    static func solve(
        _ fileName: String,
        part: Int
    ) async throws -> Int {
        guard let fileURL = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            throw StringParsingError("Unable to open \(fileName)")
        }

        var coords = Set<Coordinate3D>()
        for line in try String.lines(fromFile: fileURL) {
            guard !line.isEmpty else {
                continue
            }
            coords.insert(.init(stringValue: line))
        }

        return part == 1 ? solvePart1(coords) : solvePart2(coords)
    }

    static func solvePart1(_ lavaBlobs: Set<Coordinate3D>) -> Int {
        var unobstructedSurfaceCount = 0
        for blob in lavaBlobs {
            for dir in Direction3D.allCases {
                guard
                    !lavaBlobs.contains(blob.applying(dir.offset))
                else {
                    continue
                }
                unobstructedSurfaceCount += 1
            }
        }
        return unobstructedSurfaceCount
    }

    static func solvePart2(_ lavaBlobs: Set<Coordinate3D>) -> Int {
        let minX = lavaBlobs
            .map { $0.x }
            .min()!

        let maxX = lavaBlobs
            .map { $0.x }
            .max()!

        let minY = lavaBlobs
            .map { $0.y }
            .min()!

        let maxY = lavaBlobs
            .map { $0.y }
            .max()!

        let minZ = lavaBlobs
            .map { $0.z }
            .min()!

        let maxZ = lavaBlobs
            .map { $0.z }
            .max()!

        // Any coords in this set are either lava blobs, or fully contained
        // with no path to the water
        var obstructed = lavaBlobs

        // Any coords in this set are part of a path that eventually reaches
        // the water
        var unobstructed = Set<Coordinate3D>()

        func isDefinitelyUnobstructed(_ coord: Coordinate3D) -> Bool {
            guard !obstructed.contains(coord) else {
                return false
            }

            if unobstructed.contains(coord) {
                return true
            }

            if coord.x <= minX ||
                coord.x >= maxX ||
                coord.y <= minY ||
                coord.y >= maxY ||
                coord.z <= minZ ||
                coord.z >= maxZ
            {
                return true
            }

            return false
        }

        var unobstructedSurfaceCount = 0

        // For each blob face, DFS to find a path to water
        for blob in lavaBlobs {
            scanBlobFaces:
                for dir in Direction3D.allCases
            {
                var stack = Deque<Coordinate3D>()
                let candidate = blob.applying(dir.offset)
                stack.append(candidate)
                var visited = Set<Coordinate3D>()
                dfs:
                    while !stack.isEmpty
                {
                    let current = stack.popLast()!
                    visited.insert(current)

                    guard !obstructed.contains(candidate) else {
                        continue dfs
                    }

                    if isDefinitelyUnobstructed(current) {
                        unobstructed.formUnion(visited)
                        unobstructedSurfaceCount += 1
                        continue scanBlobFaces
                    }

                    let nextCandidates = Direction3D
                        .allCases
                        .map { current.applying($0.offset) }
                        .filter { !visited.contains($0) }
                        .filter { !obstructed.contains($0) }

                    stack.append(contentsOf: nextCandidates)
                }
                obstructed.formUnion(visited)
            }
        }

        return unobstructedSurfaceCount
    }
}

// MARK: - Structures
