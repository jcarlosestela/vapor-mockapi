import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(MockMiddleware()) // A middleware for adding features to mock reponses
    // middlewares.use(GatewayMiddleware(to: "https://path/to/your/ws", whenNotIn: router.routes))
    // middlewares.use(GatewayMiddleware(to: "https://path/to/your/ws", whenNotIn: ["/GET/v1/api/test"]))
    services.register(middlewares)
}
