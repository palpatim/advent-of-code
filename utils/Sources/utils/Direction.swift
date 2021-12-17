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
}
