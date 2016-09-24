import Foundation

struct XcodeUnsigner {
    
    enum UnsignError: Error {
        case inputFileDoesNotExist(String)
    }
    
    let baseURL: URL
    let manager = FileManager.default
    
    init(xcode: Xcode) {
        baseURL = xcode.url
    }
    
    private var binaryLocation: URL {
        return URL(fileURLWithPath: "Contents/MacOS/Xcode", relativeTo: baseURL)
    }
    private var unsignedLocation: URL {
        return URL(fileURLWithPath: "Contents/MacOS/Xcode.unsigned", relativeTo: baseURL)
    }
    
    func irreversiblyUnsign() throws {
        try unsignExecutable(at: binaryLocation, to: unsignedLocation)
        try manager.removeItem(at: binaryLocation)
        try manager.moveItem(at: unsignedLocation, to: binaryLocation)
    }

    var isUnsigned: Bool {

        let binaryPath = binaryLocation.path
        let binaryArray = binaryPath.cString(using: .ascii)
        let binaryPointer = UnsafeMutablePointer(mutating: binaryArray)

        return is_unsigned(binaryPointer)
    }
    
    private func unsignExecutable(at originalLocation: URL, to unsignedLocation: URL) throws {

        let inputPath = originalLocation.path
        let outputPath = unsignedLocation.path
        
        guard manager.fileExists(atPath: inputPath) else {
            throw UnsignError.inputFileDoesNotExist(inputPath)
        }

        let inputArray = inputPath.cString(using: .ascii)
        let outputArray = outputPath.cString(using: .ascii)


        let inputPointer = UnsafeMutablePointer(mutating: inputArray)
        let outputPointer = UnsafeMutablePointer(mutating: outputArray)
        
        unsign(inputPointer, outputPointer)
    }
}
