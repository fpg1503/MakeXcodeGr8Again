import Foundation

enum XGhostPreventerInstallerError: String, Error {
    case pluginNotFound = "Unable to find xGhostPreventer.xcplugin in app resources"
    case destinationNotFound = "Unable to find destination path for xGhostPreventer"
}

struct XGhostPreventerInstaller {
    let manager = FileManager.default
    
    private var pluginDestinationURL: URL? {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        return URL(fileURLWithPath: basePath + "/Developer/Shared/Xcode/Plug-ins")
    }
    
    private var pluginSourceURL: URL? {
        return Bundle.main.url(forResource: "xGhostPreventer", withExtension: "xcplugin")
    }
    
    func install() throws {
        guard let sourceURL = self.pluginSourceURL else {
            throw XGhostPreventerInstallerError.pluginNotFound
        }
        
        guard let destinationURL = self.pluginDestinationURL else {
            throw XGhostPreventerInstallerError.destinationNotFound
        }
        
        try manager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        try manager.copyItem(at: sourceURL, to: destinationURL.appendingPathComponent("xGhostPreventer.xcplugin"))
    }
}
