//
//  MockGPSearchViewControllerService.swift
//  GiphyTests
//
//  Created by Tirupati Balan on 14/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation
import XCTest

@testable import Giphy

class MockGPSearchViewControllerService : GPSearchViewControllerServiceProtocol {
    
    var searchViewControllerModel : GPSearchViewControllerModel!
    
    init() {
        self.searchViewControllerModel = GPSearchViewControllerModelTests().returnGPSearchViewControllerModel()
    }
    
    func searchImage(_ query : String, limit: String, offset: String, success: @escaping (GPSearchViewControllerModel) -> (), failure: @escaping (Error) -> ()) {
        success(self.searchViewControllerModel)
    }
    
    func trendingImage(_ limit: String, offset: String, success: @escaping (GPSearchViewControllerModel) -> (), failure: @escaping (Error) -> ()) {
        success(self.searchViewControllerModel)
    }

}
