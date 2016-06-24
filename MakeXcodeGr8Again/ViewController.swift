import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet private var YOLOMode: NSButtonCell?
    
    private var YOLO: Bool {
        return YOLOMode?.state == NSOnState
    }

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
        if let xcodeGreat = xcode.makeGreatAgain(YOLO: YOLO) {
            print("WOO HOO! \(xcodeGreat)")
        } else {
            print("Not this time, brah")
        }
    }
}
