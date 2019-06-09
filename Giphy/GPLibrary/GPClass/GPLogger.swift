//
//  GPLogger.swift
//  Giphy
//
//  Created by Tirupati Balan on 09/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

class GPLogger {
    var isLogEnabled = true
    
    class var sharedLogger : GPLogger {
        struct defaultSingleton {
            static let loggerInstance = GPLogger()
        }
        return defaultSingleton.loggerInstance
    }
    
    class func log(_ logString : Any) {
        print(GPLogger.sharedLogger.isLogEnabled ? "GP: \(logString)" : "")
    }
}
