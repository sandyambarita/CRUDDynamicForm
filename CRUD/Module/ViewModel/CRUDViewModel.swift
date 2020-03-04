//
//  CRUDViewModel.swift
//  CRUD
//
//  Created by sandy ambarita on 28/02/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation

class CRUDViewModel {
    var response: Response?
    var listResponse: [ListResponsePayload] = []
    var dataUpdate: ListResponsePayload?
    var metadataResponse: [MetadataPayload] = []
    var apimanager = APIManager()
    
    var isOpen: Bool = false
    var isAccessApiMovies = false
    
    func fetchResponse(params: Parameters , completion: @escaping(Response?) -> ()) {
        apimanager.getCRUD(params: params, completionHandler: { (data) in
            if data != nil {
                do {
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(Response.self, from: data!)
                    if responses.errorCode == 0 {
                        self.response = responses
                        completion(self.response)
                    } else {
                        print(responses.errorMessage ?? "")
                    }
                } catch {
                    print("error trying to convert data to JSON: \(error)")
                }
            } else {
                print("nil")
            }
        })
    }
    
    func fetchListResponse(params: Parameters , completion: @escaping([ListResponsePayload]?) -> ()) {
        apimanager.getCRUD(params: params, completionHandler: { (data) in
            if data != nil {
                do {
                    let decoder = JSONDecoder()
                    let listResponses = try decoder.decode(ListResponse.self, from: data!)
                    if listResponses.errorCode == 0 {
                        self.listResponse = listResponses.payload!
                        completion(self.listResponse)
                    } else {
                        print(listResponses.errorMessage ?? "")
                    }
                    
                } catch {
                    print("error trying to convert data to JSON: \(error)")
                }
            } else {
                print("nil")
            }
        })
    }
    
    func fetchMetadata(params: Parameters , completion: @escaping([MetadataPayload]?) -> ()) {
        apimanager.getCRUD(params: params, completionHandler: { (data) in
            if data != nil {
                do {
                    let decoder = JSONDecoder()
                    let metadataResponses = try decoder.decode(Metadata.self, from: data!)
                    if metadataResponses.errorCode == 0 {
                        self.metadataResponse = metadataResponses.payload!
                        completion(self.metadataResponse)
                    } else {
                        print(metadataResponses.errorMessage ?? "")
                    }
                } catch {
                    print("error trying to convert data to JSON: \(error)")
                }
            } else {
                print("nil")
            }
        })
    }
    
    func numberOfRowsInSection() -> Int {
        return self.listResponse.count
    }
    
    func metaAtIndex(index: Int) -> ListResponsePayload {
        let listResponse = self.listResponse[index]
        return listResponse
    }
    
}
