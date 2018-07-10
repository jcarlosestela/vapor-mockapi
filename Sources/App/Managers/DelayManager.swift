//
//  DelayManager.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

struct MockDelay: Equatable, Hashable {
    
    let path: String
    let delay: Double
    
    var hashValue: Int {
        return self.path.hashValue
    }
    
    static func == (lhs: MockDelay, rhs: MockDelay) -> Bool {
        return lhs.path == rhs.path
    }
}

class DelayManager {
    
    // MARK: - Private attributes
    
    private var delays = Set<MockDelay>()
    
    // MARK: - Public methods
    
    func register(_ delay: MockDelay) {
        self.delays.insert(delay)
    }
    
    func handle(mock: Mockable, on req: Request, response: Response) throws -> Future<Response> {
        guard let mockDelay = self.delays.filter({ $0.path == mock.path }).first else {
            return try mock.handleResponse(req)
        }
        let responsePromise = req.next().newPromise(Response.self)
        delay(mockDelay.delay) {
            responsePromise.succeed(result: response)
        }
        return responsePromise.futureResult
    }
}
