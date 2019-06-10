//
//  GPAPIRequest.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

class GPAPIRequest {
    var urlString: String?
    
    var contentType: String = "application/json"
    var mimeType: String = ""
    var fileName: String = ""
    var boundary: String = ""
    
    var params: [String: Any] = [:]
    var requestType: GPAPIRequestType?
    var requestMethod: GPRequestMethod?
    var dataRequest: URLSessionTask!
    
    var completed:Bool? = false
    var data: Data? = nil
    
    init(requestType : GPAPIRequestType? = nil) {
        self.requestType = requestType
    }
    
    func performRequest() {
        self.performRequestWith(success: nil, failure: nil)
    }
    
    func performRequestWith(success:((JSON) -> ())!, failure:((Error) -> ())!) {
        self.dataRequest = GPURLConnectionManager.sharedInstance.connectionWithRequest(self, success: success, failure: failure)
    }
    
    func cancelRequest() {
        self.dataRequest.cancel()
    }
    
    func requestWithUrlString(_ urlString:String? = "", requestMethod: GPRequestMethod? = nil, params:[String:Any]? = [:], data:Data?, success:((JSON) -> ())?, failure:((Error) -> ())?) {
        self.urlString = urlString
        self.params = params!
        self.requestMethod = requestMethod
        self.data = data
        self.performRequestWith(success: success!, failure: failure)
    }
    
}
