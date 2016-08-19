import Cocoa

protocol DragViewDelegate {
    var acceptedFileExtensions: [String] { get }
    func dragView(_ dragView: DragView, didDragFileWith fileURL: URL)
}

class DragView: NSView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
    private var fileTypeIsOk = false
    private var acceptedFileExtensions: [String] {
        return delegate?.acceptedFileExtensions ?? []
    }
    
    var delegate: DragViewDelegate?
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(drag: sender) {
            fileTypeIsOk = true
            return .copy
        } else {
            fileTypeIsOk = false
            return []
        }
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if fileTypeIsOk {
            return .copy
        } else {
            return []
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let draggedFileURL = sender.draggedFileURL else {
            return false
        }
        
        delegate?.dragView(self, didDragFileWith: draggedFileURL)
        
        return true
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let fileExtension = drag.draggedFileURL?.pathExtension.lowercased() else {
            return false
        }
        
        return acceptedFileExtensions.contains(fileExtension)
    }
}
