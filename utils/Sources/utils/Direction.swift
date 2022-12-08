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

    /// The range in radians representing the direction, where 0 is the horizontal axis and Pi/2 is the vertical axis.
    ///
    /// Positive value of `radians` is interpreted as an angle counterclockwise from the horizontal axis; negative value of `radians`
    /// is intrepreted as a clockwise angle.
    init?(radians: Float) {
        let unsignedAngle = radians >= 0 ? radians : (Float.pi * 2) + radians
        let resolvedAngle = unsignedAngle.truncatingRemainder(dividingBy: Float.pi * 2)
        switch resolvedAngle {
        case Direction.n.radiansRange: self = .n
        case Direction.ne.radiansRange: self = .ne
        case Direction.e.radiansRange: self = .e
        case Direction.se.radiansRange: self = .se
        case Direction.s.radiansRange: self = .s
        case Direction.sw.radiansRange: self = .sw
        case Direction.w.radiansRange: self = .w
        case Direction.nw.radiansRange: self = .nw
        default: fatalError("Value out of bounds: \(radians)")
        }
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

    /// Returns compas heading where 0 is north and 90 is east. Note that this does not match ``Offset`` definitions, which assume
    /// an XY coordinate system where X is 0, Y is 90.
    public var compasHeadingDegrees: Int {
        switch self {
        case .n: return 0
        case .ne: return 45
        case .e: return 90
        case .se: return 135
        case .s: return 180
        case .sw: return 225
        case .w: return 270
        case .nw: return 315
        }
    }

    /// Returns the angle in radians of a vector with magntitude 1 to the horizontal axis
    public var radians: Float {
        switch self {
        case .e: return 0.0
        case .ne: return 0.25 * Float.pi
        case .n: return 0.5 * Float.pi
        case .nw: return 0.75 * Float.pi
        case .w: return Float.pi
        case .sw: return 1.25 * Float.pi
        case .s: return 1.5 * Float.pi
        case .se: return 1.75 * Float.pi
        }
    }

    /// Returns a range in radians vs. the horizontal axis corresponding
    private var radiansRange: Range<Float> {
        let increment = 0.25 * Float.pi

        switch self {
        case .e: return Range.range(of: increment, centeredOn: Direction.e.radians)
        case .ne: return Range.range(of: increment, centeredOn: Direction.ne.radians)
        case .n: return Range.range(of: increment, centeredOn: Direction.n.radians)
        case .nw: return Range.range(of: increment, centeredOn: Direction.nw.radians)
        case .w: return Range.range(of: increment, centeredOn: Direction.w.radians)
        case .sw: return Range.range(of: increment, centeredOn: Direction.sw.radians)
        case .s: return Range.range(of: increment, centeredOn: Direction.s.radians)
        case .se: return Range.range(of: increment, centeredOn: Direction.se.radians)
        }
    }

}

private extension Range<Float> {
    static func range(of size: Float, centeredOn center: Float) -> Range<Float> {
        let lowerBound = center - (size / 2)
        let upperBound = center + (size / 2)
        return lowerBound ..< upperBound
    }
}

extension Direction: Hashable { }
