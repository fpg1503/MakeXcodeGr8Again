//
//  XcodeUnsigner.swift
//  AlcatrazIt
//
//  Created by Francesco Perrotti-Garcia on 6/17/16.
//  Copyright © 2016 Francesco Perrotti-Garcia. All rights reserved.
//

import Foundation

struct XcodeUnsigner {
    let baseURL: URL
    let manager = FileManager()
    
    private var binaryLocation: URL {
        return URL(fileURLWithPath: "Contents/MacOS/Xcode", relativeTo: baseURL)
    }
    private var unsignedLocation: URL {
        return URL(fileURLWithPath: "Contents/MacOS/Xcode.unsigned", relativeTo: baseURL)
    }
    
    func unsign() throws {
        try unsignExecutable(at: binaryLocation, to: unsignedLocation)
        try manager.removeItem(at: binaryLocation)
        try manager.moveItem(at: unsignedLocation, to: binaryLocation)
    }
    
    private func unsignExecutable(at originalLocation: URL, to unsignedLocation: URL) throws {
        //TODO!
    }
}
