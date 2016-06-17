import Foundation

struct XcodeCopier {
    let baseURL: URL
    
    init(xcode: Xcode) {
        baseURL = xcode.url
    }
    
    private var newURL: URL? {
        return try? baseURL.deletingLastPathComponent().appendingPathComponent("XcodeGr8.app")
    }
    
    func copyXcode() -> URL? {
        //TODO: Copy
        return newURL
    }
}
