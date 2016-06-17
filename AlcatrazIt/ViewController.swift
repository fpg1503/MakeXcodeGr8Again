import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unsigner = XcodeUnsigner(baseURL: URL(fileURLWithPath: "~/Downloads/Xcode"))
        do {
            try unsigner.unsignBlah()
        } catch (let error) {
            print(error)
        }
        print(unsigner)
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

