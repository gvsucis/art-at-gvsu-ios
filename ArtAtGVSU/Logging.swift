//
//  Logging.swift
//  ArtAtGVSU
//
//  Created by Josiah Campbell on 12/1/23.
//  Copyright © 2023 Applied Computing Institute. All rights reserved.
//

import Foundation
import os.log

protocol Logging {
    var logger: Logger { get }
    static var logger: Logger { get }
}

extension Logging  {
    var logger: Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: type(of: self)))
    }
    
    static var logger: Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: type(of: self)))
    }
}
