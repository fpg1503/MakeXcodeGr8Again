import Foundation

private extension Pipe {
    func stringsToEndOfFile(encoding: String.Encoding = .ascii) -> [String] {
        let data = fileHandleForReading.readDataToEndOfFile()
        let contents = String(data: data, encoding: encoding) ?? ""

        let clearContents = contents.trimmingCharacters(in: .newlines)

        return clearContents.components(separatedBy: "\n")
    }
}

struct System {

    typealias CommandReturn = (output: [String], error: [String], exitCode: Int32)

    static func runOnBash(command: String) -> CommandReturn {
        return run(command: "/bin/bash", args: "-l", "-c", command)
    }

    static func run(command: String, args: String...) -> CommandReturn {

        let process = Process()
        process.launchPath = command
        process.arguments = args

        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        let errorPipe = Pipe()
        process.standardError = errorPipe

        process.launch()

        let output = outputPipe.stringsToEndOfFile()
        let error = errorPipe.stringsToEndOfFile()
        
        process.waitUntilExit()
        let status = process.terminationStatus
        
        return (output, error, status)
    }
}
