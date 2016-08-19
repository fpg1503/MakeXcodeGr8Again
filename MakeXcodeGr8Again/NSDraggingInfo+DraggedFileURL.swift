import Cocoa

extension NSDraggingInfo {
    var draggedFileURL: URL? {
        let filenames = draggingPasteboard().propertyList(forType: NSFilenamesPboardType) as? [String]
        let path = filenames?.first
        
        return path.map(URL.init(fileURLWithPath:))
    }
}
