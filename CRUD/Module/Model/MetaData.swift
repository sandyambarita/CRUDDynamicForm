//
//  CRUD.swift
//  CRUD
//
//  Created by sandy ambarita on 28/02/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation

struct Metadata: Codable {
    let errorCode: Int?
    let errorMessage: String?
    let payload: [MetadataPayload]?
}

struct MetadataPayload: Codable {
    let field: String?
    let type: String?
    let maxLength: String?
    let input: String?
    let accepted: String?
}

