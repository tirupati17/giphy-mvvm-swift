//  
//  GPSearchViewControllerService.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

class GPSearchViewControllerService: GPSearchViewControllerServiceProtocol {
    // Call protocol function
    func searchImage(_ query : String, limit: String, offset: String, success: @escaping (GPSearchViewControllerModel) -> (), failure: @escaping (Error) -> ()) {
        GPAPIRequest.seachImage(query, limit: limit, offset: offset, success: { (response) in
            if let response = response as? GPSearchViewControllerModel {
                success(response)
            } else {
                failure(GPError.customError(message: "Invalid model"))
            }
        }) { (error) in
            failure(error)
        }
    }
    
    func trendingImage(_ limit: String, offset: String, success: @escaping (GPSearchViewControllerModel) -> (), failure: @escaping (Error) -> ()) {
        GPAPIRequest.trendingImage(limit, offset: offset, success: { (response) in
            if let response = response as? GPSearchViewControllerModel {
                success(response)
            } else {
                failure(GPError.customError(message: "Invalid model"))
            }
        }) { (error) in
            failure(error)
        }
    }

}
