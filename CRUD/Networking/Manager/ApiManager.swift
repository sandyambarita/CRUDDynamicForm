//
//  ApiManager.swift
//  CRUD
//
//  Created by sandy ambarita on 28/02/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    func getCRUD(params: Parameters, completionHandler: @escaping (Data?) -> ()) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        Connection.request(.post, url: "\(Endpoint.CRUD)", parameters: params, headers: headers) { (data, statusCode, error) in
            if error == nil {
                if statusCode == 200 {
                    completionHandler(data)
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
}
