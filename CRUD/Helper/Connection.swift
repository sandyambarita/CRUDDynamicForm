//
//  Connection.swift
//  CRUD
//
//  Created by sandy ambarita on 28/02/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation
import UIKit

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public typealias Parameters = [String: Any]?
public typealias HTTPHeaders = [String: String]?

open class Connection {
    open class func request(_ method: HTTPMethod, url: String, parameters: Parameters = nil, headers: HTTPHeaders = nil, completionHandler: @escaping (Data?, Int?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        print("request\(request)")
        if method == .post && parameters != nil {
            let data = try! JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            request.httpBody = json?.data(using: String.Encoding.utf8.rawValue)
    
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                let httpResponse = urlResponse as? HTTPURLResponse
                if data != nil {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print(String(decoding: jsonData, as: UTF8.self))
                    } else {
                        print("json data malformed")
                    }
                }
                
                if httpResponse?.statusCode == 500 {
                    print("error")
                    completionHandler(data, httpResponse?.statusCode, error)
                } else if httpResponse == nil {
                    print("error")
                    completionHandler(data, httpResponse?.statusCode, error)
                    
                    return
                } else if error == nil {
                    completionHandler(data, httpResponse?.statusCode, nil)
                } else {
                    print("error")
                    completionHandler(data, httpResponse?.statusCode, error)
                    
                    return
                }
            }
        }
        task.resume()
        
    }
}
