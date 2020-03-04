//
//  ListResponse.swift
//  CRUD
//
//  Created by sandy ambarita on 28/02/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation

struct ListResponse: Codable {
    let errorCode: Int?
    let errorMessage: String?
    let payload: [ListResponsePayload]?
}

struct ListResponsePayload: Codable {
    let crudId: String?
    let crudName: String?
    let crudDescription: String?
    let crudColor: String?
    let crudStatus: String?
    let crudTimestamp: String?
    
    public enum CodingKeys: String, CodingKey{
        case crudId = "crud_id"
        case crudName = "crud_name"
        case crudDescription = "crud_description"
        case crudColor = "crud_color"
        case crudStatus = "crud_status"
        case crudTimestamp = "crud_timestamp"
    }
}
