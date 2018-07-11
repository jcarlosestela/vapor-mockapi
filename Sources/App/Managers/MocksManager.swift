//
//  MocksManager.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

class MocksManager {
    
    // MARK: - Public attributes
    
    static let shared = MocksManager()
    
    // MARK: - Private attributes
    
    private var middlewareErrors: [String: MockMiddlewareError] = [:]
    private var middlewareDelays: [String: Double] = [:]
    
    // MARK: - Public methods
    
    /// Register a middleware error
    ///
    /// - Parameters:
    ///   - error: The error type. See `MockMiddlewareError`
    ///   - path: Path of request
    func registerMiddleware(error: MockMiddlewareError, for path: String) {
        let finalPath = "/" + path
        self.middlewareErrors[finalPath] = error
    }
    
    /// Register a middleware delay
    ///
    /// - Parameters:
    ///   - delay: The delay time for responding
    ///   - path: Path of request
    func registerMiddleware(delay: Double, for path: String) {
        let finalPath = "/" + path
        self.middlewareDelays[finalPath] = delay
    }
    
    /// Returns a middleware error for the given request path
    ///
    /// - Parameter path: Path of request
    /// - Returns: a `MockMiddlewareError` or nil
    func middlewareError(for path: String) -> MockMiddlewareError? {
        return self.middlewareErrors[path]
    }
    
    /// Returns a delay for the given request path
    ///
    /// - Parameter path: Path of request
    /// - Returns: a `Double` delay time or nil
    func middlewareDelay(for path: String) -> Double? {
        return self.middlewareDelays[path]
    }
}
