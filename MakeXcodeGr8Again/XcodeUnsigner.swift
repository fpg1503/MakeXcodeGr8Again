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

    private func pointer(from URL: URL) -> UnsafeMutablePointer<CChar>? {
        let path = URL.path
        let array = path.cString(using: .ascii)
        return UnsafeMutablePointer(mutating: array)
    }

    var isUnsigned: Bool {
        return is_unsigned(pointer(from: binaryLocation))
    }
    
    private func unsignExecutable(at originalLocation: URL, to unsignedLocation: URL) throws {

        guard manager.fileExists(atPath: originalLocation.path) else {
                throw UnsignError.inputFileDoesNotExist(originalLocation.path)
        }

        let inputPointer = pointer(from: originalLocation)
        let outputPointer = pointer(from: unsignedLocation)
        
        unsign(inputPointer, outputPointer)
    }
}
