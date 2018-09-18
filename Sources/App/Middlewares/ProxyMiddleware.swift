//
//  RedirectMiddleware.swift
//  App
//
//  Created by José Estela on 20/7/18.
//

import Foundation
import Vapor

/// This middleware provides the feature of calling to your original API with the same params & headers received
final class ProxyMiddleware: Middleware {
    
    // MARK: - Private attributes
    
    private let routes: [String]
    private let url: String
    private let saveResponses: Bool
    
    // MARK: - Public methods
    
    /// Instantiate a new ProxyMiddleware providing the url of your server API and the routes that you don't want to manage in the MockAPI
    /// Example of usage:
    /// middlewares.use(ProxyMiddleware(to: "https://yourapi.com", routes: router.routes))
    /// That means that any request with different path to the paths included in `router.routes` will be requested to `https://yourapi.com` with the same params & headers.
    ///
    /// - Parameters:
    ///   - url: The url of your final API
    ///   - routes: The routes to be ignored
    ///   - savingResponses: Indicates to ProxyMiddleware if you want to save the responses of routes not included in the 'routes' param. (default false)
    init(to url: String, whenNotIn routes: [Route<Responder>], savingResponses saveResponses: Bool = false) {
        self.routes = routes.readableRoutes()
        self.url = url
        self.saveResponses = saveResponses
    }
    
    /// Instantiate a new ProxyMiddleware providing the url of your server API and the routes that you don't want to manage in the MockAPI
    /// Example of usage:
    /// middlewares.use(ProxyMiddleware(to: "https://yourapi.com", routes: ["/GET/api/v1/login"]))
    /// That means that any request with different path to "/GET/api/v1/login" will be requested to `https://yourapi.com` with the same params & headers.
    ///
    /// - Parameters:
    ///   - url: The url of your final API
    ///   - routes: The routes to be ignored
    ///   - savingResponses: Indicates to ProxyMiddleware if you want to save the responses of routes not included in the 'routes' param. (default false)
    init(to url: String, whenNotIn routes: [String], savingResponses saveResponses: Bool = false) {
        self.routes = routes
        self.url = url
        self.saveResponses = saveResponses
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
            let response = client.send(req)
            if self.saveResponses {
                response.whenSuccess { response in
                    self.saveResponse(response, of: request)
                }
            }
            return response
        }
        return try next.respond(to: request)
    }
    
    private func saveResponse(_ response: Response, of request: Request) {
        guard
            let responseData = response.http.body.data,
            let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments),
            let json = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        else {
            return
        }
        let body: String? = {
            if let data = request.http.body.data {
                return data.base64EncodedString()
            }
            return nil
        }()
        let path = request.http.url.path.convertToPathComponents().readable.replacingOccurrences(of: "/", with: "_") + ".json"
        FileManager.default.createFile(
            atPath: DirectoryConfig.detect().workDir + "Public/" + (body ?? "") + String(describing: request.http.method) + path,
            contents: json,
            attributes: nil
        )
    }
}

extension Array where Element == Route<Responder> {
    
    func readableRoutes() -> [String] {
        return self.map({ $0.path.readable })
    }
}
