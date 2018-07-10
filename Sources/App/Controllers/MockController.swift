//
//  MockController.swift
//  App
//
//  Created by José Estela on 9/7/18.
//

import Foundation
import Vapor

struct MockController: RouteCollection {
    
    /// Here we have to define all routes
    ///
    /// - Parameter router:
    /// - Throws:
    func boot(router: Router) throws {
        try MocksManager.with(
            router,
            mocks: [
                JSONFileMock(method: .GET, path: "api/test", file: "test.json"),
                ModelMock(method: .GET, path: "test2", object: Test(name: "prueba")),
                StatusMock(method: .GET, path: "test/error", status: .notAcceptable)
            ]
        )
    }
}
