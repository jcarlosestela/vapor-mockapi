//
//  StatusMock.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

struct StatusMock: Mockable {
    
    let method: HTTPMethod
    let path: String
    let status: HTTPStatus
    
    func handleResponse(_ req: Request) throws -> Future<Response> {
        let response = req.makeResponse(http: HTTPResponse(status: self.status))
        return req.future(response)
    }
}
