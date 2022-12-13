//
//  LinkedList.swift
//
//
//  Created by Schmelter, Tim on 12/9/22.
//

import Foundation

open class LinkedList<Value> {
    public var value: Value
    public var next: LinkedList<Value>?

    public var isTail: Bool {
        next == nil
    }

    public init(_ value: Value) {
        self.value = value
    }
}

extension LinkedList: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(value)->\(next?.debugDescription ?? "nil")"
    }
}
