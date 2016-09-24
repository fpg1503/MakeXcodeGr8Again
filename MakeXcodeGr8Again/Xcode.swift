import Foundation

struct Xcode {
    
    let url: URL
    var great: Bool {
        let unsigner = XcodeUnsigner(xcode: self)

        return unsigner.isUnsigned
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func makeGreatAgain(YOLO: Bool = false) -> Xcode? {
//        guard !great else {
//            print("Xcode has already been grated!")
//            return self
//        }
        
        let newXcode = YOLO ? self : copy()
        return newXcode?.grate()
    }
    
    private func copy() -> Xcode? {
        let copier = XcodeCopier(xcode: self)
        let newURL = copier.copyXcode()
        
        return newURL.map { Xcode(url: $0) }
    }
    
    private func grate() -> Xcode? {
        let unsigner = XcodeUnsigner(xcode: self)
        do {
            try unsigner.irreversiblyUnsign()
            return Xcode(url: url)
        } catch (let error) {
            print("Error: \(error)")
            return .none
        }
    }
}
