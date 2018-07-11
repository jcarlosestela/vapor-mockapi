//
//  MockMiddleware.swift
//  App
//
//  Created by José Estela on 11/7/18.
//

import Foundation
import Vapor

/// This middleware provides some features for Mock requests
final class MockMiddleware: Middleware, ServiceType {
    
    // MARK: - Private attributes
    
    private let errorMiddlewareHandler = ErrorMiddlewareHandler()
    private let delayMiddlewareHandler = DelayMiddlewareHandler()
    
    // MARK: - Public methods
    
    static func makeService(for worker: Container) throws -> MockMiddleware {
        return .init()
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        return try self.delayMiddlewareHandler.respond(to: request, chainingTo: next).flatMap(to: Response.self) { _ in
            return try self.errorMiddlewareHandler.respond(to: request, chainingTo: next)
        }
    }
}
