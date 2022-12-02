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

// MARK: - Errors

public struct StringParsingError: Error {
    public let message: String
    public let underlyingError: Error?

    public init(_ message: String, _ underlyingError: Error? = nil) {
        self.message = message
        self.underlyingError = underlyingError
    }
}
