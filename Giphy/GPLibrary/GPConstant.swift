//
//  GPConstant.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

struct GPConstant {
    static var AppBundleName : String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    static let GiphyApiKey : String = "f17r5KnPju9n7OG3EK9VT1pTnEzIyULh"
}
