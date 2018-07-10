//
//  ModelMock.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

struct ModelMock<T: Codable>: Mockable {
    
    var method: HTTPMethod
    var path: String
    var object: T
    
    func handleResponse(_ req: Request) throws -> Future<Response> {
        let data = try JSONEncoder().encode(self.object)
        let response = req.makeResponse(HTTPBody(data: data))
        return req.future(response)
    }
}
