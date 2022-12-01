//
//  String+Lines.swift
//  
//
//  Created by Schmelter, Tim on 12/1/22.
//

import Foundation

extension String {
    public static func lines(fromFile fileURL: URL) throws -> [String] {
        let input = try String(contentsOf: fileURL)
        return input.lines
    }

    public var lines: [String] {
        components(separatedBy: "\n")
    }
}
