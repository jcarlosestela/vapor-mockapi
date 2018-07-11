//
//  ErrorMiddlewareHandler.swift
//  App
//
//  Created by José Estela on 11/7/18.
//

import Foundation
import Vapor

enum MockMiddlewareError {
    case failEvery(HTTPResponseStatus, Int)
    case failWithProbability(HTTPResponseStatus, Float)
}

class ErrorMiddlewareHandler {
    
    // MARK: - Private attributes
    
    private var requestErrored: [String: Int] = [:]
    
    // MARK: - Public methods
    
    func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response>  {
        let path = req.http.url.path
        guard let error = MocksManager.shared.middlewareError(for: path) else {
            return try next.respond(to: req)
        }
        switch error {
        case .failEvery(let status, let timesToFail):
            let errored = self.requestErrored[path] ?? 0
            if timesToFail > errored {
                self.requestErrored[path] = errored + 1
            } else {
                self.requestErrored[path] = 0
                throw Abort(status)
            }
        case .failWithProbability(let status, let probabilityToFail):
            let number = Int(arc4random_uniform(100))
            if number < Int(probabilityToFail * 100) {
                throw Abort(status)
            }
        }
        return try next.respond(to: req)
    }
}
