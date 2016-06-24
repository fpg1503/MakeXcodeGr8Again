import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dragView = view as? DragView {
            dragView.delegate = self
        }
    }
}

extension ViewController: DragViewDelegate {
    var acceptedFileExtensions: [String] { return ["app"] }
    func dragView(_ dragView: DragView, didDragFileWith fileURL: URL) {
        let xcode = Xcode(url: fileURL)
        if let xcodeGreat = xcode.makeGreatAgain() {
            print("WOO HOO! \(xcodeGreat)")
        } else {
            print("Not this time, brah")
        }
    }
}
