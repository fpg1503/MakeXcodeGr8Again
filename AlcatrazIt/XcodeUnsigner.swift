//
//  XcodeUnsigner.swift
//  AlcatrazIt
//
//  Created by Francesco Perrotti-Garcia on 6/17/16.
//  Copyright © 2016 Francesco Perrotti-Garcia. All rights reserved.
//

import Foundation

struct XcodeUnsigner {
    
    enum Error: ErrorProtocol {
        case inputFileDoesNotExist(String)
    }
    
    let baseURL: URL
    let manager = FileManager()
    
    private var binaryLocation: URL {
        return URL(fileURLWithPath: "Contents/MacOS/Xcode", relativeTo: baseURL)
    }
    private var unsignedLocation: URL {
        return URL(fileURLWithPath: "Contents/MacOS/Xcode.unsigned", relativeTo: baseURL)
    }
    
    func unsignBlah() throws {
        try unsignExecutable(at: binaryLocation, to: unsignedLocation)
        try manager.removeItem(at: binaryLocation)
        try manager.moveItem(at: unsignedLocation, to: binaryLocation)
    }
    
    private func unsignExecutable(at originalLocation: URL, to unsignedLocation: URL) throws {
        
        guard let inputPath = originalLocation.absoluteString,
            outputPath = unsignedLocation.absoluteString else {
                return
        }
        
        guard manager.fileExists(atPath: inputPath) else {
                throw Error.inputFileDoesNotExist(inputPath)
        }
        
        let inputArray = inputPath.cString(using: .ascii)
        let outputArray = outputPath.cString(using: .ascii)
        
        let inputPointer = UnsafeMutablePointer<CChar>(inputArray)
        let outputPointer = UnsafeMutablePointer<CChar>(outputArray)
        
        unsign(inputPointer, outputPointer)
    }
}
