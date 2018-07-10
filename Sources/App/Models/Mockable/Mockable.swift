//
//  Mockable.swift
//  App
//
//  Created by José Estela on 9/7/18.
//

import Foundation
import Vapor

protocol Mockable {
    
    var method: HTTPMethod { get }
    var path: String { get }
    
    func addRoute(to router: Router) throws
    func handleResponse(_ req: Request) throws -> Future<Response>
}

extension Mockable {
    
    func addRoute(to router: Router) throws {
        router.on(self.method, at: self.path) { req in
            try ErrorManager.default.handle(mock: self, on: req)
        }
    }
    
    func fail(with status: HTTPResponseStatus, every: Int) -> Mockable {
        ErrorManager.default.register(MockError(path: self.path, status: status, every: every))
        return self
    }
    
    func fail(with status: HTTPResponseStatus, probability: Float) -> Mockable {
        ErrorManager.default.register(MockError(path: self.path, status: status, probability: probability))
        return self
    }
}

