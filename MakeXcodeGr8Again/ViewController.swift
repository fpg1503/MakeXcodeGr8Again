import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet private var YOLOMode: NSButtonCell?
    @IBOutlet private var gratingView: NSView?
    @IBOutlet private var progressIndicator: NSProgressIndicator?
    
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

    var busy: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.progressIndicator?.startAnimation(nil)
                self.gratingView?.isHidden = !self.busy
            }
        }
    }
}

extension ViewController: DragViewDelegate {
    var acceptedFileExtensions: [String] { return ["app"] }
    func dragView(_ dragView: DragView, didDragFileWith fileURL: URL) {
        let xcode = Xcode(url: fileURL)

        busy = true

        DispatchQueue(label: "").async {
            do {
                let xcodeGreat = try xcode.makeGreatAgain(YOLO: self.YOLO)
                print("WOO HOO! \(xcodeGreat)")
                self.busy = false
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Great!"
                    alert.informativeText = "Xcode is Great again!"
                    alert.addButton(withTitle: "Awesome!")
                    alert.alertStyle = .informational

                    alert.runModal()
                }
            } catch (let error) {
                print("Not this time, brah")
                self.busy = false

                DispatchQueue.main.async {
                    let alert = NSAlert(error: error)
                    alert.informativeText = error.localizedDescription
                    alert.alertStyle = .critical

                    alert.runModal()
                }
            }
        }

    }
}
