//
//  Xcode.swift
//  AlcatrazIt
//
//  Created by Francesco Perrotti-Garcia on 6/17/16.
//  Copyright © 2016 Francesco Perrotti-Garcia. All rights reserved.
//

import Foundation

struct Xcode {
    
    let url: URL
    
    func makeGreatAgain() -> URL? {
        let copier = XcodeCopier(baseURL: url)
        
        return .none
    }
}
