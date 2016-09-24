import Foundation

struct XcodeProvider {

    private var command = "mdfind kMDItemCFBundleIdentifier = \"com.apple.dt.Xcode\""

    var installedXcodes: [Xcode] {
        let output = System.runOnBash(command: command).output

        let urls = output.map(URL.init(fileURLWithPath:))

        //TODO: Check if Xcode is great, check if paths are valid
        let xcodes = urls.map { Xcode(url: $0) }

        return xcodes
    }


}

