import Foundation
import utils

public enum day19 {
    public static func solve(_: String) -> Int {
        return 0
    }

    public static func parseInput(_ input: String) -> Puzzle {
        let lines = input.components(separatedBy: "\n")
        var scannerId = 0
        var beacons = [Coordinate3D]()
        var scanners = [Scanner]()
        for line in lines {
            guard !line.hasPrefix("---") else {
                continue
            }

            if line.isEmpty {
                let scanner = Scanner(
                    id: scannerId,
                    beacons: beacons
                )
                scanners.append(scanner)
                scannerId += 1
                beacons = []
                continue
            }
            let coord = Coordinate3D(stringValue: line)
            beacons.append(coord)
        }

        let puzzle = Puzzle(scanners: scanners)
        return puzzle
    }
}

public struct Scanner {
    let id: Int
    let beacons: [Coordinate3D]
}

public struct Puzzle {
    let scanners: [Scanner]
}
