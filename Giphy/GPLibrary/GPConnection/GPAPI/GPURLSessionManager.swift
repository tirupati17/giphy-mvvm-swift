//
//  GPURLSessionManager.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

class GPURLSessionManager : URLSession {
    class var defaultSharedInstance : URLSession {
        struct defaultSingleton {
            static let instance = URLSession(configuration: .default)
        }
        return defaultSingleton.instance
    }
    
    class var ephemeralSharedInstance : URLSession {
        struct ephemeralSingleton {
            static let instance = URLSession(configuration: .ephemeral)
        }
        return ephemeralSingleton.instance
    }
    
    class var backgroundSharedInstance : URLSession {
        struct backgroundSingleton {
            static let instance = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: GPConstant.AppBundleName))
        }
        return backgroundSingleton.instance
    }
    
    class func performRequest(_ apiRequest: GPAPIRequest, success: ((JSON) ->
        Void)!, failure:((Error) -> Void)!) -> URLSessionTask {
        let fullUrlString = self.fullPathForRequest(apiRequest)
        
        let url = URL(string: fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        
        GPLogger.log(fullUrlString)
        GPLogger.log(apiRequest.params)
        
        var sessionTask : URLSessionTask!
        switch apiRequest.requestMethod {
            case GPRequestMethod.RequestMethodGet?:
                sessionTask = GPURLSessionManager.defaultSharedInstance.dataTask(with: url!, completionHandler: { (data, response, error) in
                    self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
                })
                sessionTask.resume()
                break
            case GPRequestMethod.RequestMethodPost?:
                request.httpMethod = "POST"
                request.setValue(apiRequest.contentType, forHTTPHeaderField: "Content-Type")
                if let httpBody = try? JSONSerialization.data(withJSONObject: apiRequest.params, options: [])  {
                    request.httpBody = httpBody
                }
                
                sessionTask = GPURLSessionManager.defaultSharedInstance.dataTask(with: request, completionHandler: { (data, response, error) in
                    self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
                })
                sessionTask.resume()
                break
            case GPRequestMethod.RequestMethodPut?:
                request.httpMethod = "PUT"
                request.setValue(apiRequest.contentType, forHTTPHeaderField: "Content-Type")
                
                if let httpBody = try? JSONSerialization.data(withJSONObject: apiRequest.params, options: [])  {
                    request.httpBody = httpBody
                }
                sessionTask = GPURLSessionManager.defaultSharedInstance.dataTask(with: request, completionHandler: { (data, response, error) in
                    self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
                })
                sessionTask.resume()
                break
            case GPRequestMethod.RequestMethodDelete?:
                request.httpMethod = "DELETE"
                sessionTask = GPURLSessionManager.defaultSharedInstance.dataTask(with: request, completionHandler: { (data, response, error) in
                    self.responseHandle(data: data, response: response, error: error, success: success, failure: failure)
                })
                sessionTask.resume()
                break
            default:
                break
        }
        return sessionTask;
    }
    
    class func responseHandle(data : Data?, response : URLResponse?, error : Error?, success: ((JSON) ->
        Void)!, failure:((Error) -> Void)!) {
        if let error = error {
            failure(error)
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            let error: LocalizedDescriptionError = GPError.customError(message: "Invalid response")
            failure(error)
            return
        }
        var responseError = ResponseError(message: "")
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            do {
                responseError = try JSONDecoder().decode(ResponseError.self, from: data)
            } catch {
                GPLogger.log(dataString)
            }
        }
        let customMessage = responseError.message
        switch (response.statusCode) {
            case 200...299:
                success(data as JSON)
                break
            case 403:
                let error: LocalizedDescriptionError = GPError.customError(message: customMessage ?? "Invalid authentication credentials")
                failure(error)
                break
            case 404:
                let error: LocalizedDescriptionError = GPError.customError(message: customMessage ?? "Not Found")
                failure(error)
                break
            case 422:
                let error: LocalizedDescriptionError = GPError.customError(message: customMessage ?? "Validation Errors")
                failure(error)
                break
            case 500:
                let error: LocalizedDescriptionError = GPError.customError(message: customMessage ?? "Internal Server Error")
                failure(error)
                break
            default:
                let error: LocalizedDescriptionError = GPError.customError(message: customMessage ?? "Invalid status code")
                failure(error)
        }
    }
    
    class func fullPathForRequest(_ apiRequest : GPAPIRequest) -> String {
        var fullPath = self.fullPathWithUrlString(apiRequest.urlString!, apiRequest.requestType!)
        switch apiRequest.requestType {
            case .APIRequestSearch?:
                fullPath = "\(GPAPIConstant.sharedConstant.baseUrl())\(fullPath)"
                break
            default:
                fullPath = "\(GPAPIConstant.sharedConstant.baseUrl())\(fullPath)"
                break
        }
        return fullPath
    }
    
    class func fullPathWithUrlString(_ urlString : String, _ apiRequestType : GPAPIRequestType) -> String {
        if (!urlString.isEmpty) {
            var apiVersion = ""
            switch apiRequestType {
                case .APIRequestSearch:
                    apiVersion = GPAPIConstant.apiVersion1
                    break
                default:
                    apiVersion = GPAPIConstant.apiVersion1
                    break
            }
            return String.init(format: "%@%@", apiVersion, urlString)
        } else {
            GPLogger.log("Empty URL string")
            return ""
        }
    }
    
    class func createBody(parameters: [String: Any],
                          boundary: String,
                          requestType: GPAPIRequestType,
                          data: Data?,
                          mimeType: String?,
                          filename: String?) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        if let filename = filename {
            body.appendString("Content-Disposition: form-data; name=\"zipMultipartFile\"; filename=\"\(filename)\"\r\n")
        }
        if let mimeType = mimeType {
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        }
        if let data = data {
            body.append(data)
        }
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--\r\n")))
        
        return body as Data
    }
}
