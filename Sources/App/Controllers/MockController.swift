//
//  MockController.swift
//  App
//
//  Created by Eduardo González on 29/10/2018.
//

import Foundation
import Vapor

struct MockController {
    
    let mock: Mockable
    
    func handleResponse(_ req: Request) throws -> Future<HTTPResponse> {
        var response = HTTPResponse()
        // Add Status
        response.status = HTTPResponseStatus(statusCode: mock.code)
        
        // Add Body
        if let data = mock.payload {
            response.body = HTTPBody(data: data)
        }
        
        // Headers
        var headers = HTTPHeaders()
        if let mockHeaders = mock.headers {
            for header in mockHeaders {
                headers.add(name: header.key, value: header.value)
            }
            response.headers = headers
        }
        return req.future(response)
    }
}
