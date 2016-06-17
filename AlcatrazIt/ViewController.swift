import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xcode = Xcode(url: URL(fileURLWithPath: "~/Downloads/Xcode"))
        
        if let xcodeGreat = xcode.makeGreatAgain() {
            print("WOHOOL! \(xcodeGreat)")
        } else {
            print("Not this time, brah")
        }
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

