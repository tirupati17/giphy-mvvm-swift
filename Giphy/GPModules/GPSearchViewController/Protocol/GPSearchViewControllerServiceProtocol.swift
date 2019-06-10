//  
//  GPSearchViewControllerServiceProtocol.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

protocol GPSearchViewControllerServiceProtocol {
    func searchImage(_ query : String, success: @escaping(_ data: GPSearchViewControllerModel) -> (), failure: @escaping(Error) -> ())
}
