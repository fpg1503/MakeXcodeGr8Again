import Foundation

struct Xcode {
    
    let url: URL
    
    func makeGreatAgain() -> URL? {
        let _ = XcodeCopier(baseURL: url)
        
        return .none
    }
}
