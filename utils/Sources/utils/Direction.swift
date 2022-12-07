//
//  Direction.swift
//  
//
//  Created by Schmelter, Tim on 12/17/21.
//

public enum Direction: CaseIterable {
    case n, ne, e, se, s, sw, w, nw

    public static var cardinal: [Direction] {
        [.n, .e, .s, .w]
    }

    public var oppositeDirection: Direction {
        switch self {
        case .n: return .s
        case .ne: return .sw
        case .e: return .w
        case .se: return .nw
        case .s: return .n
        case .sw: return .ne
        case .w: return .e
        case .nw: return .se
        }
    }
}

extension Direction: Hashable { }
