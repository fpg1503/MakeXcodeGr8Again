import Foundation

struct XcodeCopier {
    let baseURL: URL
    
    private var newURL: URL? {
        return try? baseURL.deletingLastPathComponent().appendingPathComponent("XcodeGr8.app")
    }
    
    
}
