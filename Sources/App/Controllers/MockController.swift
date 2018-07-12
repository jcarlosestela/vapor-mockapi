//
//  MockController.swift
//  App
//
//  Created by José Estela on 9/7/18.
//

import Foundation
import Vapor

struct MockController: RouteCollection {
    
    func boot(router: Router) throws {
        try router.register(mocks: [
            // JSONFileMock(method: .GET, path: "api/test", file: "test.json").delay(1.0).fail(with: .badGateway, every: 1),
            // ModelMock(method: .GET, path: "api/test2", object: AnyObject(name: "test")),
            // StatusMock(method: .GET, path: "api/test/error", status: .notAcceptable).delay(1.5)
        ])
    }
}

extension Router {
    
    func register(mocks: [Mockable]) throws {
        try mocks.forEach { mock in
            try mock.addRoute(to: self)
        }
    }
}
