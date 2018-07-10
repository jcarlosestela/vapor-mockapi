//
//  MocksManager.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

struct MocksManager {
    
    static func with(_ router: Router, mocks: [Mockable]) throws {
        try mocks.forEach { mock in
            try router.add(mock)
        }
    }
}

private extension Router {
    
    func add(_ mock: Mockable) throws {
        try mock.addRoute(to: self)
    }
}
