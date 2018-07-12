//
//  StatusMock.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

/// Mock for returning a http status without any body.
/// An example of usage
/// StatusMock(method: .POST, path: "api/users", status: .created)
struct StatusMock: Mockable {
    
    let method: HTTPMethod
    let path: String
    let status: HTTPResponseStatus
    
    func handleResponse(_ req: Request) throws -> Future<Response> {
        let response = req.makeResponse(http: HTTPResponse(status: self.status))
        return req.future(response)
    }
}
