import Foundation

struct Xcode {
    
    let url: URL
    let great: Bool
    
    init(url: URL, great: Bool = false) {
        self.url = url
        self.great = great
    }
    
    func makeGreatAgain() -> Xcode? {
        guard !great else {
            print("Xcode has already been grated!")
            return self
        }
        
        let newXcode = copy()
        return newXcode?.grate()
    }
    
    private func copy() -> Xcode? {
        let copier = XcodeCopier(xcode: self)
        let newURL = copier.copyXcode()
        
        return newURL.map { Xcode(url: $0, great: great) }
    }
    
    private func grate() -> Xcode? {
        let unsigner = XcodeUnsigner(xcode: self)
        do {
            try unsigner.irreversiblyUnsign()
            return Xcode(url: url, great: true)
        } catch {
            return .none
        }
    }
}
