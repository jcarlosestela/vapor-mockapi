//
//  Mockable.swift
//  App
//
//  Created by José Estela on 9/7/18.
//

import Foundation
import Vapor

/// Protocol that have to conform all your custom Mocks
protocol Mockable {
    
    /// The http method accepted by the request
    var method: HTTPMethod { get }
    
    /// The path for the request
    var path: String { get }

    /// The response code
    var code: Int { get }
    
    /// Payload for response
    var payload: Data? { get }
    
    /// Optional headers to return
    var headers: [String: String]? { get }
}

extension Mockable {
    /// Call this method if you want that your request fail every X times.
    /// Example of usage:
    /// let mock = JSONFileMock(...).fail(with: .badRequest, every: 2)
    /// This means that the request is going to fail the third time you call it.
    ///
    /// - Parameters:
    ///   - status: the http status to send when the request fail
    ///   - every: the times that you want that your request be successful
    /// - Returns: the mockable instance itself
    func fail(with status: HTTPResponseStatus, every: Int) -> Mockable {
        MocksManager.shared.registerMiddleware(error: .failEvery(status, every), for: self.path)
        return self
    }
    
    /// Call this method if you want that your request fail with a probability X.
    /// Example of usage:
    /// let mock = JSONFileMock(...).fail(with: .badRequest, probability: 0.8)
    /// This means that the request is going to fail with a probability of 80%
    ///
    /// - Parameters:
    ///   - status: the http status to send when the request fail
    ///   - probability: the probability of fail
    /// - Returns: the mockable instance itself
    func fail(with status: HTTPResponseStatus, probability: Float) -> Mockable {
        MocksManager.shared.registerMiddleware(error: .failWithProbability(status, probability), for: self.path)
        return self
    }
    
    /// Call this method if you want a delay in your request response
    /// Example of usage:
    /// let mock = JSONFileMock(...).delay(1.0)
    ///
    /// - Parameter delay: the time in seconds
    /// - Returns: the mockable instance itself
    func delay(_ delay: Double) -> Mockable {
        MocksManager.shared.registerMiddleware(delay: delay, for: self.path)
        return self
    }
}

