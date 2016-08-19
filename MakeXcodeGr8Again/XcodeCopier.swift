import Foundation

struct XcodeCopier {
    let baseURL: URL
    let manager = FileManager.default
    
    init(xcode: Xcode) {
        baseURL = xcode.url
    }
    
    private var newURL: URL {
        return baseURL.deletingLastPathComponent().appendingPathComponent("XcodeGr8.app/")
    }
    
    func copyXcode() -> URL? {
        guard !manager.fileExists(atPath: newURL.path) else {
            return newURL
        }
        
        do {
            try manager.copyItem(at: baseURL, to: newURL)
            return newURL
        } catch (let error) {
            print("Error: \(error)")
            return .none
        }
    }
}
