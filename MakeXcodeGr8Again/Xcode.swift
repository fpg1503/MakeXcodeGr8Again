import Foundation

enum XcodeError: String, Error {
    case XcodeAlreadyGreat = "Xcode is already great!"
}

struct Xcode {
    
    let url: URL
    var great: Bool {
        let unsigner = XcodeUnsigner(xcode: self)

        return unsigner.isUnsigned
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func makeGreatAgain(YOLO: Bool = false) throws -> Xcode {
//        guard !great else {
//            print("Xcode has already been grated!")
//            throw XcodeError.XcodeAlreadyGreat
//        }

        let newXcode = YOLO ? self : try copy()
        return try newXcode.grate()
    }
    
    private func copy() throws -> Xcode {
        let copier = XcodeCopier(xcode: self)
        let newURL = try copier.copyXcode()
        
        return Xcode(url: newURL)
    }
    
    private func grate() throws -> Xcode {
        let unsigner = XcodeUnsigner(xcode: self)
        try unsigner.irreversiblyUnsign()
        return Xcode(url: url)
    }
}
