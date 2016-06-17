//
//  XcodeCopier.swift
//  AlcatrazIt
//
//  Created by Francesco Perrotti-Garcia on 6/17/16.
//  Copyright © 2016 Francesco Perrotti-Garcia. All rights reserved.
//

import Foundation

struct XcodeCopier {
    let baseURL: URL
    
    private var newURL: URL? {
        return try? baseURL.deletingLastPathComponent().appendingPathComponent("XcodeGr8.app")
    }
    
    
}
