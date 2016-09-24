import Foundation

struct XcodeProvider {

    private var command = "mdfind kMDItemCFBundleIdentifier = \"com.apple.dt.Xcode\""

    var installedXcodes: [Xcode] {
        return []
    }


}

