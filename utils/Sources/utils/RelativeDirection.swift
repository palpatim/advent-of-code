//
//  RelativeDirection.swift
//  
//
//  Created by Schmelter, Tim on 12/22/22.
//

public enum RelativeDirection: CaseIterable {
    case right, down, left, up
}

extension RelativeDirection: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "u", "up":
            self = .up
        case "r", "right":
            self = .right
        case "d", "down":
            self = .down
        case "l", "left":
            self = .left
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .up: return "up"
        case .right: return "right"
        case .down: return "down"
        case .left: return "left"
        }
    }
}

extension RelativeDirection {
    /// Returns a new RelativeDirection after turning either `left` or `right`.
    ///
    /// If `relativeDirection` is not either `left` or `right`, returns the receiver.
    /// - Parameter relativeDirection: the direction to turn, either `left` or `right`
    /// - Returns: the new RelativeDirection after turning
    public func turned(oneStep relativeDirection: RelativeDirection) -> RelativeDirection {
        guard relativeDirection == .left || relativeDirection == .right else {
            return self
        }
        let offset = relativeDirection == .left ? -1 : 1
        let currentIndex = RelativeDirection.allCases.firstIndex(of: self)!
        return RelativeDirection.allCases[circular: currentIndex + offset ]
    }

    /// Turns the receiver either `left` or `right`.
    ///
    /// If `relativeDirection` is not either `left` or `right`, this method has no effect.
    /// - Parameter relativeDirection: the direction to turn, either `left` or `right`
    public mutating func turn(oneStep relativeDirection: RelativeDirection) {
        self = turned(oneStep: relativeDirection)
    }
}

extension RelativeDirection: Hashable { }
