//
//  Response.swift
//  CRUD
//
//  Created by sandy ambarita on 28/02/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation

//Delete/Update/Insert
struct Response: Codable {
    let errorCode: Int?
    let errorMessage: String?
}
