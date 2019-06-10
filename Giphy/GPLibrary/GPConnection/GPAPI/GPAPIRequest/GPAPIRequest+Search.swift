//
//  GPAPIRequest+Search.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

extension GPAPIRequest {
    class func seachImage(_ query : String, limit : String? = "10", count : String? = "10", offset : String? = "0", success : ((JSON) -> ())?, failure : ((Error) -> ())?) {
        let apiRequest = GPAPIRequest.init(requestType: GPAPIRequestType.APIRequestSearch)
        let urlString = GPAPIStringUrl.searchEndpoint(GPConstant.GiphyApiKey, query: query, limit: limit!, count: count!, offset: offset!) //Well lets use force unwraping for limit, count, offset because we already defined default value
        
        apiRequest.requestWithUrlString(urlString,
                                        requestMethod: GPRequestMethod.RequestMethodGet,
                                        params: [:],
                                        data : nil,
                                        success : success,
                                        failure : failure)
    }
}
