//  
//  GPSearchViewControllerServiceProtocol.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

protocol GPSearchViewControllerServiceProtocol {
    func searchImage(_ query : String, limit: String, offset: String, success: @escaping (GPSearchViewControllerModel) -> (), failure: @escaping (Error) -> ())
    func trendingImage(_ limit: String, offset: String, success: @escaping (GPSearchViewControllerModel) -> (), failure: @escaping (Error) -> ())
}
