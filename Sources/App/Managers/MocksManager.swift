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
    
    private let errorManager = ErrorManager()
    private let delayManager = DelayManager()
    
    // MARK: - Public methods
    
    func register(error: MockError) {
        self.errorManager.register(error)
    }
    
    func register(delay: MockDelay) {
        self.delayManager.register(delay)
    }
    
    func handle(mock: Mockable, on req: Request) throws -> Future<Response> {
        return try self.errorManager.handle(mock: mock, on: req).flatMap(to: Response.self) { response in
            return try self.delayManager.handle(mock: mock, on: req, response: response)
        }
    }
}
