import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    try router.register(collection: RoutesMockCollection())
}

struct RoutesMockCollection: RouteCollection {
    
    func boot(router: Router) throws {
        try router.add(mocks: [
            Mock(method: .GET, path: "test1", code: 200, file: "test.json").delay(1.0).fail(with: .badGateway, every: 1),
            Mock(method: .GET, path: "test2", code: 200, model: ModelTest(name: "model test")),
            Mock(method: .GET, path: "test3", code: 503)
            ])
    }
}

struct ModelTest: Codable {
    let name: String
}
