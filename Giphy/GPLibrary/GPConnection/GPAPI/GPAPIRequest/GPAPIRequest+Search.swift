//
//  GPAPIRequest+Search.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

extension GPAPIRequest {
    class func seachImage(_ query : String, limit : String, offset : String, success : ((JSON) -> ())?, failure : ((Error) -> ())?) {
        let apiRequest = GPAPIRequest.init(requestType: GPAPIRequestType.APIRequestSearch)
        let urlString = GPAPIStringUrl.searchEndpoint(GPConstant.GiphyApiKey, query: query, limit: limit, offset: offset)
        
        apiRequest.requestWithUrlString(urlString,
                                        requestMethod: GPRequestMethod.RequestMethodGet,
                                        params: [:],
                                        data : nil,
                                        success : success,
                                        failure : failure)
    }
    
    class func trendingImage(_ limit : String, offset : String, success : ((JSON) -> ())?, failure : ((Error) -> ())?) {
        let apiRequest = GPAPIRequest.init(requestType: GPAPIRequestType.APIRequestSearch)
        let urlString = GPAPIStringUrl.trendingEndpoint(GPConstant.GiphyApiKey, limit: limit, offset: offset)
        
        apiRequest.requestWithUrlString(urlString,
                                        requestMethod: GPRequestMethod.RequestMethodGet,
                                        params: [:],
                                        data : nil,
                                        success : success,
                                        failure : failure)
    }
}
