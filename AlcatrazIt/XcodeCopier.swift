import Foundation

struct XcodeCopier {
    let baseURL: URL
    let manager = FileManager.default()
    
    init(xcode: Xcode) {
        baseURL = xcode.url
    }
    
    private var newURL: URL? {
        return try? baseURL.deletingLastPathComponent().appendingPathComponent("XcodeGr8.app/")
    }
    
    func copyXcode() -> URL? {
        guard let newURL = newURL else {
            return .none
        }
        
        guard let path = newURL.path where !manager.fileExists(atPath: path) else {
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
