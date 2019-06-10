//
//  GPAPIConstant.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

enum DeploymentType : Int {
    case kLocal = 1
    case kProduction = 2
    case kStaging = 3
}

class GPAPIConstant {
    static let sharedConstant = GPAPIConstant()
    var deploymentType : DeploymentType = .kProduction
    
    func baseUrl() -> String {
        switch self.deploymentType {
            case .kProduction:
                return self.baseProductionUrl
            case .kStaging:
                return self.baseStagingUrl
            default:
                return self.baseLocalUrl
        }
    }
    
    let baseLocalUrl = "http://api.giphy.com"
    let baseProductionUrl = "http://api.giphy.com"
    let baseStagingUrl = "http://api.giphy.com"
    
    static let apiVersion1 = "v1"
}
