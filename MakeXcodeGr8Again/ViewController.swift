import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet private var YOLOMode: NSButtonCell?
    
    var YOLO: Bool {
        return YOLOMode?.state == NSOnState
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dragView = view as? DragView {
            dragView.delegate = self
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.title = "Make Xcode Gr8 Again"
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
