//
//  DelayMiddlewareHandler.swift
//  App
//
//  Created by José Estela on 11/7/18.
//

import Foundation
import Vapor

class DelayMiddlewareHandler {
    
    func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response>  {
        let path = req.http.url.path
        guard let delayTime = MocksManager.shared.middlewareDelay(for: path) else {
            return try next.respond(to: req)
        }
        let responsePromise = req.next().newPromise(Response.self)
        delay(delayTime) {
            try? responsePromise.succeed(result: next.respond(to: req).wait())
        }
        return responsePromise.futureResult
    }
}
