//
//  Router+register.swift
//  App
//
//  Created by Eduardo González on 29/10/2018.
//

import Foundation
import Vapor

extension Router {
    func add(mocks: [Mockable]) throws {
        try mocks.forEach { mock in
            try addRoute(for: mock)
        }
    }
    func addRoute(for mock: Mockable) throws {
        let mockController = MockController(mock: mock)
        on(mock.method, at: mock.path, use: mockController.handleResponse)
    }
}
