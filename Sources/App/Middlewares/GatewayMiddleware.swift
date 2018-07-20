//
//  RedirectMiddleware.swift
//  App
//
//  Created by José Estela on 20/7/18.
//

import Foundation
import Vapor

/// This middleware provides the feature of calling to your original API with the same params & headers received
final class GatewayMiddleware: Middleware {
    
    // MARK: - Private attributes
    
    private let routes: [String]
    private let url: String
    
    // MARK: - Public methods
    
    /// Instantiate a new GatewayMiddleware providing the url of your server API and the routes that you don't want to manage in the MockAPI
    /// Example of usage:
    /// middlewares.use(GatewayMiddleware(to: "https://yourapi.com", routes: router.routes))
    /// That means that any request with different path to the paths included in `router.routes` will be requested to `https://yourapi.com` with the same params & headers.
    ///
    /// - Parameters:
    ///   - url: The url of your final API
    ///   - routes: The routes to be ignored
    init(to url: String, whenNotIn routes: [Route<Responder>]) {
        self.routes = routes.readableRoutes()
        self.url = url
    }
    
    /// Instantiate a new GatewayMiddleware providing the url of your server API and the routes that you don't want to manage in the MockAPI
    /// Example of usage:
    /// middlewares.use(GatewayMiddleware(to: "https://yourapi.com", routes: ["/GET/api/v1/login"]))
    /// That means that any request with different path to "/GET/api/v1/login" will be requested to `https://yourapi.com` with the same params & headers.
    ///
    /// - Parameters:
    ///   - url: The url of your final API
    ///   - routes: The routes to be ignored
    init(to url: String, whenNotIn routes: [String]) {
        self.routes = routes
        self.url = url
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let requestPath = "/" + request.http.method.string + request.http.url.path.convertToPathComponents().readable
        if !self.routes.contains(requestPath) {
            var httpRequest = HTTPRequest(
                method: request.http.method,
                url: self.url + request.http.url.absoluteString,
                headers: request.http.headers,
                body: request.http.body
            )
            httpRequest.headers.remove(name: .host)
            let req = Request(http: httpRequest, using: request)
            let client = try request.client()
            return client.send(req)
        }
        return try next.respond(to: request)
    }
}

extension Array where Element == Route<Responder> {
    
    func readableRoutes() -> [String] {
        return self.map({ $0.path.readable })
    }
}
