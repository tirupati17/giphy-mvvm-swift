//
//  GPURLConnectionManager.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

class GPURLConnectionManager {
    class var sharedInstance : GPURLConnectionManager {
        struct Singleton {
            static let instance = GPURLConnectionManager()
        }
        
        return Singleton.instance
    }
    
    func shouldReadResponseForRequest(_ apiRequest : GPAPIRequest) -> Bool  {
        switch apiRequest.requestType {
            case GPAPIRequestType.APIRequestSearch?:
                return true
            default:
                return false
        }
    }
    
    func connectionWithRequest(_ apiRequest: GPAPIRequest) -> URLSessionTask {
        return self.connectionWithRequest(apiRequest, success: nil, failure: nil)
    }
    
    func connectionWithRequest(_ apiRequest: GPAPIRequest, success: ((JSON) ->
        Void)!, failure:((Error) -> Void)!) -> URLSessionTask {
        UIApplication.showNetworkActivity()
        var dataRequest : URLSessionTask!
        dataRequest = GPURLSessionManager.performRequest(apiRequest, success: { (response) in
            UIApplication.hideNetworkActivity()
            self.didPerformRequest(apiRequest)
            self.request(apiRequest, didReceiveResponse: response, success: success)
        }, failure: { (error) in
            UIApplication.hideNetworkActivity()
            self.didPerformRequest(apiRequest)
            self.remoteRequestDidFail(apiRequest, error, failure: failure)
        })
        
        return dataRequest
    }
    
    func request(_ apiRequest: GPAPIRequest, didReceiveResponse response : JSON, success: ((JSON) ->
        Void)!) { //handle response either insert into database and notify controller or use local notification to notifiy
        
        switch apiRequest.requestType {
            case .APIRequestSearch?:
                if let response = response as? Data {
                    do {
                        let responseObject = try JSONDecoder().decode(GPSearchViewControllerModel.self, from: response)
                        success(responseObject as JSON)
                    } catch let error {
                        GPLogger.log(error.localizedDescription)
                        success(response as JSON)
                    }
                } else {
                    success(response as JSON)
                }
                break
            default:
                success(response as JSON)
                break
        }
    }
    
    func didPerformRequest(_ apiRequest : GPAPIRequest) {
        apiRequest.completed = true
    }
    
    func remoteRequestDidFail(_ apiRequest: GPAPIRequest, _ error : Error, failure:((Error) -> Void)!) { //handle error with custom error and use local notification for error
        failure(error)
    }
}
