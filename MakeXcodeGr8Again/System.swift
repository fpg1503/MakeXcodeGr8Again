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

    static func run(command: String, args: String...) -> CommandReturn {

        let task = Process()
        task.launchPath = command
        task.arguments = args

        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        let errorPipe = Pipe()
        task.standardError = errorPipe

        task.launch()

        let output = outputPipe.stringsToEndOfFile()
        let error = errorPipe.stringsToEndOfFile()
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
}
