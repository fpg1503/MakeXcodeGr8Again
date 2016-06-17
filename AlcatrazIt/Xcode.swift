import Foundation

struct Xcode {
    
    let url: URL
    
    func makeGreatAgain() -> URL? {
        let copier = XcodeCopier(baseURL: url)
        
        return .none
    }
}
