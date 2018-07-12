//
//  ModelMock.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

/// A model mock. You have to use an object that conforms the `Codable` protocol.
/// An example of usage:
/// ModelMock(method: .GET, path: "api/users", object: User(name: "mock user"))
struct ModelMock<T: Codable>: Mockable {
    
    let method: HTTPMethod
    let path: String
    let object: T
    
    func handleResponse(_ req: Request) throws -> Future<Response> {
        let data = try JSONEncoder().encode(self.object)
        let response = req.makeResponse(HTTPBody(data: data))
        return req.future(response)
    }
}
