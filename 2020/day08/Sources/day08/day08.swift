import Foundation
public struct day08 {

    public static func solvePart1(program: Program) -> Int {
        let runtime = ProgramRuntime(program)

        defer {
            runtime.printHistory()
        }

        do {
            let acc = try runtime.execute()
            return acc
        } catch let error as ProgramRuntime.RuntimeError {
            switch error {
            case
                    .loopDetected(_, let acc),
                    .negativeInstructionIndex(_, let acc):
                return acc
            }
        } catch {
            preconditionFailure("Unrecognized error: \(error)")
        }
    }

    public static func solvePart2(rawInput: String) -> Int {
        let originalProgram = parseInput(rawInput)
        let candidates = originalProgram
            .enumerated()
            .filter { $1.name == "nop" || $1.name == "jmp" }

        var currentProgram = originalProgram
        var currentRuntime = ProgramRuntime(currentProgram)
        print("Original program")

        for (line, instruction) in candidates {
            currentProgram = originalProgram
            let originalInstruction = instruction
            let arg = instruction.arg
            let newInstruction = originalInstruction.name == "jmp"
                ? Instruction.nop(arg)
                : Instruction.jmp(arg)
            print("Changing line \(line) to \(newInstruction)")
            currentProgram[line] = newInstruction
            currentRuntime = ProgramRuntime(currentProgram)

            defer {
                currentRuntime.printHistory()
            }

            if let value = try? currentRuntime.execute() {
                return value
            }
        }

        // Can't find any good value
        currentRuntime.printHistory()
        return -1
    }

    public static func parseInput(_ input: String) -> Program {
        let lines = input.split(separator: "\n")
        let program = lines
            .map { Instruction(rawValue: String($0)) }
        return program
    }
}

public typealias Program = [Instruction]

public struct ProgramStep {
    let stepIndex: Int
    let lineIndex: Int
    let instruction: Instruction
    let accumulator: Int
}

extension ProgramStep: CustomStringConvertible {
    public static var header: String {
        """
        | step | line | ins |    arg |      acc |
        """
    }

    public var description: String {
        let acc = "\(accumulator)"
            .paddingToLeft(upTo: 8)

        let arg = "\(instruction.arg)"
            .paddingToLeft(upTo: 6)
        let components = [
            "| ",
            String(format: "%04d", stepIndex),
            " | ",
            String(format: "%04d", lineIndex),
            " | ",
            "\(instruction.name)",
            " | ",
            String(arg),
            " | ",
            String(acc),
            " |"
        ]
        return components.joined()
    }

}

public class ProgramRuntime {
    enum RuntimeError: Error {
        case negativeInstructionIndex(
            instructionIndex: Int,
            accumulatorValue: Int
        )
        case loopDetected(
            instructionIndex: Int,
            accumulatorValue: Int
        )
    }

    let program: Program
    var visited: Set<Int>
    var currentIndex: Int
    var accumulator: Int
    var history: [ProgramStep]

    public init(_ program: Program) {
        self.program = program
        self.currentIndex = 0
        self.accumulator = 0
        self.visited = []
        self.history = []
    }

    func execute() throws -> Int {
        while currentIndex < program.count {
            let debugIndex = String(format: "%04d", currentIndex)
            guard !visited.contains(currentIndex) else {
                throw RuntimeError.loopDetected(
                    instructionIndex: currentIndex,
                    accumulatorValue: accumulator
                )
            }
            visited.insert(currentIndex)

            guard currentIndex >= 0 else {
                throw RuntimeError.negativeInstructionIndex(
                    instructionIndex: currentIndex,
                    accumulatorValue: accumulator
                )
            }

            let instruction = program[currentIndex]

            let step = ProgramStep(
                stepIndex: history.count,
                lineIndex: currentIndex,
                instruction: instruction,
                accumulator: accumulator
            )
            history.append(step)

            switch instruction {
            case .acc(let offset):
                accumulator += offset
                currentIndex += 1
            case .jmp(let offset):
                currentIndex += offset
            case .nop:
                currentIndex += 1
            }

        }

        return accumulator
    }

    func printHistory() {
        print(ProgramStep.header)
        for step in history {
            print(step.description)
        }
    }
}

public enum Instruction {
    case acc(Int)
    case jmp(Int)
    case nop(Int)

    init(rawValue: String) {
        let components = rawValue.components(separatedBy: " ")
        let instruction = components[0]
        guard let argument = Int(components[1]) else {
            preconditionFailure("Argument format error: \(rawValue)")
        }
        switch instruction {
        case "acc":
            self = .acc(argument)
        case "jmp":
            self = .jmp(argument)
        case "nop":
            self = .nop(argument)
        default:
            preconditionFailure("Unknown instruction: '\(rawValue)'")
        }
    }

    var name: String {
        switch self {
        case .acc:
            return "acc"
        case .jmp:
            return "jmp"
        case .nop:
            return "nop"
        }
    }

    var arg: Int {
        switch self {
        case .acc(let arg), .jmp(let arg), .nop(let arg):
            return arg
        }
    }

}

// https://stackoverflow.com/a/52447981/603369
extension RangeReplaceableCollection where Self: StringProtocol {
    func paddingToLeft(upTo length: Int, using element: Element = " ") -> SubSequence {
        return repeatElement(element, count: Swift.max(0, length-count)) + suffix(Swift.max(count, count-length))
    }
}
