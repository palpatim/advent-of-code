public struct day16 {
    public static func solve(_ input: String) -> BITSPacket {
        let packet = BITSPacket.from(hexString: input)
        return packet
    }

}

public class BITSPacket {
    public enum PacketType: Int {
        case sum = 0
        case product = 1
        case minimum = 2
        case maximum = 3
        case literal = 4
        case greaterThan = 5
        case lessThan = 6
        case equalTo = 7
    }

    var version: Int
    var packetTypeID: Int
    var literal: Int?
    var children: [BITSPacket]

    public func versionSum() -> Int {
        version + children.map { $0.versionSum() }.reduce(0, +)
    }

    public init(
        version: Int = -1,
        packetTypeID: Int = -1,
        literal: Int? = nil,
        children: [BITSPacket] = []
    ) {
        self.version = version
        self.packetTypeID = packetTypeID
        self.literal = literal
        self.children = children
    }

    public static func from(hexString: String) -> BITSPacket {
        var parser = Parser(hexString: hexString)
        return parser.parse()
    }

    public func evaluate() -> Int {
        guard let packetType = PacketType(rawValue: packetTypeID) else {
            fatalError("Invalid packetTypeID: \(packetTypeID)")
        }

        switch packetType {
        case .sum:
            return children.map { $0.evaluate() }.reduce(0, +)

        case .product:
            return children.map { $0.evaluate() }.reduce(1, *)

        case .minimum:
            return children.map { $0.evaluate() }.min()!

        case .maximum:
            return children.map { $0.evaluate() }.max()!

        case .literal:
            return literal!

        case .greaterThan:
            let values = children.map { $0.evaluate() }
            return values[0] > values[1] ? 1 : 0

        case .lessThan:
            let values = children.map { $0.evaluate() }
            return values[0] < values[1] ? 1 : 0

        case .equalTo:
            let values = children.map { $0.evaluate() }
            return values[0] == values[1] ? 1 : 0
        }

    }

}

extension BITSPacket {
    public struct Parser {
        private enum State {
            case start
            case parsingVersion
            case parsingType
            case parsingLiteral
            case parsingLengthTypeID
            case parsingLengthBasedPacketChunk
            case parsingCountBasedPacketChunk
            case parsingLengthBasedContainer(endIndex: String.Index)
            case parsingCountBasedContainer(remainingCount: Int)
            case doneParsingPacket
        }

        private let bitString: String

        private var currentIndex: String.Index
        private var packets: [BITSPacket]
        private var stack: [State]

        public init(hexString: String) {
            let bitString = Parser.hexStringToBitString(hexString)
            self.init(bitString: bitString)
        }

        public init(bitString: String) {
            self.bitString = bitString
            self.currentIndex = bitString.startIndex
            self.packets = []
            self.stack = [.start]
        }

        public mutating func parse() -> BITSPacket {
            while !stack.isEmpty {
                let state = stack.pop()

                switch state {
                case .start:
                    packets.push(BITSPacket())
                    stack.push(.parsingVersion)

                case .parsingLengthBasedContainer, .parsingCountBasedContainer:
                    break;

                case .parsingVersion:
                    let version = parseVersion()
                    packets.last!.version = version
                    stack.push(.parsingType)

                case .parsingType:
                    let packetTypeID = parsePacketTypeID()
                    packets.last!.packetTypeID = packetTypeID

                    switch packetTypeID {
                    case PacketType.literal.rawValue:
                        stack.push(.parsingLiteral)
                    default:
                        stack.push(.parsingLengthTypeID)
                    }

                case .parsingLiteral:
                    let literal = parseLiteral()
                    packets.last!.literal = literal
                    stack.push(.doneParsingPacket)

                case .parsingLengthTypeID:
                    let lengthTypeID = parseLengthTypeID()
                    switch lengthTypeID {
                    case 0:
                        stack.push(.parsingLengthBasedPacketChunk)
                    case 1:
                        stack.push(.parsingCountBasedPacketChunk)
                    default:
                        // Should not happen since we're parsing a single bit in parseLengthTypeID
                        fatalError("Invalid lengthTypeID: \(lengthTypeID)")
                    }

                case .parsingLengthBasedPacketChunk:
                    let endIndex = parseLengthBasedPacketChunk()
                    stack.push(.parsingLengthBasedContainer(endIndex: endIndex))
                    stack.push(.start)

                case .parsingCountBasedPacketChunk:
                    let count = parseCountBasedPacketChunk()
                    stack.push(.parsingCountBasedContainer(remainingCount: count))
                    stack.push(.start)

                case .doneParsingPacket:
                    guard let currentState = stack.peek() else {
                        break
                    }
                    switch currentState {
                    case .parsingLengthBasedContainer(let endIndex):
                        let packet = packets.pop()
                        if let parentPacket = packets.last {
                            parentPacket.children.append(packet)
                        } else {
                            packets.append(packet)
                        }

                        if currentIndex == endIndex {
                            _ = stack.pop()
                            stack.push(.doneParsingPacket)
                        } else {
                            stack.push(.start)
                        }

                    case .parsingCountBasedContainer(let remainingCount):
                        _ = stack.pop()

                        let packet = packets.pop()
                        if let parentPacket = packets.last {
                            parentPacket.children.append(packet)
                        } else {
                            packets.append(packet)
                        }

                        if remainingCount > 1 {
                            stack.push(.parsingCountBasedContainer(remainingCount: remainingCount - 1))
                            stack.push(.start)
                        } else {
                            stack.push(.doneParsingPacket)
                        }

                    default:
                        break
                    }

                }
            }

            return packets[0]
        }

        // MARK: - Element parsers

        /// All methods in this section parse the appropriate value, push it to `elements`, and advance the index

        private mutating func parseCountBasedPacketChunk() -> Int {
            let count = parseIntValue(size: 11)
            return count
        }

        private mutating func parseLengthBasedPacketChunk() -> String.Index {
            let length = parseIntValue(size: 15)
            let endIndex = bitString.index(currentIndex, offsetBy: length)
            return endIndex
        }

        private mutating func parseLengthTypeID() -> Int {
            let lengthTypeID = parseIntValue(size: 1)
            return lengthTypeID
        }

        /// Parse int literal chunks starting with the current index. Push the resulting int literal to `elements` and advance the
        /// index to immediately after the literal. (This means the index will still not have advanced past any garbage characters after
        /// the literal.)
        private mutating func parseLiteral() -> Int {
            var partial = ""
            var done = false
            while !done {
                let firstBit = parseIntValue(size: 1)
                let chunk = parseBitString(size: 4)
                partial += chunk
                done = firstBit == 0
            }

            let intValue = Int(partial, radix: 2)!
            return intValue
        }

        private mutating func parseTotalSubPacketLength() -> Int {
            let lengthTypeID = parseIntValue(size: 1)
            return lengthTypeID
        }

        private mutating func parsePacketTypeID() -> Int {
            let packetTypeID = parseIntValue(size: 3)
            return packetTypeID
        }

        private mutating func parseVersion() -> Int {
            let version = parseIntValue(size: 3)
            return version
        }

        // MARK: - Utilities

        /// Parse the next `size` bits of `bitString` into an bitstring chunk, and advance the index
        private mutating func parseBitString(size: Int) -> String {
            let stopIndex = bitString.index(currentIndex, offsetBy: size)
            let value = String(bitString[currentIndex ..< stopIndex])
            currentIndex = stopIndex
            return value
        }

        /// Parse the next `size` bits of `bitString` into an Integer value, and advance the index.
        private mutating func parseIntValue(size: Int) -> Int {
            let chunk = parseBitString(size: size)
            return Int(chunk, radix: 2)!
        }

        /// Convert an arbitrary-length hex string into a bit string, one byte at a time. Will definitely overflow if you try to take the entire
        /// resulting string into an Int.
        public static func hexStringToBitString(_ hexString: String) -> String {
            let bitString = hexString
                .reduce("") { acc, curr in
                    let stringValue = String(curr)
                    let bits = String(UInt8(stringValue, radix: 16)!, radix: 2)
                    return acc + bits.paddingToLeft(upTo: 4, using: "0")
                }
            return bitString
        }
    }

}

// Convenience stack-like aliases
private extension Array {
    mutating func push(_ element: Element) {
        append(element)
    }

    mutating func pop() -> Element {
        removeLast()
    }

    mutating func peek() -> Element? {
        last
    }
}

// https://stackoverflow.com/a/52447981/603369
extension RangeReplaceableCollection where Self: StringProtocol {
    func paddingToLeft(upTo length: Int, using element: Element = " ") -> SubSequence {
        return repeatElement(element, count: Swift.max(0, length-count)) + suffix(Swift.max(count, count-length))
    }
}
